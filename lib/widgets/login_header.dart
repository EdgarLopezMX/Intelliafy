import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  final double logoSize;
  final String firstText;
  final String secondText;

  const LoginHeader(
      {super.key,
      required this.logoSize,
      required this.firstText,
      required this.secondText});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final double finalLogoDimension = logoSize.clamp(60.0, 120.0);
    const double horizontalPadding = 48.0;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: finalLogoDimension,
              height: finalLogoDimension,
              child: Image.asset(
                'assets/images/icon.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              firstText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryColor,
                fontSize: 36,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              secondText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryColor,
                fontSize: 18,
                fontFamily: 'Inter',
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
