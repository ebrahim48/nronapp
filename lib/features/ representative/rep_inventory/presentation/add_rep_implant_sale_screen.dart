import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../../sales/controller/add_representative_controller.dart';
import '../controller/create_implant_sale _controller.dart';

class AddRepImplantSaleScreen extends StatefulWidget {
  const AddRepImplantSaleScreen({super.key});

  @override
  State<AddRepImplantSaleScreen> createState() =>
      _AddRepImplantSaleScreenState();
}

class _AddRepImplantSaleScreenState extends State<AddRepImplantSaleScreen> {
  late final AddRepresentativeController repC;
  late final CreateImplantSaleController saleC;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AddRepresentativeController>()) {
      Get.delete<AddRepresentativeController>();
    }
    repC = Get.put(AddRepresentativeController());
    saleC = Get.find<CreateImplantSaleController>();
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
          child: Icon(Icons.arrow_back_ios,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        title: CustomText(
          text: 'Add Representative',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Representative dropdown ────────────────────────────────
            CustomText(
              text: 'Representative',
              fontsize: 13.sp,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
              bottom: 6.h,
              left: 2.w,
            ),
            Obx(() {
              final ids = saleC.repDropdownList.map((r) => r.id).toList();
              final names = saleC.repDropdownList.map((r) => r.name).toList();
              if (ids.isEmpty) {
                return Shimmer.fromColors(
                  baseColor: const Color(0xFF2A2A2A),
                  highlightColor: const Color(0xFF3A3A3A),
                  child: Container(
                    height: 52.h,
                    margin: EdgeInsets.only(bottom: 14.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                );
              }
              final safeVal = ids.contains(repC.selectedRepId.value)
                  ? repC.selectedRepId.value
                  : null;
              return Container(
                margin: EdgeInsets.only(bottom: 14.h),
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: const Color(0x1A4A4A4A),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                      color: AppColors.dotButtonInactiveColor, width: 0.8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person_outline,
                        color: AppColors.secondaryTextColor, size: 18.r),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: safeVal,
                          hint: Text(
                            'Select Representative',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Poppins',
                              color: AppColors.secondaryTextColor,
                            ),
                          ),
                          isExpanded: true,
                          dropdownColor: const Color(0xFF2A2A2A),
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: AppColors.secondaryTextColor, size: 20.r),
                          items: List.generate(
                            ids.length,
                            (i) => DropdownMenuItem(
                              value: ids[i],
                              child: Text(
                                names[i],
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: 'Poppins',
                                  color: AppColors.primaryTextColor,
                                ),
                              ),
                            ),
                          ),
                          onChanged: (id) {
                            if (id != null) {
                              repC.selectedRepId.value = id;
                              final idx = ids.indexOf(id);
                              repC.selectedRepName.value =
                                  idx >= 0 ? names[idx] : '';
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            // ── Role dropdown ─────────────────────────────────────────
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Rep Role',
                      fontsize: 13.sp,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                      bottom: 6.h,
                      left: 2.w,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 14.h),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      decoration: BoxDecoration(
                        color: const Color(0x1A4A4A4A),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                            color: AppColors.dotButtonInactiveColor, width: 0.8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: repC.selectedRole.value,
                          isExpanded: true,
                          dropdownColor: const Color(0xFF2A2A2A),
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: AppColors.secondaryTextColor, size: 20.r),
                          items: repC.roles
                              .map((r) => DropdownMenuItem(
                                    value: r,
                                    child: Text(
                                      r,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: 'Poppins',
                                        color: AppColors.primaryTextColor,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (v) =>
                              repC.selectedRole.value = v ?? 'Assist',
                        ),
                      ),
                    ),
                  ],
                )),

            // ── Commission % ──────────────────────────────────────────
            CustomTextField(
              controller: repC.commissionController,
              labelText: 'Commission %',
              hintText: '0',
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 50.h),

            CustomButton(
              title: 'Add Representative',
              onpress: () {
                if (repC.selectedRepId.value.isEmpty) return;
                saleC.addRepresentative(repC.build());
                Navigator.pop(context);
              },
              titlecolor: AppColors.blackColor,
              fontWeight: FontWeight.w700,
            ),

            SizedBox(height: 14.h),

            Text(
              'A team is needed when multiple representatives are involved in different parts of the same sales process.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'Poppins',
                color: AppColors.secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
