import 'package:flutter/material.dart';

Widget profileInfo(
    {required String content,
    required IconData icon,
    required Color accent,
    required Color primary}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const SizedBox(width: 10),
      Row(
        children: [
          Icon(
            icon,
            color: accent,
            size: 24,
          ),
          const SizedBox(
            width: 5,
          ),
          Text("Member since:  ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: primary,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
              )),
          Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: accent,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ],
  );
}
