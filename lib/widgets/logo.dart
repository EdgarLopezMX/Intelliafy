import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double logoSize;

  const Logo({super.key, required this.logoSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SizedBox(
            width: logoSize,
            height: logoSize,
            child: Image.asset(
              'assets/images/icon.png',
              fit: BoxFit.contain,
            ),
          ),
        )
      ],
    );
  }
}
