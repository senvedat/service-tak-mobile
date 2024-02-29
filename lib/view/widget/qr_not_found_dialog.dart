import 'package:flutter/material.dart';
import 'package:service_tak_mobile/utils/constants.dart';

class QrNotFoundDialog extends StatelessWidget {
  final VoidCallback onPressed;

  const QrNotFoundDialog({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("QR Not Found"),
      content: const Text("QR Not Found in the system"),
      actions: [
        TextButton(
          onPressed: onPressed,
          child: const Text(
            "OK",
            style: TextStyle(color: kMediumGreen),
          ),
        ),
      ],
    );
  }
}