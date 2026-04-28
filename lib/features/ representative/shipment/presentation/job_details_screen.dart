import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nron_app/features/%20representative/shipment/presentation/widgets/section_card.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../model/shipment_model.dart';


class JobDetailsScreen extends StatelessWidget {
  final ShipmentModel shipment;

  const JobDetailsScreen({super.key, required this.shipment});

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
          text: 'Job Details',
          fontsize: 17.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'STATUS',
                      fontsize: 10.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 4.h),
                    _StatusChip(status: shipment.status),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      text: 'JOB ID',
                      fontsize: 10.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.end,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      text: shipment.jobId ?? '#INV-99284',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),


            SectionCard(
              title: 'Job Info',
              children: [
                // Package type row
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2427),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36.r,
                        height: 36.r,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(Icons.medical_services_outlined,
                            color: AppColors.primaryColor, size: 18.r),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Emergency Medical Supplies',
                            fontsize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                          CustomText(
                            text: 'Package Type',
                            fontsize: 11.sp,
                            color: AppColors.secondaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                // Driver row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18.r,
                      backgroundColor: const Color(0xFF3A3A3A),
                      child: Icon(Icons.person,
                          color: AppColors.secondaryTextColor, size: 18.r),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: shipment.driverAssigned
                                ? shipment.driverName
                                : 'Marcus Thompson',
                            fontsize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                          CustomText(
                            text: 'Assigned Driver',
                            fontsize: 11.sp,
                            color: AppColors.secondaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    ActionIconButton(
                      icon: Icons.phone_outlined,
                      onTap: () {},
                    ),
                    SizedBox(width: 8.w),
                    ActionIconButton(
                      icon: Icons.chat_bubble_outline,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),


            CustomText(
              text: 'Active Shipments',
              fontsize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
              bottom: 10.h,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/activeshipments.png',
                    width: double.infinity,
                    height: 180.h,
                    fit: BoxFit.cover,
                  ),
                  // "In Transit" map marker overlay
                  Positioned(
                    top: 60.h,
                    left: 120.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: CustomText(
                        text: 'In\nTransit',
                        fontsize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            _LocationCard(
              type: 'pickup',
              title: 'Pickup Details',
              dateTime: 'Oct 24, 2023 • 09:15 AM',
              placeName: 'St. Jude Medical Research Hub',
              placeDetail: 'Building 4, Receiving Dock B, South Entrance',
              warning: 'Required temperature control: -20°C. Handle with extreme care.',
              warningIcon: Icons.info_outline,
            ),

            _LocationCard(
              type: 'dropoff',
              title: 'Dropoff Details',
              dateTime: 'Estimated: 11:45 AM',
              placeName: 'City Central Hospital - Lab Wing',
              placeDetail: 'Main Lab Level 3, Room 302',
              warning: 'Restricted access area. ID badge required for entry.',
              warningIcon: Icons.warning_amber_outlined,
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}


class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    String label;
    switch (status) {
      case 'in_transit':
        bg = AppColors.warningColor;
        label = 'In Transit';
        break;
      case 'pending':
        bg = AppColors.warningColor;
        label = 'Pending';
        break;
      case 'delivered':
        bg = const Color(0xFF00D500);
        label = 'Delivered';
        break;
      default:
        bg = AppColors.primaryColor;
        label = status;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: bg, width: 0.8),
      ),
      child: CustomText(
        text: label,
        fontsize: 12.sp,
        fontWeight: FontWeight.w500,
        color: bg,
      ),
    );
  }
}


class _LocationCard extends StatelessWidget {
  final String type; // 'pickup' | 'dropoff'
  final String title;
  final String dateTime;
  final String placeName;
  final String placeDetail;
  final String warning;
  final IconData warningIcon;

  const _LocationCard({
    required this.type,
    required this.title,
    required this.dateTime,
    required this.placeName,
    required this.placeDetail,
    required this.warning,
    required this.warningIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isPickup = type == 'pickup';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPickup
                    ? Icons.arrow_circle_down_outlined
                    : Icons.arrow_circle_up_outlined,
                color: AppColors.primaryColor,
                size: 18.r,
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                CustomText(
                  text: dateTime,
                  fontsize: 11.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 2.w, bottom: 16.h),
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: const Color(0xFF252525),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: placeName,
                fontsize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 4.h),
              CustomText(
                text: placeDetail,
                fontsize: 12.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 8.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(warningIcon,
                      color: AppColors.secondaryTextColor, size: 14.r),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: CustomText(
                      text: warning,
                      fontsize: 11.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}