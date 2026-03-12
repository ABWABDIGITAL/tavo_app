// lib/core/widgets/primary/auth_text_form_field.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/theme_extensions.dart';

class AuthTextFormField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final double borderRadius;
  final TextDirection? textDirection;
  final TextAlign? textAlign;

  const AuthTextFormField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.fillColor,
    this.inputFormatters,
    this.focusNode,
    this.textInputAction,
    this.borderRadius = 0,
    this.textDirection,
    this.textAlign,
  });

  @override
  State<AuthTextFormField> createState() => _AuthTextFormFieldState();
}

class _AuthTextFormFieldState extends State<AuthTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      textDirection: widget.textDirection,
      textAlign: widget.textAlign ?? TextAlign.start,
      style: TextStyles.font14Black400Weight(context),
      cursorColor: context.isDark ? ColorsManager.white : ColorsManager.black,
      decoration: _buildInputDecoration(),
    );
  }

  InputDecoration _buildInputDecoration() {
    final isDark = context.isDark;

    final borderColor = isDark
        ? ColorsManager.darkDivider
        : ColorsManager.lightGrey;

    final hintColor = isDark
        ? ColorsManager.darkTextSecondary
        : ColorsManager.fontLightGrey;

    final fill = widget.fillColor ?? (isDark
        ? ColorsManager.darkSurface
        : ColorsManager.transparent);

    return InputDecoration(
      labelStyle: TextStyles.font12DarkGray400Weight(context),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      isDense: true,
      labelText: widget.label,
      hintText: widget.hint,
      filled: widget.fillColor != null || isDark,
      fillColor: fill,
      hintStyle: TextStyle(
        fontSize: 14.sp,
        color: hintColor,
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: widget.prefixIcon,
      suffixIcon: widget.suffixIcon,
      errorMaxLines: 3,
      errorStyle: TextStyle(
        fontSize: 12.sp,
        color: ColorsManager.errorColor,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius.r),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius.r),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius.r),
        borderSide: BorderSide(
          color: isDark ? ColorsManager.white : ColorsManager.black,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius.r),
        borderSide: BorderSide(color: borderColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius.r),
        borderSide: BorderSide(color: ColorsManager.errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius.r),
        borderSide: BorderSide(color: ColorsManager.errorColor),
      ),
    );
  }
}