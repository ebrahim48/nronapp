import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/active_implant_banner.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../../sales/model/sales_model.dart';
import '../controller/create_implant_sale _controller.dart';
import '../model/implant_model.dart';
import 'add_rep_implant_sale_screen.dart';
import 'select_products_implant_sale_screen.dart';

class CreateImplantSaleScreen extends StatefulWidget {
  final ImplantModel implant;
  const CreateImplantSaleScreen({super.key, required this.implant});

  @override
  State<CreateImplantSaleScreen> createState() =>
      _CreateImplantSaleScreenState();
}

class _CreateImplantSaleScreenState extends State<CreateImplantSaleScreen> {
  late final CreateImplantSaleController c;

  @override
  void initState() {
    super.initState();
    c = Get.put(CreateImplantSaleController(implant: widget.implant));
  }

  @override
  void dispose() {
    Get.delete<CreateImplantSaleController>(force: true);
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
          text: 'Create Implant Sales',
          fontsize: 17.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ActiveImplantBanner(
                  serialNumber: widget.implant.serialNumber,
                  implantName: widget.implant.name,
                  imageAsset: widget.implant.imageAsset,
                ),
                SizedBox(height: 14.h),

                // ── Sale Type ──────────────────────────────────────────────
                CustomText(
                  text: 'SALE TYPE',
                  fontsize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                  bottom: 8.h,
                ),
                Obx(() => Row(
                      children: ['sold', 'consigned'].map((t) {
                        final label = t[0].toUpperCase() + t.substring(1);
                        final sel = c.saleType.value == t;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => c.saleType.value = t,
                            child: Container(
                              height: 38.h,
                              margin: EdgeInsets.only(
                                  right: t == 'sold' ? 8.w : 0),
                              decoration: BoxDecoration(
                                color: sel
                                    ? AppColors.primaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: sel
                                      ? AppColors.primaryColor
                                      : AppColors.dotButtonInactiveColor,
                                  width: 0.8,
                                ),
                              ),
                              child: Center(
                                child: CustomText(
                                  text: label,
                                  fontsize: 13.sp,
                                  fontWeight: sel
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: sel
                                      ? Colors.white
                                      : AppColors.secondaryTextColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )),
                SizedBox(height: 14.h),

                // ── Shipment Information ───────────────────────────────────
                _Section(
                  header: _SectionHeader(
                      icon: Icons.local_shipping_outlined,
                      title: 'Shipment Information'),
                  children: [
                    _FieldLabel(text: 'Physician'),
                    Obx(() => _DropdownField(
                          value: c.selectedPhysicianName.value.isEmpty
                              ? null
                              : c.selectedPhysicianName.value,
                          options: c.physicianNames,
                          hint: 'Select Physician',
                          icon: Icons.person_outline,
                          onChanged: c.selectPhysician,
                        )),
                    SizedBox(height: 12.h),
                    _FieldLabel(text: 'Facility / Location'),
                    Obx(() => _DropdownField(
                          value: c.selectedFacilityName.value.isEmpty
                              ? null
                              : c.selectedFacilityName.value,
                          options: c.facilityNames,
                          hint: 'Select Facility',
                          icon: Icons.location_on_outlined,
                          onChanged: c.selectFacility,
                        )),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      controller: c.procedureDateController,
                      labelText: 'Procedure Date (DOS)',
                      hintText: 'mm/dd/yyyy',
                      readOnly: true,
                      onTap: () => c.pickDate(context),
                      suffixIcon: Icon(Icons.calendar_today,
                          size: 14.r,
                          color: AppColors.secondaryTextColor),
                    ),
                    SizedBox(height: 4.h),

                    // ── Add Products from Inventory ────────────────────
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const SelectProductsImplantSaleScreen(),
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        child: Center(
                          child: Obx(() => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add,
                                      color: AppColors.primaryColor,
                                      size: 18.r),
                                  SizedBox(width: 6.w),
                                  Text(
                                    c.selectedInventoryImplants.isEmpty
                                        ? 'Add Products from Inventory'
                                        : 'Products Added (${c.selectedInventoryImplants.length})',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                  ],
                ),

                // ── Add Representatives ────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Add Representatives',
                      fontsize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddRepImplantSaleScreen(),
                        ),
                      ),
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

                Obx(() {
                  final total = c.totalCommissionPercent;
                  final isValid = total == 100;
                  if (c.addedRepresentatives.isEmpty) return const SizedBox.shrink();
                  return Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 8.h),
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
                SizedBox(height: 14.h),

                // ── Billing ────────────────────────────────────────────────
                _Section(
                  header: _SectionHeader(
                      icon: Icons.receipt_outlined, title: 'Billing'),
                  children: [
                    _FieldLabel(text: 'Vendor'),
                    Obx(() => _DropdownField(
                          value: c.selectedVendorName.value.isEmpty
                              ? null
                              : c.selectedVendorName.value,
                          options: c.vendorNames,
                          hint: 'Select Vendor',
                          icon: Icons.business_outlined,
                          onChanged: c.selectVendor,
                        )),
                    SizedBox(height: 12.h),
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
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                          ),
                        ),
                      ],
                    ),
                    CustomTextField(
                      controller: c.vendorPaymentController,
                      labelText: 'Vendor Payment',
                      hintText: '\$00.0',
                    ),
                  ],
                ),

                // ── Additional Notes ───────────────────────────────────────
                CustomTextField(
                  controller: c.additionalNotesController,
                  labelText: 'Additional Notes',
                  hintText:
                      'Add any specific case details or instructions...',
                  maxLine: 4,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomText(
                    text: 'Write at least 80 characters.',
                    fontsize: 10.sp,
                    color: AppColors.secondaryTextColor,
                    right: 2.w,
                  ),
                ),
                SizedBox(height: 14.h),

                // ── Packing Slip ───────────────────────────────────────────
                Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF252525),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.print_outlined,
                          color: AppColors.primaryColor, size: 18.r),
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
                              text: 'PDF preview will be generated.',
                              fontsize: 11.sp,
                              color: AppColors.secondaryTextColor,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      Obx(() => Checkbox(
                            value: c.generatePackingSlip.value,
                            onChanged: (v) =>
                                c.generatePackingSlip.value = v ?? false,
                            activeColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r)),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Sticky button ──────────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.backgroundColor,
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Obx(() => CustomButton(
                    title: 'Create Sale Record',
                    loading: c.isSubmitting.value,
                    onpress: () async {
                      final ok = await c.submit();
                      if (ok && context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                  )),
            ),
          ),

          // ── Loading overlay ────────────────────────────────────────────
          Obx(() => c.isLoadingDropdowns.value
              ? Container(
                  color: AppColors.backgroundColor,
                  child: const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF1AC8DB)),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}

