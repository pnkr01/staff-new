import 'package:flutter/material.dart';
import '../constants/app_color.dart';

class StaffFormField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final Color borderColor;
  final Color cursorColor;
  final Color hintColor;
  final Color? labelColor;
  final Color? contentColor;
  final bool isObscureText;
  final bool? enabled;
  final TextInputType? type;
  final FocusNode? focusNode;
  final TextEditingController controller;
  const StaffFormField({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.borderColor,
    required this.cursorColor,
    required this.hintColor,
    this.labelColor,
    this.contentColor,
    required this.isObscureText,
    this.enabled = true,
    this.type = TextInputType.text,
    this.focusNode,
    required this.controller,
  }) : super(key: key);

  @override
  State<StaffFormField> createState() => _StaffFormFieldState();
}

class _StaffFormFieldState extends State<StaffFormField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.enabled,
      keyboardType: widget.type,
      focusNode: widget.focusNode,
      // scrollPhysics: const NeverScrollableScrollPhysics(),

      style: kTitleTextStyle(15, FontWeight.w600).copyWith(color: purpleColor),
      obscureText: widget.isObscureText,
      controller: widget.controller,
      cursorColor: widget.cursorColor,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: kBodyText3Style(),
        labelText: widget.labelText,
        labelStyle: kElevatedButtonTextStyle()
            .copyWith(color: purpleColor, fontSize: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
          borderSide: BorderSide(
            color: widget.borderColor,
          ),
        ),
      ),
    );
  }
}
