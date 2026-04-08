import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../../../core/config/app-routes/app_routes.dart';
import 'controller/sales_controller.dart';
import 'model/sales_model.dart';


class CreateSaleScreen extends StatelessWidget {
  const CreateSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SaleController>();

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
          text: 'Create Sale',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Sale Type Toggle ───────────────────────────────────
            _SectionLabel(label: 'SALE TYPE'),
            SizedBox(height: 8.h),
            Obx(() => Row(
              children: [
                _SaleTypeTab(
                  label: 'Sold',
                  isSelected:
                  c.selectedSaleType.value == SaleType.sold,
                  onTap: () =>
                  c.selectedSaleType.value = SaleType.sold,
                ),
                _SaleTypeTab(
                  label: 'Consigned',
                  isSelected:
                  c.selectedSaleType.value == SaleType.consigned,
                  onTap: () =>
                  c.selectedSaleType.value = SaleType.consigned,
                ),
              ],
            )),

            SizedBox(height: 20.h),

            // ── Shipment Information ───────────────────────────────
            _SectionHeader(
              iconPath: 'assets/icons/shipmentinformation.svg',
              title: 'Shipment Information',
            ),

            SizedBox(height: 12.h),

            // Physician dropdown
            _DarkDropdownField(
              label: 'Physician',
              hint: 'Dr. Jane Smith',
              value: c.selectedPhysician.value.isEmpty
                  ? null
                  : c.selectedPhysician.value,
              items: c.physicians,
              prefixIcon: Icon(Icons.person_outline,
                  color: AppColors.secondaryTextColor, size: 18.r),
              onChanged: (v) => c.selectedPhysician.value = v ?? '',
            ),

            // Facility dropdown
            _DarkDropdownField(
              label: 'Facility / Location',
              hint: 'Search Facility (e.g., City Hospital)',
              value: c.selectedFacility.value.isEmpty
                  ? null
                  : c.selectedFacility.value,
              items: c.facilities,
              prefixIcon: Icon(Icons.add_box_outlined,
                  color: AppColors.secondaryTextColor, size: 18.r),
              onChanged: (v) => c.selectedFacility.value = v ?? '',
            ),

            // Procedure Date
            Obx(() => GestureDetector(
              onTap: () => c.pickDate(context),
              child: AbsorbPointer(
                child: CustomTextField(
                  controller: TextEditingController(
                      text: c.procedureDate.value),
                  labelText: 'Procedure Date (DOS)',
                  hintText: 'mm/dd/yyyy',
                  readOnly: true,
                  suffixIcon: Icon(Icons.calendar_today_outlined,
                      color: AppColors.secondaryTextColor,
                      size: 18.r),
                ),
              ),
            )),

            SizedBox(height: 4.h),

