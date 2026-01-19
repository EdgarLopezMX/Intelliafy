import 'package:flutter/material.dart';

Widget infoSection({required String content}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const SizedBox(width: 10),
      Center(
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontFamily: 'Inter',
              fontStyle: FontStyle.italic),
        ),
      ),
    ],
  );
}
