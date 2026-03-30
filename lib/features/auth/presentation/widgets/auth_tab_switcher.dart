import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthTabSwitcher extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onLoginTap;
  final VoidCallback onSignUpTap;

  const AuthTabSwitcher({
    super.key,
    required this.isLogin,
    required this.onLoginTap,
    required this.onSignUpTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 36.h,
      padding: EdgeInsets.all(2.r),
      decoration: BoxDecoration(
        color: const Color(0xFF656565),
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(color: const Color(0xFFD4D4D4), width: 0.8),
      ),
      child: Row(children: [
        GestureDetector(onTap: onLoginTap, child: AuthTab(label: 'Log In', isActive: isLogin)),
        GestureDetector(onTap: onSignUpTap, child: AuthTab(label: 'Sign Up', isActive: !isLogin)),
      ]),
    );
  }
}

class AuthTab extends StatelessWidget {
  final String label;
  final bool isActive;

  const AuthTab({super.key, required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168.w,
      height: 32.h,
      decoration: isActive
          ? BoxDecoration(
              color: const Color(0xFF1E2121),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: const Color(0xFFD4D4D4), width: 0.5),
              boxShadow: const [
                BoxShadow(color: Color(0x08000000), blurRadius: 2, offset: Offset(0, -2)),
                BoxShadow(color: Color(0x3DE4E5E7), blurRadius: 2, offset: Offset(0, 1)),
              ],
            )
          : null,
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13.sp,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? Colors.white : const Color(0xFFD4D4D4),
          ),
        ),
      ),
    );
  }
}
