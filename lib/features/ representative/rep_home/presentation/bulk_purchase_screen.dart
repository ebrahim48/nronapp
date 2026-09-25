import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/features/%20representative/rep_home/presentation/widgets/bulk_po_widgets.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../../core/config/app-routes/app_routes.dart';
import '../controller/bulk_purchase_controller.dart';
import 'widgets/po_form_fields.dart';

class BulkPurchaseScreen extends StatefulWidget {
  const BulkPurchaseScreen({super.key});

  @override
  State<BulkPurchaseScreen> createState() => _BulkPurchaseScreenState();
}

class _BulkPurchaseScreenState extends State<BulkPurchaseScreen> {
  late final BulkPurchaseController c;

  @override
  void initState() {
    super.initState();
    c = Get.put(BulkPurchaseController());
  }

  @override
  void dispose() {
    Get.delete<BulkPurchaseController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar
              Container(
                color: const Color(0xFF1E2427),
                height: 52.h,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.primaryTextColor,
                          size: 18.r,
                        ),
                      ),
                    ),
                    CustomText(
                      text: 'Create Purchase Order',
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),

              // Body content
              Padding(
                padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  top: 16.h,
                  bottom: 24.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => BulkPoStepHeader(
                          currentStep: c.currentStep.value,
                          totalSteps: c.totalSteps.value,
                        )),

                    SizedBox(height: 20.h),

                    const PoSectionTitle(title: 'Logistics & Procedure'),

                    // Status
                    const PoFieldLabel(label: 'Status'),
                    Obx(() => PoStatusDropdown(
                          value: c.selectedStatus.value,
                          options: c.statusOptions,
                          onChanged: (val) {
                            if (val != null) c.selectedStatus.value = val;
                          },
                        )),

                    // Patient ID
                    const PoFieldLabel(label: 'Patient ID'),
                    PoIconTextField(
                      controller: c.patientIdController,
                      hintText: '01002120JSC2254S',
                    ),

                    SizedBox(height: 4.h),

                    // Surgeon Name
                    const PoFieldLabel(label: 'Surgeon Name'),
                    Obx(() => PoDropdownTextField(
                          controller: c.surgeonNameController,
                          hintText: 'Search Surgeon (e.g., Dr. Lee)',
                          iconPath: 'assets/icons/surgeon.svg',
                          options: c.surgeryList.map((s) => s.name).toList(),
                          onSelected: c.onSurgerySelected,
                        )),

                    SizedBox(height: 4.h),

                    // Facility
                    const PoFieldLabel(label: 'Facility(Hospital/Clinic)'),
                    Obx(() => PoDropdownTextField(
                          controller: c.facilityController,
                          hintText: 'Search Facility (e.g., City Hospital)',
                          iconPath: 'assets/icons/plus.svg',
                          options: c.facilityList.map((f) => f.name).toList(),
                          onSelected: c.onFacilitySelected,
                        )),

                    SizedBox(height: 4.h),

                    // Facility Email
                    const PoFieldLabel(label: 'Facility Email'),
                    PoIconTextField(
                      controller: c.facilityEmailController,
                      hintText: 'facility@example.com',
                      iconPath: 'assets/icons/mail.svg',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    SizedBox(height: 4.h),

                    // Procedure Date + PO Number
                    PoProcedurePoRow(
                      dateController: c.procedureDateController,
                      poController: c.poNumberController,
                    ),

                    SizedBox(height: 8.h),

                    // Send Vendor Email toggle
                    Obx(() => PoVendorEmailToggle(
                          value: c.sendVendorEmail.value,
                          onChanged: c.toggleVendorEmail,
                        )),

                    SizedBox(height: 12.h),

                    // Vendor Name
                    const PoFieldLabel(label: 'Vendor Name'),
                    Obx(() => PoDropdownTextField(
                          controller: c.vendorNameController,
                          hintText: 'Select Vendor',
                          iconPath: 'assets/icons/user.svg',
                          options: c.vendorList.map((v) => v.name).toList(),
                          onSelected: c.onVendorSelected,
                        )),

                    SizedBox(height: 4.h),

                    // Vendor Email (manual)
                    const PoFieldLabel(label: 'Vendor Email'),
                    PoIconTextField(
                      controller: c.vendorEmailController,
                      hintText: 'vendor@example.com',
                      iconPath: 'assets/icons/mail.svg',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    SizedBox(height: 4.h),

                    // Additional Notes
                    const PoFieldLabel(label: 'Additional Notes'),
                    PoIconTextField(
                      controller: c.additionalNotesController,
                      hintText:
                          'Add any specific case details or instructions...',
                      maxLines: 5,
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        text: 'Write at least 80 characters.',
                        fontsize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.end,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    BulkBioOrderCard(
                      onScanItem: () => context.pushNamed(
                        AppRoutes.receivingSessionScreen,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Obx(() => Column(
                          children: c.bulkProducts
                              .asMap()
                              .entries
                              .map((e) => BulkProductRowWidget(
                                    item: e.value,
                                    onRemove: () => c.removeProduct(e.key),
                                  ))
                              .toList(),
                        )),

                    SizedBox(height: 16.h),

                    const PoSectionTitle(title: 'Attached Documents'),

                    Obx(() => Column(
                          children: c.attachedDocs
                              .asMap()
                              .entries
                              .map((e) => PoDocumentItem(
                                    file: e.value,
                                    onDelete: () => c.deleteDoc(e.key),
                                  ))
                              .toList(),
                        )),

                    BulkAttachDocumentBox(
                      onUploadPDF: c.uploadPDF,
                      onTakePhoto: () => c.takePhoto(context),
                    ),

                    SizedBox(height: 24.h),

                    // Save Order — outlined style
                    Obx(() => GestureDetector(
                          onTap: c.isSubmitting.value
                              ? null
                              : () => c.saveOrder(context),
                          child: Container(
                            width: 345.w,
                            height: 48.h,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: AppColors.primaryColor,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/document.svg',
                                  width: 18.r,
                                  height: 18.r,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.primaryTextColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                CustomText(
                                  text: 'Save Order',
                                  fontsize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryTextColor,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )),

                    SizedBox(height: 10.h),

                    Obx(() => CustomButton(
                          title: 'Save and send to vendor',
                          loading: c.isSubmitting.value,
                          onpress: c.isSubmitting.value
                              ? () {}
                              : () => c.continueOrder(context),
                          titlecolor: const Color(0xFF1E2121),
                          suffixIcon: c.isSubmitting.value
                              ? null
                              : Icon(Icons.send,
                                  color: const Color(0xFF1E2121), size: 16.r),
                        )),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
