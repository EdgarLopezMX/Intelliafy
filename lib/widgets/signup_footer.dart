import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intelliafy_app/screens/signup_screen.dart';

class SignUpFooter extends StatelessWidget {
  const SignUpFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Center(
              child: RichText(
                text: TextSpan(children: [
                  const TextSpan(
                    text: '¿Aún no estás registrado?',
                    style: TextStyle(
                      color: Color.fromRGBO(2, 64, 89, 1),
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const TextSpan(text: '  '),
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp())),
                      text: 'Registrate!',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ))
                ]),
              ),
            ))
      ],
    );
  }
}
