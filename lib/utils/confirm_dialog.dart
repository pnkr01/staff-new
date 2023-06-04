import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    Key? key,
    required this.onpressedYes,
    required this.onpressedNo,
    required this.title,
  }) : super(key: key);
  final Function onpressedYes;
  final Function onpressedNo;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      content: Text(title),
      actions: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
                onPressed: onpressedYes(), child: const Text('Yes'))),
        const SizedBox(
          height: 8,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
                onPressed: onpressedNo(), child: const Text('No'))),
      ],
    );
  }
}
