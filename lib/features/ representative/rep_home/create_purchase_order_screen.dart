import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/%20representative/rep_home/presentation/widgets/po_form_fields.dart';
import 'package:nron_app/features/%20representative/rep_home/presentation/widgets/po_scan_item_card.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import 'controller/create_purchase_controller.dart';


class CreatePurchaseScreen extends StatelessWidget {
  const CreatePurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(CreatePurchaseController());

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
                  Obx(() => PoScannedItemCard(
                    imagePath: 'assets/images/order.jpg',
                    itemName: c.itemName.value,
                    serialNo: c.itemSN.value,
                    price: c.itemPrice.value,
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

                  // Surgeon Name
                  const PoFieldLabel(label: 'Surgeon Name'),
                  PoDropdownTextField(
                    controller: c.surgeonNameController,
                    hintText: 'Search Surgeon (e.g., Dr. Lee)',
                    iconPath: 'assets/icons/surgeon.svg',
                    options: const [
                      'Dr. John Lee',
                      'Dr. Sarah Kim',
                      'Dr. Michael Chen',
                      'Dr. Emily Johnson',
                    ],
                  ),

                  // Facility
                  const PoFieldLabel(label: 'Facility(Hospital/Clinic)'),
                  PoDropdownTextField(
                    controller: c.facilityController,
                    hintText: 'Search Facility (e.g., City Hospital)',
                    iconPath: 'assets/icons/inventory.svg',
                    options: const [
                      'City Hospital',
                      'St. Mary Medical Center',
                      'General Health Clinic',
                      'Metro Surgical Center',
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Facility Email
                  const PoFieldLabel(label: 'Facility Email'),
                  PoIconTextField(
                    controller: c.facilityEmailController,
                    hintText: 'Search Facility (e.g., City Hospital)',
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
                  const PoFieldLabel(label: 'Name'),
                  PoIconTextField(
                    controller: c.vendorNameController,
                    hintText: 'Vendor Name',
                    iconPath: 'assets/icons/user.svg',
                  ),

                  SizedBox(height: 4.h),

                  // Vendor Email
                  const PoFieldLabel(label: 'Vendor Email'),
                  PoDropdownTextField(
                    controller: c.vendorEmailController,
                    hintText: 'example@email.com',
                    iconPath: 'assets/icons/mail.svg',
                    options: const [
                      'vendor@medtech.com',
                      'supply@biotech.com',
                      'orders@medequip.com',
                      'sales@implants.com',
                    ],
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
                    onTap: c.isPickingFile.value ? () {} : () => c.showAttachOptions(context),
                    isLoading: c.isPickingFile.value,
                  )),

                  SizedBox(height: 24.h),

                  CustomButton(
                    title: 'Submit Purchase Order',
                    onpress: c.submitOrder,
                    titlecolor: const Color(0xFF1E2121),
                    suffixIcon: SvgPicture.asset(
                      'assets/icons/next.svg',
                      width: 18.r,
                      height: 18.r,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF1E2121),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}