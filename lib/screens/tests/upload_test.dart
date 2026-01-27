import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intelliafy_app/providers/auth_notifier.dart';
import 'package:intelliafy_app/screens/tests/upload_questions.dart';
import 'package:intelliafy_app/widgets/navigator_bar.dart';
import 'package:intelliafy_app/widgets/profile/header_curved.dart';
import 'package:intelliafy_app/widgets/tests/tittle_text.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UploadTest extends StatefulWidget {
  const UploadTest({super.key});

  @override
  State<UploadTest> createState() => _UploadTestMSScreen();
}

class _UploadTestMSScreen extends State<UploadTest> {
  DateTime? picked;
  Timestamp? deadlineDateTimeStamp;

  final TextEditingController _testTitleController =
      TextEditingController(text: '');
  final TextEditingController _courseController =
      TextEditingController(text: '');
  final TextEditingController _deadlineDateController =
      TextEditingController(text: 'Select a Dateline');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthNotifier>(context, listen: false).fetchCourses();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _testTitleController.dispose();
    _courseController.dispose();
    _deadlineDateController.dispose();
  }

  Widget _textFromFields({
    required String valueKey,
    required TextEditingController controller,
    required bool isReadOnly,
    required Function fct,
    required Color accent,
    required Color primary,
    IconData? suffixIcon,
  }) {
    return InkWell(
      onTap: () {
        fct();
      },
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Required field';
              }
              return null;
            },
            controller: controller,
            enabled: isReadOnly,
            key: ValueKey(valueKey),
            style: TextStyle(
              color: primary,
            ),
            maxLines: valueKey == 'Descripción del Test' ? 3 : 1,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              suffixIcon: suffixIcon != null
                  ? Icon(suffixIcon, color: accent, size: 20)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  void _pickDateTest(Color accent, primary, surface) async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: accent,
                onPrimary: surface,
                error: Colors.redAccent,
                onError: Colors.redAccent,
                surface: surface,
                onSurface: primary,
              ),
            ),
            child: child!);
      },
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _deadlineDateController.text =
            DateFormat.yMMMd('en_US').format(picked!);

        deadlineDateTimeStamp = Timestamp.fromDate(picked!);
      });
    }
  }

  // ignore: non_constant_identifier_names
  bool UploadData() {
    if (_deadlineDateController.text == 'Select a Dateline' ||
        _courseController.text.isEmpty ||
        _testTitleController.text.isEmpty) {
      return false;
    }
    return true;
  }

  _courseDropdownField(
    TextEditingController controller,
    Color primaryColor,
    Color surfaceColor,
    Color accentColor,
  ) {
    return Consumer<AuthNotifier>(
      builder: (context, auth, child) {
        String? currentValue =
            auth.courseNames.contains(controller.text) ? controller.text : null;
        return DropdownButtonFormField<String>(
          icon: Icon(
            Icons.expand_more_rounded,
            color: accentColor,
          ),
          elevation: 1,
          menuMaxHeight: 300,
          style: TextStyle(color: primaryColor, fontSize: 16),
          isDense: true,
          initialValue: currentValue,
          isExpanded: true,
          hint: Text(
            "Select a Course: ",
            style: TextStyle(
                color: primaryColor, fontSize: 16, fontFamily: 'Init'),
          ),
          items: auth.courseNames.map((String name) {
            return DropdownMenuItem<String>(
              value: name,
              child: Text(name,
                  style: TextStyle(
                      color: primaryColor, fontSize: 16, fontFamily: 'Init')),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                controller.text = newValue;
              });
            }
          },
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Required field' : null,
          decoration: const InputDecoration(
            filled: true,
            border: OutlineInputBorder(borderSide: BorderSide.none),
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          ),
          dropdownColor: surfaceColor,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthNotifier>(context);
    final Color accentColor = Theme.of(context).colorScheme.secondary;
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color surfaceColor = Theme.of(context).colorScheme.surface;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBarForApp(indexNum: 2),
      backgroundColor: surfaceColor,
      body: Stack(alignment: Alignment.center, children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: CustomPaint(
            painter: HeaderCurvedContainer(color: accentColor),
            child: Container(height: 350),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 350,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 40),
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textTitles(
                            label: 'Test Title: ',
                            color: primaryColor,
                          ),
                          _textFromFields(
                            valueKey: 'TestTitle',
                            controller: _testTitleController,
                            isReadOnly: true,
                            fct: () {},
                            accent: accentColor,
                            primary: primaryColor,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          _courseDropdownField(_courseController, primaryColor,
                              surfaceColor, accentColor),
                          const SizedBox(
                            height: 10,
                          ),
                          _textFromFields(
                            valueKey: 'Deadline',
                            controller: _deadlineDateController,
                            isReadOnly: false,
                            fct: () {
                              _pickDateTest(
                                  accentColor, primaryColor, surfaceColor);
                            },
                            accent: accentColor,
                            primary: primaryColor,
                            suffixIcon: Icons.calendar_month_outlined,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: MaterialButton(
                              onPressed: auth.isLoading
                                  ? null
                                  : () async {
                                      if (UploadData()) {
                                        String? testId = await auth.uploadTest(
                                          title: _testTitleController.text,
                                          course: _courseController.text,
                                          deadline: deadlineDateTimeStamp,
                                        );

                                        if (!mounted) return;

                                        if (testId != null) {
                                          auth.setTestData(
                                            id: testId,
                                            title: _testTitleController.text,
                                            course: _courseController.text,
                                            dateText:
                                                _deadlineDateController.text,
                                            deadline: deadlineDateTimeStamp,
                                          );

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text('Test header saved!')),
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const UploadQuestions(),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Error creating test')),
                                          );
                                        }
                                      }
                                    },
                              color: accentColor,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                child: auth.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2),
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Add questions',
                                            style: TextStyle(
                                                color: surfaceColor,
                                                fontSize: 18,
                                                fontFamily: 'Init'),
                                          ),
                                          const SizedBox(width: 10),
                                          Icon(Icons.arrow_forward_ios,
                                              color: surfaceColor, size: 18),
                                        ],
                                      ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
