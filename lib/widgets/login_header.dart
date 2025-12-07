import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  final double logoSize;
  const LoginHeader({super.key, required this.logoSize});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(children: [
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: logoSize,
              height: logoSize,
              child: Image.asset(
                'assets/images/icon.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              "BIENVENIDO",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 32,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Inicia sesión con tu cuenta",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontFamily: 'Inter',
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
