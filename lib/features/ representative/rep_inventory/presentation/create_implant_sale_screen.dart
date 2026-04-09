import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/active_implant_banner.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/attachment_tile.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../controller/create_implant_sale _controller.dart';
import '../model/implant_model.dart';


class CreateImplantSaleScreen extends StatefulWidget {
  final ImplantModel implant;
  const CreateImplantSaleScreen({super.key, required this.implant});

  @override
  State<CreateImplantSaleScreen> createState() =>
      _CreateImplantSaleScreenState();
}

class _CreateImplantSaleScreenState extends State<CreateImplantSaleScreen> {
  final _ctrl = CreateImplantSaleController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }


  Widget _section({required Widget header, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        header,
        SizedBox(height: 12.h),
        ...children,
      ]),
    );
  }


  Widget _sectionHeader(IconData icon, String title) {
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


  Widget _dropdownField(
      {required String hint,
        required IconData icon,
        String? label,
        Widget? trailing}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            CustomText(
              text: label,
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
                  color: AppColors.dotButtonInactiveColor, width: 0.8),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.secondaryTextColor, size: 16.r),
                SizedBox(width: 8.w),
                Expanded(
                  child: CustomText(
                    text: hint,
                    fontsize: 13.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ),
                trailing ??
                    Icon(Icons.keyboard_arrow_down,
                        color: AppColors.secondaryTextColor, size: 18.r),
              ],
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
      body: ListenableBuilder(
        listenable: _ctrl,
        builder: (context, _) {
          return Form(
            key: _ctrl.formKey,
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding:
                  EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ActiveImplantBanner(
                        serialNumber: widget.implant.serialNumber,
                        implantName: widget.implant.name,
                        imageAsset: widget.implant.imageAsset,
                      ),
                      SizedBox(height: 14.h),

                      CustomText(
                        text: 'SALE TYPE',
                        fontsize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                        bottom: 8.h,
                      ),
                      Row(
                        children: ['Sold', 'Consigned'].map((t) {
                          final sel = _ctrl.saleType == t;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => _ctrl.setSaleType(t),
                              child: Container(
                                height: 38.h,
                                margin: EdgeInsets.only(
                                    right: t == 'Sold' ? 8.w : 0),
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
                                    text: t,
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
                      ),
                      SizedBox(height: 14.h),
                      _section(
                        header: _sectionHeader(
                            Icons.local_shipping_outlined,
                            'Shipment Information'),
                        children: [
                          _dropdownField(
                            hint: 'Dr. Jane Smith',
                            icon: Icons.person_outline,
                            label: 'Physician',
                          ),
                          _dropdownField(
                            hint: 'Search Facility (e.g., City Hospital)',
                            icon: Icons.add,
                            label: 'Facility / Location',
                          ),
                          CustomTextField(
                            controller: _ctrl.procedureDateController,
                            labelText: 'Procedure Date (DOS)',
                            hintText: 'mm/dd/yyyy',
                            keyboardType: TextInputType.datetime,
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              size: 14.r,
                              color: AppColors.secondaryTextColor,
                            ),
                          ),
                          // Add Products
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 44.h,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add,
                                        color: AppColors.primaryColor,
                                        size: 16.r),
                                    SizedBox(width: 6.w),
                                    CustomText(
                                      text: 'Add Products from Inventory',
                                      fontsize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),


                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 14.h),
                        padding: EdgeInsets.all(14.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFF252525),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: 'Add Representativents',
                                  fontsize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryTextColor,
                                  textAlign: TextAlign.start,
                                ),
                                GestureDetector(
                                  onTap: _ctrl.addRepresentative,
                                  child: Row(
                                    children: [
                                      Icon(Icons.add_circle_outline,
                                          color: AppColors.primaryColor,
                                          size: 14.r),
                                      SizedBox(width: 4.w),
                                      CustomText(
                                        text: 'Add',
                                        fontsize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            ..._ctrl.representatives
                                .asMap()
                                .entries
                                .map((entry) {
                              final i = entry.key;
                              final rep = entry.value;
                              return _RepRow(
                                rep: rep,
                                onRemove: () =>
                                    _ctrl.removeRepresentative(i),
                              );
                            }),
                            // Total validation
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E2427),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: _ctrl.totalCommission == 100
                                      ? AppColors.primaryColor
                                      .withValues(alpha: 0.3)
                                      : Colors.red.withValues(alpha: 0.3),
                                  width: 0.8,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: _ctrl.totalCommission == 100
                                        ? AppColors.primaryColor
                                        : Colors.red,
                                    size: 14.r,
                                  ),
                                  SizedBox(width: 6.w),
                                  CustomText(
                                    text:
                                    'Total must equal 100% — Currently ${_ctrl.totalCommission}%',
                                    fontsize: 11.sp,
                                    color: _ctrl.totalCommission == 100
                                        ? AppColors.primaryColor
                                        : Colors.red,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),


                      _section(
                        header:
                        _sectionHeader(Icons.receipt_outlined, 'Billing'),
                        children: [
                          CustomTextField(
                            controller: _ctrl.vendorController,
                            labelText: 'Vendor',
                            hintText: 'name',
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: _ctrl.poNumberController,
                                  labelText: 'PO Number',
                                  hintText: 'PO-12345',
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: CustomTextField(
                                  controller: _ctrl.totalBillController,
                                  labelText: 'Total Bill (\$)',
                                  hintText: '0.00',
                                  keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                                ),
                              ),
                            ],
                          ),
                          CustomTextField(
                            controller: _ctrl.vendorPaymentController,
                            labelText: 'Vendor Payment',
                            hintText: '\$00.0',
                          ),
                        ],
                      ),

                      // ── Attachments ────────────────────────────────────
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 14.h),
                        padding: EdgeInsets.all(14.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFF252525),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: 'Attachments',
                                  fontsize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryTextColor,
                                  textAlign: TextAlign.start,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Icon(Icons.add_circle_outline,
                                          color: AppColors.primaryColor,
                                          size: 14.r),
                                      SizedBox(width: 4.w),
                                      CustomText(
                                        text: 'Add',
                                        fontsize: 12.sp,
                                        color: AppColors.primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            // First file as preview card
                            AttachmentTile(
                              fileName: _ctrl.attachments[0],
                              meta:
                              'UPLOADED OCT 24, 2023 • 2.4 MB',
                              type: AttachmentType.pdf,
                              showPreview: true,
                              onPreview: () {},
                              onDownload: () {},
                            ),
                            // Remaining as list rows
                            ..._ctrl.attachments.skip(1).map((f) {
                              final isDocx = f.endsWith('.docx');
                              return AttachmentTile(
                                fileName: f,
                                meta: isDocx ? '842 KB' : '1.1 MB',
                                type: isDocx
                                    ? AttachmentType.docx
                                    : AttachmentType.pdf,
                                onDownload: () {},
                              );
                            }),
                          ],
                        ),
                      ),

                      // ── Additional Notes ──────────────────────────────
                      CustomTextField(
                        controller: _ctrl.additionalNotesController,
                        labelText: 'Additional Notes',
                        hintText:
                        'Add any specific case details or instructions...',
                        maxLine: 4,
                        validator: (_) => null,
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

                      Container(
                        padding: EdgeInsets.all(14.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFF252525),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.print_outlined,
                                    color: AppColors.primaryColor, size: 18.r),
                                SizedBox(width: 8.w),
                                CustomText(
                                  text: 'Packing Slip',
                                  fontsize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryTextColor,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Container(
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E2427),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.print_outlined,
                                      color: AppColors.primaryColor,
                                      size: 18.r),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: 'Generate Packing Slip',
                                          fontsize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryTextColor,
                                          textAlign: TextAlign.start,
                                        ),
                                        CustomText(
                                          text: 'PDF Preview generated.',
                                          fontsize: 11.sp,
                                          color: AppColors.secondaryTextColor,
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Checkbox(
                                    value: _ctrl.generatePackingSlip,
                                    onChanged: (v) =>
                                        _ctrl.togglePackingSlip(v ?? false),
                                    activeColor: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(4.r)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Sticky Create Sale button ──────────────────────────────
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: AppColors.backgroundColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 12.h),
                    child: CustomButton(
                      title: 'Create Sale Record',
                      onpress: () {
                        if (_ctrl.createSale()) {
                          Navigator.pop(context);
                        }
                      },
                    ),
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



class _RepRow extends StatelessWidget {
  final RepresentativeModel rep;
  final VoidCallback onRemove;

  const _RepRow({required this.rep, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2427),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomText(
                    text: rep.initials,
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
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
                        color: AppColors.primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: CustomText(
                        text: rep.role,
                        fontsize: 10.sp,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Commission
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    text: 'Commission',
                    fontsize: 10.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.end,
                  ),
                  CustomText(
                    text: '${rep.commission} %',
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 6.h),
          GestureDetector(
            onTap: onRemove,
            child: CustomText(
              text: 'REMOVE REPRESENTATIVE',
              fontsize: 10.sp,
              fontWeight: FontWeight.w600,
              color: Colors.redAccent,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}