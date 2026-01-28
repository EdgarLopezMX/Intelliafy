import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intelliafy_app/providers/auth_notifier.dart';
import 'package:intelliafy_app/widgets/profile/header_curved.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TestScreen extends StatelessWidget {
  final Map<String, dynamic> testData;

  const TestScreen({super.key, required this.testData});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthNotifier>(context);
    final accentColor = Theme.of(context).colorScheme.secondary;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    final String titulo = testData['testTitle'] ?? 'Whitout Title';
    final String curso = testData['courseName'] ?? 'General';
    final String author = testData['author'] ?? 'Whitout Author';
    final Timestamp createdAt = testData['createdAt'] ?? '...';
    final String date = formatFirebaseDate(createdAt);

    final List<dynamic> questions = testData['questions'] ?? [];

    return Scaffold(
      backgroundColor: surfaceColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: HeaderCurvedContainer(color: accentColor),
              child: Container(height: 180),
            ),
          ),
          Column(
            children: [
              SafeArea(
                child:
                    _buildAppBar(context, surfaceColor, titulo, author, date),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                  children: [
                    //_buildTestHeader(testData, surfaceColor, accentColor),
                    const SizedBox(height: 20),
                    // Lista de preguntas
                    ...questions.asMap().entries.map((entry) {
                      return _buildQuestionCard(
                        index: entry.key,
                        questionMap: entry.value,
                        auth: auth,
                        accentColor: accentColor,
                        primaryColor: primaryColor,
                        surfaceColor: surfaceColor,
                      );
                    }),
                    const SizedBox(height: 30),
                    auth.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 0,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: MaterialButton(
                              onPressed: () async {
                                if (auth.selectedAnswers.length <
                                    questions.length) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Por favor, responde todas las preguntas")),
                                  );
                                  return;
                                }
                                bool ok = await auth.submitTestResult(
                                  testId: testData['testId'] ?? 'no-id',
                                  originalQuestions: questions,
                                  studentAnswers: auth.selectedAnswers,
                                );

                                if (ok && context.mounted) {
                                  _showResultDialog(
                                      context,
                                      auth.lastScore,
                                      questions.length,
                                      accentColor,
                                      surfaceColor);
                                } else if (!ok && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Error: ${auth.errorMessage}")),
                                  );
                                }
                              },
                              child: Text(
                                "ENVIAR RESPUESTAS",
                                style: TextStyle(
                                    color: surfaceColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showResultDialog(BuildContext context, int score, int total,
      Color accentColor, Color surfaceColor) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text(
          'Test Completed!',
          textAlign: TextAlign.center,
          style:
              TextStyle(color: accentColor, fontFamily: 'Init', fontSize: 26),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.stars, color: Colors.orange, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Your score is:',
              style: TextStyle(
                  color: Colors.black, fontSize: 18, fontFamily: 'Init'),
            ),
            Text(
              '$score / $total',
              style: TextStyle(
                color: accentColor,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'Init',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              score >= (total / 2) ? 'Excellent work!' : 'Keep practicing!',
              style: TextStyle(
                  color: Colors.grey[600], fontSize: 16, fontFamily: 'Init'),
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                'CONTINUE',
                style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatFirebaseDate(Timestamp createdAt) {
    DateTime date = createdAt.toDate();
    return DateFormat('yMMMd').format(date);
  }

  Widget _buildAppBar(BuildContext context, Color color, String titulo,
      String author, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: color, size: 30),
            onPressed: () => Navigator.maybePop(context),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    titulo,
                    style: TextStyle(
                      color: color,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Init',
                    ),
                  ),
                ),
                Text(
                  "By: $author",
                  style: TextStyle(
                    color: color.withValues(alpha: 0.9),
                    fontSize: 16,
                    fontFamily: 'Init',
                  ),
                ),
                Text(
                  "Created at: $date",
                  style: TextStyle(
                    color: color.withValues(alpha: 0.8),
                    fontSize: 13,
                    fontFamily: 'Init',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard({
    required int index,
    required Map<String, dynamic> questionMap,
    required AuthNotifier auth,
    required Color accentColor,
    required Color primaryColor,
    required Color surfaceColor,
  }) {
    final options = List<String>.from(questionMap['answers'] ?? []);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: accentColor.withValues(alpha: 0.5), width: 1),
        boxShadow: [
          BoxShadow(
              color: accentColor, blurRadius: 0, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Question ${index + 1}:",
              style: TextStyle(color: accentColor, fontFamily: 'Init')),
          const SizedBox(height: 8),
          Text(questionMap['question'],
              style: TextStyle(
                  fontSize: 18, color: primaryColor, fontFamily: 'Init')),
          const Divider(),
          ...options.map((option) => RadioListTile(
                title: Text(option,
                    style: TextStyle(
                        fontSize: 18, color: primaryColor, fontFamily: 'Init')),
                value: option,
                groupValue: auth.selectedAnswers[index],
                activeColor: accentColor,
                onChanged: (val) => auth.setAnswer(index, val!),
              )),
        ],
      ),
    );
  }
}