// ── local widgets ─────────────────────────────────────────────────────────────

class _RepCard extends StatelessWidget {
  final RepresentativeModel rep;
  final int index;
  final VoidCallback onRemove;

  const _RepCard(
      {required this.rep, required this.index, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final colors = [const Color(0xFF3A7BD5), const Color(0xFF6C5CE7)];
    final bg = colors[index % colors.length];
    final initials = rep.name.length >= 2
        ? rep.name.substring(0, 2).toUpperCase()
        : rep.name.toUpperCase();

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
                  initials,
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

class _Section extends StatelessWidget {
  final Widget header;
  final List<Widget> children;
  const _Section({required this.header, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [header, SizedBox(height: 12.h), ...children],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 18.r),
        SizedBox(width: 8.w),
        CustomText(
          text: title,
          fontsize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: CustomText(
        text: text,
        fontsize: 12.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryTextColor,
        textAlign: TextAlign.start,
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String? value;
  final List<String> options;
  final String hint;
  final IconData icon;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.value,
    required this.options,
    required this.hint,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final safeValue =
        (value != null && options.contains(value)) ? value : null;
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0x1A4A4A4A),
        borderRadius: BorderRadius.circular(8.r),
        border:
            Border.all(color: AppColors.dotButtonInactiveColor, width: 0.8),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondaryTextColor, size: 16.r),
          SizedBox(width: 8.w),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: safeValue,
                hint: CustomText(
                    text: hint,
                    fontsize: 13.sp,
                    color: AppColors.secondaryTextColor),
                isExpanded: true,
                dropdownColor: const Color(0xFF252525),
                icon: Icon(Icons.keyboard_arrow_down,
                    color: AppColors.secondaryTextColor, size: 18.r),
                style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white,
                    fontFamily: 'Poppins'),
                items: options
                    .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
