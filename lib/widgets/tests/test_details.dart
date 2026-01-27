import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intelliafy_app/providers/auth_notifier.dart';
import 'package:intelliafy_app/screens/test.dart';
import 'package:provider/provider.dart';

class TestDetails extends StatelessWidget {
  final Map<String, dynamic> testData;

  final Color accentColor;
  final Color surfaceColor;

  const TestDetails(
      {super.key,
      required this.testData,
      required this.accentColor,
      required this.surfaceColor});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthNotifier>(context, listen: false);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final String testId = testData['authorId'] ?? '';
    final String uploadedBy = testData['authorId'] ?? '';
    final String title = testData['testTitle'] ?? 'Sin título';
    final String course = testData['courseName'] ?? 'Sin curso';
    final String deadlineDate = testData['deadlineDate'] ?? '';
    final Timestamp? deadlineStamp = testData['deadlineDateTimeStamp'];
    bool isDeadlineAvailable = false;
    if (deadlineStamp != null) {
      isDeadlineAvailable = deadlineStamp.toDate().isAfter(DateTime.now());
    }

    return FutureBuilder<bool>(
        future: auth.checkIfAlreadySubmitted(testData['testId']),
        builder: (context, snapshot) {
          bool alreadyDone = snapshot.data ?? false;
          bool isLoading = snapshot.connectionState == ConnectionState.waiting;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                  color: accentColor.withValues(alpha: 0.3), width: 1),
              boxShadow: [
                BoxShadow(
                  color: accentColor,
                  spreadRadius: 2,
                  blurRadius: 1,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: ListTile(
              onTap: isDeadlineAvailable
                  ? () async {
                      bool alreadyDone = await auth
                          .checkIfAlreadySubmitted(testData['testId']);

                      if (alreadyDone) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("You have already completed this test."),
                            ),
                          );
                        }
                        return;
                      }
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TestScreen(testData: testData)),
                        );
                      }
                    }
                  : () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("The test has expired")),
                      ),
              onLongPress: () {
                if (uploadedBy == uid) {
                  _showDeleteDialog(context, testId);
                }
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: Text(title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course,
                      style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 5),
                  Text(
                    isDeadlineAvailable ? 'Ends: $deadlineDate' : 'Finished',
                    style: TextStyle(
                      color: isDeadlineAvailable ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              trailing: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(
                      alreadyDone
                          ? Icons.check_circle
                          : Icons.keyboard_arrow_right,
                      color: alreadyDone ? Colors.green : accentColor,
                      size: 30),
            ),
          );
        });
  }

  void _showDeleteDialog(BuildContext context, String testId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete test?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('tests')
                  .doc(testId)
                  .delete();
              Navigator.pop(context);
              Fluttertoast.showToast(msg: 'Test removed.');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
