import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intelliafy_app/screens/profile_screen.dart';
import 'package:intelliafy_app/screens/tests/upload_test.dart';
import 'package:intelliafy_app/screens/tests_screen.dart';

// ignore: must_be_immutable
class BottomNavigationBarForApp extends StatelessWidget {
  int indexNum = 0;

  BottomNavigationBarForApp({super.key, required this.indexNum});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color accentColor = Theme.of(context).colorScheme.secondary;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return CurvedNavigationBar(
      color: accentColor,
      backgroundColor: surfaceColor,
      buttonBackgroundColor: accentColor,
      height: 75,
      index: indexNum,
      items: [
        Icon(
          Icons.checklist_rtl,
          size: 40,
          color: surfaceColor,
        ),
        Icon(Icons.person, size: 40, color: surfaceColor),
        Icon(Icons.add, size: 40, color: surfaceColor),
      ],
      animationDuration: const Duration(
        microseconds: 1,
      ),
      animationCurve: Curves.bounceInOut,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const TestsScreen()));
        } else if (index == 1) {
          final FirebaseAuth auth = FirebaseAuth.instance;
          final User? user = auth.currentUser;
          final uid = user!.uid;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()));
        } else if (index == 2) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const UploadTest()));
        }
      },
    );
  }
}
