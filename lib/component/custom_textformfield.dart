import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  TextEditingController? controller;
  Key? key;
  int? maxLines;
  String? Function(String?)? validator;
  double borderRadius;
  bool enabledBorder;
  String hintText;
  bool readOnly;
  Function()? onTap;
  Function(String)? onChanged;
  bool filled;
  Color filledColor;
  Widget? suffixIcon;
  Widget? prefixIcon;
  TextInputType? keyboardType;
  EdgeInsetsGeometry? contentPadding;
  bool obscureText;
  Function(String)? onFieldSubmitted;
  Color? borderColor;
  int? maxLength;
  List<TextInputFormatter>? inputFormatters;
  TextAlign textAlign;
  FocusNode? focusNode;
  int? minLines;
  String title;

  CustomTextFormField({
    this.textAlign = TextAlign.start,
    this.controller,
    this.key,
    this.maxLines = 1,
    this.validator,
    required this.borderRadius,
    this.enabledBorder = true,
    required this.hintText,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.filled = false,
    this.filledColor = const Color(0xFFF4F4F4),
    this.suffixIcon,
    this.prefixIcon,
    this.contentPadding,
    this.obscureText = false,
    this.keyboardType,
    this.onFieldSubmitted,
    this.borderColor,
    this.maxLength,
    this.inputFormatters,
    this.focusNode,
    this.minLines,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        TextFormField(
          focusNode: focusNode,
          textAlign: textAlign,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          minLines: minLines,
          onFieldSubmitted: onFieldSubmitted,
          key: key,
          keyboardType: keyboardType,
          readOnly: readOnly,
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          autovalidateMode: AutovalidateMode.disabled,
          onTap: onTap,
          onChanged: onChanged,
          decoration: InputDecoration(
            counterText: '',
            fillColor: filled ? filledColor : null,
            filled: filled,
            hintText: hintText,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w300,
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: enabledBorder
                    ? BorderSide(color: borderColor ?? const Color(0xFF838383))
                    : BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: enabledBorder
                    ? BorderSide(color: borderColor ?? Color(0xFF838383))
                    : BorderSide.none),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: enabledBorder
                    ? const BorderSide(color: Colors.red, width: 1.0)
                    : BorderSide.none),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: enabledBorder
                    ? const BorderSide(color: Colors.red, width: 1.0)
                    : BorderSide.none),
            contentPadding: contentPadding,
          ),
          onTapOutside: (PointerDownEvent event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
        )
      ],
    );
  }
}
