import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/%20representative/rep_home/presentation/widgets/bulk_po_widgets.dart';
import 'package:nron_app/features/%20representative/rep_home/presentation/widgets/po_form_fields.dart';
import '../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import 'controller/create_purchase_controller.dart';


class CreatePurchaseScreen extends StatefulWidget {
  const CreatePurchaseScreen({super.key});

  @override
  State<CreatePurchaseScreen> createState() => _CreatePurchaseScreenState();
}

class _CreatePurchaseScreenState extends State<CreatePurchaseScreen> {
  late final CreatePurchaseController c;

  @override
  void initState() {
    super.initState();
    c = Get.put(CreatePurchaseController());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF1E2427),
            elevation: 0,
            toolbarHeight: 52.h,
            pinned: false,
            floating: false,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.primaryTextColor,
                size: 18.r,
              ),
            ),
            title: CustomText(
              text: 'Create Purchase Order',
              fontsize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
            centerTitle: false,
            titleSpacing: 0,
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
              top: 18.h,
              bottom: 24.h,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Obx(() => BulkPoStepHeader(
                      currentStep: c.currentStep.value,
                      totalSteps: c.totalSteps.value,
                    )),

                SizedBox(height: 24.h),

                const PoSectionTitle(title: 'Logistics & Procedure'),

                // Status dropdown
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

                // Surgeon Name — dynamic from API
                const PoFieldLabel(label: 'Surgeon Name'),
                Obx(() => PoDropdownTextField(
                      controller: c.surgeonNameController,
                      hintText: 'Search Surgeon (e.g., Dr. Lee)',
                      iconPath: 'assets/icons/surgeon.svg',
                      options: c.surgeryList.map((s) => s.name).toList(),
                      onSelected: c.onSurgerySelected,
                    )),

                // Facility — dynamic from API
                const PoFieldLabel(label: 'Facility(Hospital/Clinic)'),
                Obx(() => PoDropdownTextField(
                      controller: c.facilityController,
                      hintText: 'Search Facility (e.g., City Hospital)',
                      iconPath: 'assets/icons/inventory.svg',
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

                // Vendor — dynamic from API
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
                  hintText: 'Add any specific case details or instructions...',
                  maxLines: 5,
                ),

                // 'Write at least 80 characters' hint
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

                SizedBox(height: 20.h),

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

                // Attach document upload box
                Obx(() => PoAttachDocumentBox(
                      onTap: c.isPickingFile.value
                          ? () {}
                          : () => c.showAttachOptions(context),
                      isLoading: c.isPickingFile.value,
                    )),

                SizedBox(height: 24.h),

                Obx(() => CustomButton(
                      title: 'Save and send to vendor',
                      loading: c.isSubmitting.value,
                      onpress: c.isSubmitting.value
                          ? () {}
                          : () => c.submitOrder(context),
                      titlecolor: const Color(0xFF1E2121),
                      suffixIcon: c.isSubmitting.value
                          ? null
                          : Icon(Icons.send,
                              color: const Color(0xFF1E2121), size: 16.r),
                    )),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
