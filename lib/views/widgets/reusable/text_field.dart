import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme.dart';

class TextFormFieldWidget extends StatefulWidget {
  final TextInputType? textInputType; //numeric or usual
  final List<TextInputFormatter>? inputFormatter; //format for input (lowercase, using regex, etc)
  final String hintText;
  final Widget? prefixIcon;
  final Widget? prefix;
  final BoxConstraints? prefixIconConstraints;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputAction? actionKeyboard; //done, search, next, etc.
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final void Function(String text)? onChanged;
  final int maxLines;

  const TextFormFieldWidget({
    Key? key,
    this.textInputType,
    this.inputFormatter,
    required this.hintText,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.prefixIconConstraints,
    this.focusNode,
    this.obscureText = false,
    this.controller,
    this.actionKeyboard = TextInputAction.done,
    this.validator,
    this.readOnly = false,
    this.onChanged,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  _TextFormFieldWidgetState createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: widget.onChanged,
      readOnly: widget.readOnly,
      keyboardType: widget.textInputType,
      inputFormatters: widget.inputFormatter,
      textInputAction: widget.actionKeyboard,
      obscureText: widget.obscureText,
      focusNode: widget.focusNode,
      style: primaryTextStyle.copyWith(fontSize: 14),
      decoration: InputDecoration(
        isCollapsed: true,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIcon: widget.prefixIcon,
        prefixIconConstraints: widget.prefixIconConstraints,
        prefix: widget.prefix,
        suffixIcon: widget.suffixIcon,
        hintText: widget.hintText,
        hintStyle: secondaryTextStyle.copyWith(fontSize: 14),
        filled: true,
        fillColor: formColor,
        contentPadding: const EdgeInsets.all(16),
      ),
      controller: widget.controller,
      validator: widget.validator,
      maxLines: widget.maxLines,
    );
  }
}
