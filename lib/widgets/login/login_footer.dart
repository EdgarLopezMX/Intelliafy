import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intelliafy_app/screens/profile_screen.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color accentColor = Theme.of(context).colorScheme.secondary;
    const double horizontalPadding = 48.0;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: "Don't have an account?",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Inter',
                  ),
                ),
                const TextSpan(text: '  '),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileScreen())),
                    text: 'Sign Up!',
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ))
              ]),
            )),
      ),
    );
  }
}
