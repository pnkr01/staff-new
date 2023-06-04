import 'package:flutter/material.dart';
import 'package:staff/constants/app_color.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  final Color? color;
  final bool? isCopied;
  const ErrorDialog({
    Key? key,
    required this.message,
    this.color,
    this.isCopied,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(
        message,
        style: kBodyText3Style().copyWith(color: blackColor),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? purpleColor,
          ),
          child: Center(
              child: Text(
            "OK",
            style: kBodyText3Style().copyWith(color: whiteColor),
          )),
        ),
      ],
    );
  }
}
