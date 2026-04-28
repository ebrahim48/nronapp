import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nron_app/features/driver/driver_payment/presentation/widgets/payment_card_tile.dart';
import 'package:nron_app/features/driver/driver_payment/presentation/widgets/payment_info_note.dart';
import 'package:nron_app/features/driver/driver_payment/presentation/widgets/secured_payment_card.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/payment_mthod_controller.dart';
import 'add_card_screen.dart';


class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() =>
      _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final _ctrl = PaymentMethodsController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 60.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Payment Methods',
              fontsize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
            CustomText(
              text: 'Job Request',
              fontsize: 11.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: _ctrl,
        builder: (context, _) {
          return SingleChildScrollView(
            padding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SecurePaymentsBanner(),
                SizedBox(height: 22.h),

                CustomText(
                  text: 'Saved Methods',
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                  bottom: 12.h,
                ),

                ..._ctrl.cards.map(
                      (card) => PaymentCardTile(
                    card: card,
                    onSetDefault: () => _ctrl.setDefault(card.id),
                    onEdit: () {},
                    onDelete: () => _ctrl.deleteCard(card.id),
                  ),
                ),

                SizedBox(height: 8.h),

                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddCardScreen(
                        onCardAdded: (card) => _ctrl.addCard(card),
                      ),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 52.h,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add,
                            color: AppColors.primaryTextColor,
                            size: 18.r),
                        SizedBox(width: 8.w),
                        CustomText(
                          text: 'Add New Payment Method',
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTextColor,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                const PaymentInfoNote(),
              ],
            ),
          );
        },
      ),
    );
  }
}