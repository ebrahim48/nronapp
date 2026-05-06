import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/active_implant_banner.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../controller/add_implant_controller.dart' show FacilityOption;
import '../controller/transfer_implant_controller.dart';
import '../model/implant_model.dart';


class TransferImplantScreen extends StatefulWidget {
  final ImplantModel implant;
  const TransferImplantScreen({super.key, required this.implant});

  @override
  State<TransferImplantScreen> createState() => _TransferImplantScreenState();
}

class _TransferImplantScreenState extends State<TransferImplantScreen> {
  late final TransferImplantController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(TransferImplantController());
    _ctrl.implantId = widget.implant.id;
    _ctrl.fromController.text = widget.implant.facility;
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
      body: Obx(() {
        return Form(
          key: _ctrl.formKey,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 120.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ActiveImplantBanner(
                      serialNumber: widget.implant.serialNumber,
                      implantName: widget.implant.name,
                      imageAsset: widget.implant.imageAsset,
                    ),
                    SizedBox(height: 22.h),

                    CustomText(
                      text: 'Transfer Information',
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                      bottom: 16.h,
                    ),

                    // From (read-only)
                    CustomTextField(
                      controller: _ctrl.fromController,
                      labelText: 'From',
                      hintText: 'Current facility',
                    ),

                    // To — facility dropdown
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'To',
                            fontsize: 12.sp,
                            color: AppColors.primaryTextColor,
                            textAlign: TextAlign.start,
                            left: 2.w,
                            bottom: 6.h,
                          ),
                          Container(
                            height: 50.h,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: const Color(0x1A4A4A4A),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                  color: AppColors.dotButtonInactiveColor,
                                  width: 0.8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.location_on_outlined,
                                    color: AppColors.secondaryTextColor,
                                    size: 16.r),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: _ctrl.isLoadingFacilities.value
                                      ? CustomText(
                                          text: 'Loading facilities...',
                                          fontsize: 13.sp,
                                          color: AppColors.secondaryTextColor,
                                          textAlign: TextAlign.start,
                                        )
                                      : DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: _ctrl.selectedToFacilityId.value,
                                            hint: CustomText(
                                              text: 'Select destination facility',
                                              fontsize: 13.sp,
                                              color: AppColors.secondaryTextColor,
                                            ),
                                            isExpanded: true,
                                            dropdownColor: const Color(0xFF252525),
                                            iconEnabledColor: AppColors.secondaryTextColor,
                                            style: TextStyle(
                                              color: AppColors.primaryTextColor,
                                              fontSize: 13.sp,
                                              fontFamily: 'Poppins',
                                            ),
                                            onChanged: (val) {
                                              if (val == null) return;
                                              final f = _ctrl.facilities.firstWhere((f) => f.id == val);
                                              _ctrl.selectToFacility(f.id, f.name);
                                            },
                                            items: _ctrl.facilities
                                                .map((f) => DropdownMenuItem(
                                                    value: f.id,
                                                    child: Text(f.name)))
                                                .toList(),
                                          ),
                                        ),
                                ),
                                Icon(Icons.keyboard_arrow_down,
                                    color: AppColors.secondaryTextColor,
                                    size: 18.r),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                        loading: _ctrl.isLoading.value,
                        prefixIcon: Icon(Icons.swap_horiz,
                            color: AppColors.primaryTextColor, size: 18.r),
                        onpress: () async {
                          final ok = await _ctrl.requestTransfer();
                          if (ok && context.mounted) {
                            Navigator.pop(context);
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
      }),
    );
  }
}
