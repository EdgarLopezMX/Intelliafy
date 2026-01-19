import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intelliafy_app/screens/login_screen.dart';
import 'package:intelliafy_app/widgets/logo.dart';

class SignupFooter extends StatelessWidget {
  const SignupFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color accentColor = Theme.of(context).colorScheme.secondary;
    const double horizontalPadding = 48.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final logoSize = screenWidth * 0.20;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Already have an account?',
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
                                builder: (context) => const LoginScreen())),
                      text: 'Log in!',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Logo(logoSize: logoSize),
            ],
          ),
        ),
      ),
    );
  }
}
