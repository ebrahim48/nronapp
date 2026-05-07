import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/implant_details_controller.dart';
import '../model/implant_model.dart';

class ImplantDetailsScreen extends StatelessWidget {
  final String id;

  const ImplantDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ImplantDetailsController());
    WidgetsBinding.instance.addPostFrameCallback((_) => c.loadDetail(id));

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
          text: 'Implant Details',
          fontsize: 17.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return Shimmer.fromColors(
            baseColor: const Color(0xFF2A2A2A),
            highlightColor: const Color(0xFF3A3A3A),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 160.h),
              child: Column(
                children: List.generate(
                  4,
                  (_) => Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 160.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      width: double.infinity,
                      height: 200.h,
                      color: const Color(0xFF252525),
                      child: c.imageUrl.value.startsWith('http')
                          ? Image.network(c.imageUrl.value, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _ImgPlaceholder())
                          : _ImgPlaceholder(),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  _SectionHeader(
                    title: 'General Information',
                    badge: c.status.value.isNotEmpty
                        ? _StatusBadge(status: c.status.value)
                        : null,
                  ),
                  SizedBox(height: 10.h),
                  _InfoCard(rows: [
                    _InfoRow(icon: Icons.grid_view, label: 'Serial Number', value: c.serialNumber.value),
                    _InfoRow(icon: Icons.tune, label: 'System Type', value: c.systemType.value),
                    _InfoRow(icon: Icons.business_outlined, label: 'Vendor', value: c.vendor.value),
                    _InfoRow(icon: Icons.info_outline, label: 'Status', value: c.status.value),
                  ]),
                  SizedBox(height: 16.h),

                  _SectionHeader(title: 'Location & Logistics'),
                  SizedBox(height: 10.h),
                  _InfoCard(rows: [
                    _InfoRow(icon: Icons.location_on_outlined, label: 'Facility Address', value: c.facilityAddress.value),
                    _InfoRow(icon: Icons.email_outlined, label: 'Recipient Email', value: c.recipientEmail.value),
                  ]),
                  SizedBox(height: 16.h),

                  _SectionHeader(title: 'Additional Notes'),
                  SizedBox(height: 10.h),
                  _NoteCard(text: c.additionalNote.value.isNotEmpty ? c.additionalNote.value : 'No additional notes.'),

                  if (c.brokenNote.value.isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    _SectionHeader(title: 'Broken Instrument Notes'),
                    SizedBox(height: 10.h),
                    _NoteCard(text: c.brokenNote.value),
                  ],

                  SizedBox(height: 16.h),
                  _SectionHeader(title: 'Uploaded Files'),
                  SizedBox(height: 10.h),

                  if (c.inboundFiles.isNotEmpty) ...[
                    CustomText(
                      text: 'Inbound Images',
                      fontsize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                      bottom: 8.h,
                    ),
                    _ImageGrid(urls: c.inboundFiles),
                    SizedBox(height: 12.h),
                  ],

                  if (c.brokenFiles.isNotEmpty) ...[
                    CustomText(
                      text: 'Broken Instrument Images',
                      fontsize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                      bottom: 8.h,
                    ),
                    _ImageGrid(urls: c.brokenFiles),
                    SizedBox(height: 12.h),
                  ],

                  if (c.inboundFiles.isEmpty && c.brokenFiles.isEmpty)
                    CustomText(
                      text: 'No files uploaded.',
                      fontsize: 12.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                ],
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: AppColors.backgroundColor,
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 24.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      title: 'Create Implant Sale',
                      prefixIcon: Icon(Icons.person_add_alt_1_outlined,
                          color: AppColors.primaryTextColor, size: 18.r),
                      onpress: () => context.pushNamed(
                        AppRoutes.createImplantSaleScreen,
                        extra: _buildModel(c),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            title: 'Ship',
                            color: const Color(0xFF252525),
                            borderColor: AppColors.dotButtonInactiveColor,
                            prefixIcon: Icon(Icons.local_shipping_outlined,
                                color: AppColors.primaryTextColor, size: 16.r),
                            onpress: () => context.pushNamed(
                              AppRoutes.createShipmentFromImplantScreen,
                              extra: _buildModel(c),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: CustomButton(
                            title: 'Transfer',
                            color: const Color(0xFF252525),
                            borderColor: AppColors.dotButtonInactiveColor,
                            prefixIcon: Icon(Icons.swap_horiz,
                                color: AppColors.primaryTextColor, size: 16.r),
                            onpress: () => context.pushNamed(
                              AppRoutes.transferImplantScreen,
                              extra: _buildModel(c),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  ImplantModel _buildModel(ImplantDetailsController c) => ImplantModel(
        id: id,
        serialNumber: c.serialNumber.value,
        name: c.systemType.value,
        lotNumber: '',
        material: '',
        systemType: c.systemType.value,
        vendor: c.vendor.value,
        vendorId: c.vendorId.value.isNotEmpty ? c.vendorId.value : null,
        status: c.status.value,
        facility: c.facilityAddress.value,
        facilityId: c.facilityId.value.isNotEmpty ? c.facilityId.value : null,
        recipientEmail: c.recipientEmail.value,
        imageAsset: c.imageUrl.value.isNotEmpty ? c.imageUrl.value : null,
        additionalNote: c.additionalNote.value,
      );
}

class _ImgPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF252525),
      child: Center(
        child: Icon(Icons.medical_services_outlined, color: Colors.white24, size: 48.r),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final String text;
  const _NoteCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: CustomText(
        text: text,
        fontsize: 12.sp,
        color: AppColors.secondaryTextColor,
        textAlign: TextAlign.start,
        textHeight: 1.5,
      ),
    );
  }
}

class _ImageGrid extends StatelessWidget {
  final List<String> urls;
  const _ImageGrid({required this.urls});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: urls.map((url) => ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Image.network(
          url,
          width: 80.r,
          height: 80.r,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 80.r,
            height: 80.r,
            color: const Color(0xFF2A2A2A),
            child: Icon(Icons.broken_image_outlined, color: Colors.white24, size: 24.r),
          ),
        ),
      )).toList(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? badge;

  const _SectionHeader({required this.title, this.badge});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
          fontsize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        if (badge != null) badge!,
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<_InfoRow> rows;
  const _InfoCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: rows.asMap().entries.map((entry) => Column(
          children: [
            entry.value,
            if (entry.key < rows.length - 1)
              const Divider(color: Color(0xFF3A3A3A), height: 1, thickness: 0.5),
          ],
        )).toList(),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 16.r),
          SizedBox(width: 10.w),
          CustomText(
            text: label,
            fontsize: 12.sp,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),
          const Spacer(),
          Flexible(
            child: CustomText(
              text: value.isEmpty ? '—' : value,
              fontsize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  Color get _color {
    switch (status.toLowerCase()) {
      case 'available': return const Color(0xFF4CAF50);
      case 'in stock':
      case 'in_stock': return AppColors.primaryColor;
      case 'shipped': return const Color(0xFFFF9800);
      default: return AppColors.secondaryTextColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        border: Border.all(color: _color, width: 0.8),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        text: status,
        fontsize: 11.sp,
        fontWeight: FontWeight.w600,
        color: _color,
      ),
    );
  }
}
