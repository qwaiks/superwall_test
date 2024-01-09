import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {super.key,
      this.controller,
      this.labelText,
      this.title,
      this.hintText,
      this.enabled = true,
      this.isPasswordField = false,
      this.removeBorder = false,
      this.validator,
      this.onEditingComplete,
      this.formatters,
      this.inputType,
      this.validationMode,
      this.onChanged,
      this.autoFocus = false,
      this.focusNode,
      this.minLines = 1,
      this.maxLines = 1,
      this.onTap});

  final TextEditingController? controller;
  final String? labelText;
  final String? title;
  final String? hintText;
  final bool enabled;
  final bool isPasswordField;
  final bool removeBorder;
  final String? Function(String?)? validator;
  final void Function()? onEditingComplete;
  final List<TextInputFormatter>? formatters;
  final TextInputType? inputType;
  final AutovalidateMode? validationMode;
  final void Function(String)? onChanged;
  final bool autoFocus;
  final FocusNode? focusNode;
  final int minLines;
  final int maxLines;
  final void Function()? onTap;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    const borderSide = BorderSide(color: Color(0xFFD5D8DE), width: 1);
    final border = widget.removeBorder
        ? InputBorder.none
        : OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), borderSide: borderSide);

    final textField = TextFormField(
      key: widget.key,
      focusNode: widget.focusNode,
      controller: widget.controller,
      onChanged: widget.onChanged,
      autofocus: widget.autoFocus,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      onTap: widget.onTap,
      readOnly: widget.onTap != null,
      decoration: InputDecoration(
        border: border,
        labelText: widget.labelText,
        hintText: widget.hintText,
        isDense: true,
        enabled: widget.enabled,
        suffixIcon: widget.isPasswordField
            ? _buildPasswordFieldVisibilityToggle()
            : null,
      ),
      autovalidateMode: widget.validationMode,
      validator: widget.validator,

      inputFormatters: widget.formatters,
      //autocorrect: true,
      obscureText: widget.isPasswordField ? _obscureText : false,
      textInputAction: TextInputAction.next,
      keyboardType: widget.inputType,
      keyboardAppearance: Brightness.light,
      onEditingComplete: widget.onEditingComplete,
    );

    return Visibility(
      replacement: textField,
      visible: widget.title != null && widget.title!.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title ?? '',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          textField,
        ],
      ),
    );
  }

  Widget _buildPasswordFieldVisibilityToggle() {
    return InkWell(
      child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
      onTap: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }
}
