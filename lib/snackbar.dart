import 'package:flutter/material.dart';

void showCustomSnackBar({
  required BuildContext context,
  required String message,
  IconData? icon,
  Duration duration = const Duration(seconds: 3),
}) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        if (icon != null) ...[
          Icon(icon),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Text(
            message,
          ),
        ),
      ],
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
