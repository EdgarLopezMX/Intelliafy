import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intelliafy_app/providers/auth_notifier.dart';
import 'package:intelliafy_app/widgets/profile/header_curved.dart';
import 'package:intelliafy_app/widgets/tests/tittle_text.dart';
import 'package:provider/provider.dart';

class UploadQuestions extends StatefulWidget {
  const UploadQuestions({
    super.key,
  });

  @override
  State<UploadQuestions> createState() => _UploadDynamicTest();
}

class _UploadDynamicTest extends State<UploadQuestions> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final List<Map<String, dynamic>> _questions = [
    {
      'question': '',
      'answers': [],
      'correctAnswerIndex': -1,
    },
  ];

  void _addQuestion() {
    setState(() {
      _questions.add({
        'question': '',
        'answers': [],
        'correctAnswerIndex': -1,
      });
    });
    _listKey.currentState?.insertItem(_questions.length - 1,
        duration: const Duration(milliseconds: 400));
  }

  void _removeQuestion(
      int index, Color accentColor, Color primaryColor, Color surfaceColor) {
    final removedItem = _questions[index];
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: FadeTransition(
          opacity: animation,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: _buildQuestionCard(
                index, removedItem, accentColor, primaryColor, surfaceColor),
          ),
        ),
      ),
      duration: const Duration(milliseconds: 300),
    );
    setState(() {
      _questions.removeAt(index);
    });
  }

  void _submitTest(Color accentColor, Color surfaceColor) async {
    final auth = Provider.of<AuthNotifier>(context, listen: false);

    for (var i = 0; i < _questions.length; i++) {
      if (_questions[i]['question'].isEmpty) {
        Fluttertoast.showToast(msg: "Question ${i + 1} is empty");
        return;
      }
      if (_questions[i]['answers'].length < 2) {
        Fluttertoast.showToast(
            msg: "Question ${i + 1} needs at least 2 answers");
        return;
      }
      if (_questions[i]['correctAnswerIndex'] == -1) {
        Fluttertoast.showToast(
            msg: "Select the correct answer for question ${i + 1}");
        return;
      }
    }

    bool success = await auth.uploadCompleteTest(_questions);

    if (!mounted) return;

    if (success) {
      Fluttertoast.showToast(
          msg: 'Test added successfully!',
          backgroundColor: surfaceColor,
          textColor: accentColor);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: 'Error: ${auth.errorMessage}',
          backgroundColor: Colors.redAccent);
    }
  }

  Widget _buildQuestionCard(int index, Map<String, dynamic> question,
      Color accentColor, Color primaryColor, Color surfaceColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: surfaceColor),
        borderRadius: BorderRadius.circular(25),
        color: surfaceColor,
        boxShadow: [
          BoxShadow(
            color: accentColor,
            spreadRadius: 2,
            blurRadius: 1,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textTitles(label: 'Question ${index + 1}:', color: primaryColor),
              if (_questions.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete, size: 24),
                  color: Colors.redAccent,
                  onPressed: () => _removeQuestion(
                      index, accentColor, primaryColor, surfaceColor),
                ),
            ],
          ),
          TextFormField(
            initialValue: question['question'],
            onChanged: (value) {
              setState(() {
                question['question'] = value;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textTitles(label: 'Answer:', color: primaryColor),
              IconButton(
                icon: const Icon(Icons.add),
                color: accentColor,
                iconSize: 30,
                onPressed: () {
                  setState(() {
                    question['answers'].add('');
                  });
                },
              ),
            ],
          ),
          Column(
            children: List.generate(
              question['answers'].length,
              (answerIndex) => Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          question['correctAnswerIndex'] == answerIndex
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: question['correctAnswerIndex'] == answerIndex
                              ? accentColor
                              : primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            question['correctAnswerIndex'] = answerIndex;
                          });
                        },
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: question['answers'][answerIndex],
                          decoration: InputDecoration(
                              hintText: 'Add answer: ',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: primaryColor,
                              )),
                          onChanged: (value) {
                            setState(() {
                              question['answers'][answerIndex] = value;
                            });
                          },
                        ),
                      ),
                      if (question['answers'].length > 1 &&
                          answerIndex == question['answers'].length - 1)
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            size: 24,
                          ),
                          color: Colors.redAccent,
                          onPressed: () {
                            setState(() {
                              question['answers'].removeAt(answerIndex);
                            });
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthNotifier>(context);
    final Color accentColor = Theme.of(context).colorScheme.secondary;
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color surfaceColor = Theme.of(context).colorScheme.surface;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final bool shouldPop = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: surfaceColor,
                title: Text(
                  'Discard test?',
                  style: TextStyle(
                      color: accentColor, fontFamily: 'Init', fontSize: 24),
                ),
                content: Text(
                  'If you go back, all the questions you have written will be lost.',
                  style: TextStyle(
                      color: primaryColor, fontFamily: 'Init', fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      'Keep editing',
                      style: TextStyle(
                          color: accentColor, fontFamily: 'Init', fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Discard',
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontFamily: 'Init',
                            fontSize: 16)),
                  ),
                ],
              ),
            ) ??
            false;

        if (shouldPop && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: Stack(children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: HeaderCurvedContainer(color: accentColor),
              child: Container(height: 180),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new,
                        color: surfaceColor, size: 26),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "Add Questions: ",
                      style: TextStyle(
                        color: surfaceColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  auth.isLoading
                      ? CircularProgressIndicator(color: surfaceColor)
                      : Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: surfaceColor,
                              width: 4,
                            ),
                          ),
                          child: auth.isLoading
                              ? SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                      color: surfaceColor, strokeWidth: 2),
                                )
                              : IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () =>
                                      _submitTest(accentColor, surfaceColor),
                                  icon: Icon(Icons.check,
                                      color: surfaceColor, size: 28),
                                ),
                        ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 140, 20, 0),
            child: AnimatedList(
              key: _listKey,
              initialItemCount: _questions.length,
              itemBuilder: (context, index, animation) {
                final question = _questions[index];
                return SlideTransition(
                  position: animation.drive(
                    Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                        .chain(CurveTween(curve: Curves.easeOutQuart)),
                  ),
                  child: FadeTransition(
                    opacity: animation,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: _buildQuestionCard(index, question, accentColor,
                          primaryColor, surfaceColor),
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.large(
              backgroundColor: accentColor,
              onPressed: () {
                _addQuestion();
              },
              shape: const CircleBorder(),
              child: Icon(
                Icons.add,
                color: surfaceColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
