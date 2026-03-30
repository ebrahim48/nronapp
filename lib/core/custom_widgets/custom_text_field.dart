import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_colors.dart';
import 'custom_text.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? isObscureText;
  final String? obscure;
  final Color? filColor;
  final Color? borderColor;
  final Color? hintextColor;
  final Widget? prefixIcon;
  final String? labelText;
  final String? hintText;
  final double? contentPaddingHorizontal;
  final double? contentPaddingVertical;
  final int? maxLine;
  final double? hintextSize;
  final Widget? suffixIcon;
  final FormFieldValidator? validator;
  final bool isPassword;
  final bool? isEmail;
  final bool? readOnly;
  final double? borderRadio;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final TextInputAction? textInputAction;

  const CustomTextField({
    super.key,
    this.contentPaddingHorizontal,
    this.contentPaddingVertical,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLine,
    this.validator,
    this.hintextColor,
    this.borderColor,
    this.isEmail = false,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isObscureText = false,
    this.obscure = '*',
    this.filColor,
    this.hintextSize,
    this.labelText,
    this.isPassword = false,
    this.readOnly = false,
    this.borderRadio,
    this.onTap,
    this.onChanged,
    this.maxLength,
    this.inputFormatters,
    this.errorText,
    this.textInputAction,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.labelText != null)
            CustomText(
              text: widget.labelText ?? '',
              bottom: 6.h,
              left: 2.w,
              color: AppColors.primaryTextColor,
            ),
          Container(
            width: 345.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadio?.r ?? 8.r),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: AppColors.primaryColor,
                  selectionColor: AppColors.primaryColor.withValues(alpha: 0.4),
                  selectionHandleColor: AppColors.primaryColor,
                ),
              ),
              child: TextFormField(
                onChanged: widget.onChanged,
                onTap: widget.onTap,
                readOnly: widget.readOnly!,
                controller: widget.controller,
                keyboardType: widget.keyboardType,
                obscuringCharacter: widget.obscure!,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLines: widget.maxLine ?? 1,
                maxLength: widget.maxLength,
                inputFormatters: widget.inputFormatters,
                textInputAction: widget.textInputAction ??
                    ((widget.maxLine ?? 1) == 1
                        ? TextInputAction.done
                        : TextInputAction.newline),
                validator: (value) {
                  if (widget.validator != null) {
                    return widget.validator!(value);
                  }
                  if (widget.isEmail == false) {
                    if (value!.isEmpty) {
                      return "Please ${widget.hintText?.toLowerCase()}";
                    } else if (widget.isPassword) {
                      if (value.isEmpty) {
                        return "Please ${widget.hintText?.toLowerCase()}";
                      } else if (value.length < 8 ||
                          !AppConstants.validatePassword(value)) {
                        return "Password: 8 characters min, letters & digits \nrequired";
                      }
                    }
                  } else {
                    bool data = AppConstants.emailValidate.hasMatch(value!);
                    if (value.isEmpty) {
                      return "Please ${widget.hintText!.toLowerCase()}";
                    } else if (!data) {
                      return "Please check your email!";
                    }
                  }
                  return null;
                },
                cursorColor: AppColors.primaryColor,
                cursorRadius: Radius.circular(2.r),
                obscureText: widget.isPassword ? obscureText : false,
                style: TextStyle(
                  color: widget.hintextColor ?? AppColors.primaryTextColor,
                  fontSize: widget.hintextSize ?? 14.sp,
                  fontFamily: 'Poppins',
                ),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: widget.filColor ?? const Color(0x1A4A4A4A),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: widget.contentPaddingHorizontal ?? 14.w,
                    vertical: widget.contentPaddingVertical ?? 13.h,
                  ),
                  prefixIcon: widget.prefixIcon != null
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: widget.prefixIcon,
                        )
                      : null,
                  suffixIcon: widget.isPassword
                      ? GestureDetector(
                          onTap: toggle,
                          child: _suffixIcon(obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                        )
                      : widget.suffixIcon,
                  prefixIconConstraints:
                      BoxConstraints(minHeight: 28.w, minWidth: 28.w),
                  hintText: widget.hintText,
                  errorText: widget.errorText,
                  hintStyle: TextStyle(
                    color: widget.hintextColor ?? AppColors.secondaryTextColor,
                    fontSize: widget.hintextSize ?? 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  focusedBorder: _focusedBorder(),
                  enabledBorder: _enabledBorder(),
                  errorBorder: _errorBorder(),
                  focusedErrorBorder: _errorBorder(),
                  border: _focusedBorder(),
                  errorStyle:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _suffixIcon(IconData icon) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Icon(icon, color: AppColors.secondaryTextColor),
    );
  }

  OutlineInputBorder _focusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadio?.r ?? 8.r),
      borderSide: BorderSide(
        color: widget.borderColor ?? AppColors.dotButtonInactiveColor,
        width: 0.8,
      ),
    );
  }

  OutlineInputBorder _enabledBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadio?.r ?? 8.r),
      borderSide: BorderSide(
        color: widget.borderColor ?? AppColors.dotButtonInactiveColor,
        width: 0.8,
      ),
    );
  }

  OutlineInputBorder _errorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadio?.r ?? 8.r),
      borderSide: const BorderSide(color: Colors.red, width: 0.8),
    );
  }
}
