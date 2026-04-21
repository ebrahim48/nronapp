import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nron_app/features/driver/driver_payment/presentation/widgets/card_added_success_dialog.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/add_card_controller.dart';
import '../model/payment_model.dart';


class AddCardScreen extends StatefulWidget {
  final void Function(PaymentCardModel card)? onCardAdded;

  const AddCardScreen({super.key, this.onCardAdded});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _ctrl = AddCardController();

  @override
  void initState() {
    super.initState();
    _ctrl.cardNumberController.text = '65415205635421';
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _cardField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? formatters,
    Widget? suffix,
    String? Function(String?)? validator,
    double? width,
  }) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: label,
              fontsize: 12.sp,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
              left: 2.w,
              bottom: 6.h,
            ),
            Container(
              height: 52.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                    color: AppColors.dotButtonInactiveColor,
                    width: 0.8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      keyboardType: keyboardType,
                      inputFormatters: formatters,
                      validator: validator,
                      style: TextStyle(
                        color: AppColors.secondaryTextColor,
                        fontSize: 13.sp,
                        fontFamily: 'Poppins',
                      ),
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(
                          color: AppColors.secondaryTextColor
                              .withValues(alpha: 0.5),
                          fontSize: 13.sp,
                          fontFamily: 'Poppins',
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 14.h),
                      ),
                    ),
                  ),
                  if (suffix != null) suffix,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _countryDropdown() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Country',
            fontsize: 12.sp,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
            left: 2.w,
            bottom: 6.h,
          ),
          Container(
            height: 52.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                  color: AppColors.dotButtonInactiveColor, width: 0.8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _ctrl.selectedCountry,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down,
                    color: AppColors.primaryTextColor, size: 20.r),
                dropdownColor: const Color(0xFF252525),
                style: TextStyle(
                  color: AppColors.primaryTextColor,
                  fontSize: 13.sp,
                  fontFamily: 'Poppins',
                ),
                onChanged: _ctrl.setCountry,
                hint: const SizedBox.shrink(),
                items: _ctrl.countries
                    .map((c) =>
                    DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 56.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        title: CustomText(
          text: 'Add Card',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: ListenableBuilder(
        listenable: _ctrl,
        builder: (context, _) {
          return Stack(
            children: [
              Form(
                key: _ctrl.formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                      16.w, 28.h, 16.w, 100.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _cardField(
                        controller: _ctrl.cardNumberController,
                        label: 'Card Number',
                        hint: 'XXXX XXXX XXXX XXXX',
                        keyboardType: TextInputType.number,
                        formatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                        ],
                        suffix: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_ctrl.isVisa || _ctrl.isMaster ||
                                _ctrl.cardNumberController.text.isEmpty)
                              _CardLogo(isVisa: true),
                            SizedBox(width: 4.w),
                            _CardLogo(isVisa: false),
                          ],
                        ),
                        validator: (v) => (v?.length ?? 0) < 12
                            ? 'Enter valid card number'
                            : null,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: _cardField(
                              controller: _ctrl.expireDateController,
                              label: 'Expire Date',
                              hint: 'DD-MM-YY',
                              keyboardType: TextInputType.datetime,
                              validator: (v) => (v?.isEmpty ?? true)
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _cardField(
                              controller: _ctrl.cvcController,
                              label: 'CVC',
                              hint: 'CVC',
                              keyboardType: TextInputType.number,
                              formatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],
                              validator: (v) =>
                              (v?.length ?? 0) < 3
                                  ? 'Invalid CVC'
                                  : null,
                            ),
                          ),
                        ],
                      ),

                      _countryDropdown(),
                    ],
                  ),
                ),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: AppColors.backgroundColor,
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 12.h),
                  child: CustomButton(
                    title: 'Go To My Card',
                    loading: _ctrl.isLoading,
                    onpress: () async {
                      await _ctrl.submit();
                    },
                  ),
                ),
              ),

              if (_ctrl.showSuccess)
                Container(
                  color: Colors.black.withValues(alpha: 0.6),
                  child: Center(
                    child: CardAddedSuccessDialog(
                      onGoToWallet: () {
                        _ctrl.dismissSuccess();
                        final card = PaymentCardModel(
                          id: DateTime.now()
                              .millisecondsSinceEpoch
                              .toString(),
                          cardType: 'Visa Card',
                          holderName: 'Alex Rodriguez',
                          lastFour: _ctrl.cardNumberController.text
                              .substring(_ctrl
                              .cardNumberController
                              .text
                              .length -
                              4),
                          isDefault: false,
                          cardColor: const Color(0xFF3B5BDB),
                        );
                        widget.onCardAdded?.call(card);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _CardLogo extends StatelessWidget {
  final bool isVisa;
  const _CardLogo({required this.isVisa});

  @override
  Widget build(BuildContext context) {
    if (isVisa) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: CustomText(
          text: 'VISA',
          fontsize: 8.sp,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF1A1F71),
        ),
      );
    }
    return Container(
      width: 24.r,
      height: 16.r,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: 16.r,
              height: 16.r,
              decoration: const BoxDecoration(
                color: Color(0xFFEB001B),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              width: 16.r,
              height: 16.r,
              decoration: BoxDecoration(
                color: const Color(0xFFF79E1B),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}