            // Add Products from Inventory button
            GestureDetector(
              onTap: () => context.pushNamed(AppRoutes.selectImplantsScreen),
              child: Container(
                width: double.infinity,
                height: 50.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: AppColors.primaryColor,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add,
                          color: AppColors.primaryColor, size: 18.r),
                      SizedBox(width: 6.w),
                      Text(
                        'Add Products from Inventory',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // ── Add Representatives ────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Add Representativents',
                  fontsize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                GestureDetector(
                  onTap: () => context.pushNamed(
                      AppRoutes.addRepresentativeScreen),
                  child: Row(
                    children: [
                      Icon(Icons.add_circle_outline,
                          color: AppColors.primaryColor, size: 16.r),
                      SizedBox(width: 4.w),
                      CustomText(
                        text: 'Add',
                        fontsize: 13.sp,
                        color: AppColors.primaryColor,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            Obx(() => Column(
              children: c.addedRepresentatives
                  .asMap()
                  .entries
                  .map((e) => _RepCard(
                rep: e.value,
                index: e.key,
                onRemove: () => c.removeRepresentative(e.key),
              ))
                  .toList(),
            )),

            // Total commission indicator
            Obx(() {
              final total = c.totalCommissionPercent;
              final isValid = total == 100;
              return Container(
                padding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isValid
                      ? AppColors.primaryColor.withValues(alpha: 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      isValid
                          ? Icons.check_circle_outline
                          : Icons.info_outline,
                      color: isValid
                          ? AppColors.primaryColor
                          : AppColors.redColorFF1D1D,
                      size: 14.r,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Total must equal 100% — Currently $total%',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontFamily: 'Poppins',
                        color: isValid
                            ? AppColors.primaryColor
                            : AppColors.redColorFF1D1D,
                      ),
                    ),
                  ],
                ),
              );
            }),

            SizedBox(height: 20.h),

            // ── Billing ────────────────────────────────────────────
            _SectionHeader(
              iconPath: 'assets/icons/billing.svg',
              title: 'Billing',
            ),

            SizedBox(height: 12.h),

            CustomTextField(
              controller: c.vendorController,
              labelText: 'Vendor',
              hintText: 'name',
            ),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: c.poNumberController,
                    labelText: 'PO Number',
                    hintText: 'PO-12345',
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomTextField(
                    controller: c.totalBillController,
                    labelText: 'Total Bill (\$)',
                    hintText: '0.00',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            CustomTextField(
              controller: c.vendorPaymentController,
              labelText: 'Vendor Payment',
              hintText: '\$00.0',
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 4.h),

            // ── Attachments ────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Attachments',
                  fontsize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                Row(
                  children: [
                    Icon(Icons.add_circle_outline,
                        color: AppColors.primaryColor, size: 16.r),
                    SizedBox(width: 4.w),
                    CustomText(
                      text: 'Add',
                      fontsize: 13.sp,
                      color: AppColors.primaryColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 10.h),

            Obx(() => Column(
              children: c.uploadedAttachments
                  .asMap()
                  .entries
                  .map((e) => _AttachmentTile(file: e.value))
                  .toList(),
            )),

            SizedBox(height: 4.h),

            // Additional Notes
            CustomTextField(
              controller: c.additionalNotesController,
              labelText: 'Additional Notes',
              hintText: 'Add any specific case details or instructions...',
              maxLine: 4,
            ),

            Align(
              alignment: Alignment.centerRight,
              child: CustomText(
                text: 'Write at least 80 characters.',
                fontsize: 10.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
            ),

            SizedBox(height: 16.h),

            // ── Packing Slip ───────────────────────────────────────
            _SectionHeader(
              iconPath: 'assets/icons/shipmentinformation.svg',
              title: 'Packing Slip',
            ),

            SizedBox(height: 10.h),

            GestureDetector(
              onTap: () => context.pushNamed(AppRoutes.packingSlipScreen),
              child: Container(
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF242424),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.print_outlined,
                        color: AppColors.primaryColor, size: 20.r),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Generate Packing Slip',
                            fontsize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                          CustomText(
                            text: 'PDF Preview generated',
                            fontsize: 11.sp,
                            color: AppColors.secondaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    Obx(() => GestureDetector(
                      onTap: () => c.generatePackingSlip.toggle(),
                      child: Container(
                        width: 22.r,
                        height: 22.r,
                        decoration: BoxDecoration(
                          color: c.generatePackingSlip.value
                              ? AppColors.primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            color: c.generatePackingSlip.value
                                ? AppColors.primaryColor
                                : const Color(0xFF5A5A5A),
                          ),
                        ),
                        child: c.generatePackingSlip.value
                            ? Icon(Icons.check,
                            color: AppColors.blackColor,
                            size: 14.r)
                            : null,
                      ),
                    )),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // ── Create Sale Record ─────────────────────────────────
            CustomButton(
              title: 'Create Sale Record',
              onpress: () => context.pushNamed(AppRoutes.saleDetailScreen),
              titlecolor: AppColors.blackColor,
              fontWeight: FontWeight.w700,
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}

// ── Internal Widgets ─────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 11.sp,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        color: AppColors.secondaryTextColor,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String iconPath;
  final String title;
  const _SectionHeader({required this.iconPath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 18.r,
          height: 18.r,
          colorFilter: const ColorFilter.mode(
            AppColors.primaryColor,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
          ),
        ),
      ],
    );
  }
}

class _SaleTypeTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SaleTypeTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A6EFF) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
          ),
        ),
      ),
    );
  }
}

class _DarkDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final Widget? prefixIcon;
  final void Function(String?) onChanged;

  const _DarkDropdownField({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            fontsize: 13.sp,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
            bottom: 6.h,
            left: 2.w,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: const Color(0x1A4A4A4A),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                  color: AppColors.dotButtonInactiveColor, width: 0.8),
            ),
            child: Row(
              children: [
                if (prefixIcon != null) ...[
                  prefixIcon!,
                  SizedBox(width: 8.w),
                ],
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: value,
                      hint: Text(
                        hint,
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
                      items: items
                          .map((i) => DropdownMenuItem(
                        value: i,
                        child: Text(
                          i,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Poppins',
                            color: AppColors.primaryTextColor,
                          ),
                        ),
                      ))
                          .toList(),
                      onChanged: onChanged,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RepCard extends StatelessWidget {
  final RepresentativeModel rep;
  final int index;
  final VoidCallback onRemove;

  const _RepCard({
    required this.rep,
    required this.index,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [const Color(0xFF3A7BD5), const Color(0xFF6C5CE7)];
    final bg = colors[index % colors.length];

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: bg,
                child: Text(
                  rep.name.substring(0, 2).toUpperCase(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: rep.name,
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        rep.role,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontFamily: 'Poppins',
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    text: 'Commission',
                    fontsize: 10.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: const Color(0xFF3A3A3A)),
                    ),
                    child: Text(
                      '${rep.commissionPercent} %',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: onRemove,
            child: Text(
              'REMOVE REPRESENTATIVE',
              style: TextStyle(
                fontSize: 10.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppColors.redColorFF1D1D,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  final AttachmentFileModel file;
  const _AttachmentTile({required this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Row(
        children: [
          Container(
            width: 34.r,
            height: 34.r,
            decoration: BoxDecoration(
              color: file.isPdf
                  ? AppColors.redColorFF1D1D.withValues(alpha: 0.15)
                  : AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(
              file.isPdf
                  ? Icons.picture_as_pdf_outlined
                  : Icons.insert_drive_file_outlined,
              color: file.isPdf
                  ? AppColors.redColorFF1D1D
                  : AppColors.primaryColor,
              size: 18.r,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: file.fileName,
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                if (file.date.isNotEmpty)
                  CustomText(
                    text: '${file.size} • ${file.date}',
                    fontsize: 10.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  )
                else
                  CustomText(
                    text: file.size,
                    fontsize: 10.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
              ],
            ),
          ),
          Icon(Icons.download_outlined,
              color: AppColors.secondaryTextColor, size: 18.r),
        ],
      ),
    );
  }
}