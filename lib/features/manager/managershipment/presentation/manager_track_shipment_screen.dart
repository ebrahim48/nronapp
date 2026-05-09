import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/shipmentcontroller.dart';

class ManagerTrackShipmentScreen extends StatelessWidget {
  const ManagerTrackShipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ShipmentController>();

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
        centerTitle: false,
        title: CustomText(
          text: 'Track Shipment',
          fontsize: 17.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Container(
                height: 48.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF252525),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                      color: const Color(0xFF3A3A3A), width: 0.8),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 14.w),
                    Expanded(
                      child: TextField(
                        controller: c.trackingTextController,
                        style: TextStyle(
                          color: AppColors.primaryTextColor,
                          fontSize: 13.sp,
                          fontFamily: 'Poppins',
                        ),
                        onSubmitted: (_) => c.searchTracking(),
                        decoration: InputDecoration(
                          hintText: 'Enter tracking number',
                          hintStyle: TextStyle(
                            color: AppColors.secondaryTextColor,
                            fontSize: 13.sp,
                            fontFamily: 'Poppins',
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 12.h),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: c.searchTracking,
                      child: Padding(
                        padding: EdgeInsets.only(right: 14.w),
                        child: Icon(Icons.search,
                            color: AppColors.secondaryTextColor, size: 20.r),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              if (c.isTrackingLoading.value)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.r),
                    child: CircularProgressIndicator(
                        color: AppColors.primaryColor),
                  ),
                )
              else if (c.hasTrackingResult.value) ...[

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'STATUS',
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontFamily: 'Poppins',
                            color: AppColors.secondaryTextColor,
                            letterSpacing: 0.8,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color:
                            AppColors.warningColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                                color: AppColors.warningColor, width: 0.8),
                          ),
                          child: Text(
                            'In Transit',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: AppColors.warningColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'JOB ID',
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontFamily: 'Poppins',
                            color: AppColors.secondaryTextColor,
                            letterSpacing: 0.8,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        CustomText(
                          text: 'SH-1845284',
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Job Info',
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7B1818),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              'urgent',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Company row
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
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
                                color: AppColors.primaryColor
                                    .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(Icons.business_outlined,
                                  color: AppColors.primaryColor, size: 18.r),
                            ),
                            SizedBox(width: 10.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: 'Company name',
                                  fontsize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryTextColor,
                                  textAlign: TextAlign.start,
                                ),
                                CustomText(
                                  text: 'Implant',
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
                            backgroundImage: const AssetImage(
                                'assets/images/trackdeiver.jpg'),
                            backgroundColor: const Color(0xFF3A3A3A),
                            onBackgroundImageError: (_, __) {},
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: 'Marcus Thompson',
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
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 36.r,
                              height: 36.r,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2E2E2E),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.phone_outlined,
                                  color: AppColors.primaryColor, size: 17.r),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                CustomText(
                  text: 'Live Location',
                  fontsize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                  bottom: 10.h,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.asset(
                    'assets/images/activeshipments.png',
                    width: double.infinity,
                    height: 160.h,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 160.h,
                      color: const Color(0xFF1A2E3A),
                      child: Center(
                        child: Icon(Icons.map_outlined,
                            color: Colors.white24, size: 48.r),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                CustomText(
                  text: 'Tracking History',
                  fontsize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                  bottom: 12.h,
                ),
                _TrackingHistory(
                  events: const [
                    _TrackEvent(
                        label: 'Pending Approval',
                        date: 'Feb 15, 2:30 PM',
                        isDone: true),
                    _TrackEvent(
                        label: 'Package Picked Up',
                        subtitle: 'City Hospital Loading Dock',
                        date: 'Feb 15, 2:30 PM',
                        isDone: true),
                    _TrackEvent(
                        label: 'Departed FedEx Facility',
                        subtitle: 'Springfield, IL',
                        date: 'Feb 15, 2:30 PM',
                        isDone: true),
                    _TrackEvent(
                        label: 'Arrived at FedEx Facility',
                        subtitle: 'Chicago, IL',
                        date: 'Feb 15, 2:30 PM',
                        isDone: false),
                    _TrackEvent(
                        label: 'Delivered',
                        date: 'Feb 15, 2:30 PM',
                        isDone: false,
                        isBold: true),
                  ],
                ),

                SizedBox(height: 20.h),

                CustomText(
                  text: 'Package Details',
                  fontsize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                  bottom: 12.h,
                ),
                Row(
                  children: [
                    _PackageCell(
                        label: 'Items', value: 'Medical\nImplant (2)'),
                    SizedBox(width: 8.w),
                    _PackageCell(label: 'Weight', value: '5.2 lbs'),
                    SizedBox(width: 8.w),
                    _PackageCell(
                        label: 'Service', value: 'Priority\nOvernight'),
                  ],
                ),
                SizedBox(height: 24.h),
              ],
            ],
          ),
        );
      }),
    );
  }
}


class _TrackEvent {
  final String label;
  final String? subtitle;
  final String date;
  final bool isDone;
  final bool isBold;

  const _TrackEvent({
    required this.label,
    this.subtitle,
    required this.date,
    required this.isDone,
    this.isBold = false,
  });
}

class _TrackingHistory extends StatelessWidget {
  final List<_TrackEvent> events;
  const _TrackingHistory({required this.events});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(events.length, (i) {
        final e = events[i];
        final isLast = i == events.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24.w,
                child: Column(
                  children: [
                    Container(
                      width: 12.r,
                      height: 12.r,
                      decoration: BoxDecoration(
                        color: e.isDone
                            ? AppColors.primaryColor
                            : const Color(0xFF3A3A3A),
                        shape: BoxShape.circle,
                        border: e.isDone
                            ? null
                            : Border.all(
                            color: AppColors.secondaryTextColor,
                            width: 1.5),
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 1.5.w,
                          color: AppColors.primaryColor.withOpacity(0.3),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: e.label,
                        fontsize: 13.sp,
                        fontWeight:
                        e.isBold ? FontWeight.w700 : FontWeight.w500,
                        color: e.isDone
                            ? AppColors.primaryTextColor
                            : AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                      if (e.subtitle != null)
                        CustomText(
                          text: e.subtitle!,
                          fontsize: 11.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                    ],
                  ),
                ),
              ),
              CustomText(
                text: e.date,
                fontsize: 11.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.end,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _PackageCell extends StatelessWidget {
  final String label, value;
  const _PackageCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFF252525),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFF3A3A3A), width: 0.6),
        ),
        child: Column(
          children: [
            CustomText(
              text: label,
              fontsize: 10.sp,
              color: AppColors.secondaryTextColor,
            ),
            SizedBox(height: 4.h),
            CustomText(
              text: value,
              fontsize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
            ),
          ],
        ),
      ),
    );
  }
}