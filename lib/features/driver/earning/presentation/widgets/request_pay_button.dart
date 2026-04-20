import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_button.dart';


class RequestPayoutButton extends StatelessWidget {
  final double amount;
  final bool loading;
  final VoidCallback onTap;

  const RequestPayoutButton({
    super.key,
    required this.amount,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 24.h),
      child: CustomButton(
        title: 'Request Payout (\$${amount.toInt()})',
        prefixIcon: loading
            ? null
            : Icon(Icons.wallet_outlined,
            color: AppColors.primaryTextColor, size: 18.r),
        loading: loading,
        onpress: onTap,
      ),
    );
  }
}