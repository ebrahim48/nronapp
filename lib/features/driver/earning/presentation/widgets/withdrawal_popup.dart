import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/custom_widgets/custom_button.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../controller/earnings_controller.dart';

class WithdrawalPopup extends StatefulWidget {
  final double totalBalance;

  const WithdrawalPopup({super.key, required this.totalBalance});

  @override
  State<WithdrawalPopup> createState() => _WithdrawalPopupState();
}

class _WithdrawalPopupState extends State<WithdrawalPopup> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _accountNameCtrl = TextEditingController();
  final _cardNumberCtrl = TextEditingController();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _accountNameCtrl.dispose();
    _cardNumberCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context, EarningsController c) async {
    if (!_formKey.currentState!.validate()) return;
    final success = await c.sendWithdrawalRequest(
      amount: int.parse(_amountCtrl.text.trim()),
      accountName: _accountNameCtrl.text.trim(),
      cardNumber: int.parse(_cardNumberCtrl.text.trim()),
    );
    if (success && context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<EarningsController>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.all(20.r),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title ───────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Request Payout',
                    fontsize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.close,
                        color: AppColors.secondaryTextColor, size: 20.r),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // ── Form + Balance side by side ──────────────────
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left: fields
                    Expanded(
                      child: Column(
                        children: [
                          _Field(
                            label: 'Amount',
                            hint: 'Enter amount',
                            controller: _amountCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Required';
                              final n = int.tryParse(v);
                              if (n == null || n <= 0) return 'Invalid amount';
                              return null;
                            },
                          ),
                          SizedBox(height: 10.h),
                          _Field(
                            label: 'Account Name',
                            hint: 'Enter account name',
                            controller: _accountNameCtrl,
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Required' : null,
                          ),
                          SizedBox(height: 10.h),
                          _Field(
                            label: 'Card Number',
                            hint: 'Enter card number',
                            controller: _cardNumberCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(16),
                            ],
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Required';
                              if (v.length < 12) return 'Too short';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // Right: Total Balance card
                    Container(
                      width: 110.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF252525),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.all(12.r),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_balance_wallet_outlined,
                              color: AppColors.primaryColor, size: 24.r),
                          SizedBox(height: 8.h),
                          CustomText(
                            text: 'Total Balance',
                            fontsize: 10.sp,
                            color: AppColors.secondaryTextColor,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 6.h),
                          CustomText(
                            text: '\$${widget.totalBalance.toInt()}',
                            fontsize: 22.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryColor,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // ── Submit button ────────────────────────────────
              Obx(() => CustomButton(
                    title: 'Send Request',
                    width: double.infinity,
                    loading: c.isRequestingPayout.value,
                    onpress: () => _submit(context, c),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;

  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontsize: 11.sp,
          color: AppColors.secondaryTextColor,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 4.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType ?? TextInputType.text,
          inputFormatters: inputFormatters,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(
            color: AppColors.primaryTextColor,
            fontSize: 13.sp,
            fontFamily: 'Poppins',
          ),
          cursorColor: AppColors.primaryColor,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.secondaryTextColor,
              fontSize: 12.sp,
              fontFamily: 'Poppins',
            ),
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: const Color(0xFF3A3A3A), width: 0.8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: const Color(0xFF3A3A3A), width: 0.8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Colors.red, width: 0.8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Colors.red, width: 0.8),
            ),
            errorStyle:
                TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
