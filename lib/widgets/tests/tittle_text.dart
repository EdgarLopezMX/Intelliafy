import 'package:flutter/material.dart';

Widget textTitles({required String label, required Color color}) {
  return Text(
    label,
    style: TextStyle(
      color: color,
      fontSize: 16,
      fontWeight: FontWeight.normal,
      fontFamily: 'Inter',
    ),
  );
}
