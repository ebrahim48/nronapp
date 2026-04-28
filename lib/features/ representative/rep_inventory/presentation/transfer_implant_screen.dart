import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/active_implant_banner.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../controller/transfer_implant_controller.dart';
import '../model/implant_model.dart';


class TransferImplantScreen extends StatefulWidget {
  final ImplantModel implant;
  const TransferImplantScreen({super.key, required this.implant});

  @override
  State<TransferImplantScreen> createState() => _TransferImplantScreenState();
}

class _TransferImplantScreenState extends State<TransferImplantScreen> {
  final _ctrl = TransferImplantController();

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
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        centerTitle: false,
        title: CustomText(
          text: 'Transfer Implant',
          fontsize: 17.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: ListenableBuilder(
        listenable: _ctrl,
        builder: (context, _) {
          return Form(
            key: _ctrl.formKey,
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding:
                  EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 120.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Implant banner
                      ActiveImplantBanner(
                        serialNumber: widget.implant.serialNumber,
                        implantName: widget.implant.name,
                        imageAsset: widget.implant.imageAsset,
                      ),
                      SizedBox(height: 22.h),

                      // Transfer Information header
                      CustomText(
                        text: 'Transfer Information',
                        fontsize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                        bottom: 16.h,
                      ),

                      // From
                      CustomTextField(
                        controller: _ctrl.fromController,
                        labelText: 'From',
                        hintText: 'Warehouse A - Shelf 4',
                      ),

                      // To
                      CustomTextField(
                        controller: _ctrl.toController,
                        labelText: 'To',
                        hintText: 'Warehouse A - Shelf 4',
                      ),

                      // Reason for Transfer
                      CustomTextField(
                        controller: _ctrl.reasonController,
                        labelText: 'Reason for Transfer',
                        hintText: '',
                        maxLine: 5,
                      ),
                    ],
                  ),
                ),

                
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: AppColors.backgroundColor,
                        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
                        child: CustomButton(
                          title: 'Request Transfer',
                          prefixIcon: Icon(Icons.swap_horiz,
                              color: AppColors.primaryTextColor, size: 18.r),
                          loading: _ctrl.isLoading,
                          onpress: () async {
                            final ok = await _ctrl.requestTransfer();
                            if (ok && context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      'Transfer request submitted!'),
                                  backgroundColor: AppColors.primaryColor,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: CustomText(
                          text:
                          'Transfers require immediate approval from the recipient.',
                          fontsize: 11.sp,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}