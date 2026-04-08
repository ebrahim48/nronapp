import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nron_app/features/%20representative/shipment/presentation/widgets/section_card.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/track_shipment_controller.dart';


class TrackShipmentScreen extends StatefulWidget {
  const TrackShipmentScreen({super.key});

  @override
  State<TrackShipmentScreen> createState() => _TrackShipmentScreenState();
}

class _TrackShipmentScreenState extends State<TrackShipmentScreen> {
  final _ctrl = TrackShipmentController();

  @override
  void initState() {
    super.initState();
    // Pre-fill demo data
    _ctrl.trackingController.text = '1CZXCA6AC6AS5668685';
    _ctrl.search();
  }

  @override
  void dispose() {
    _ctrl.dispose();
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
          text: 'Track Shipment',
          fontsize: 17.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: ListenableBuilder(
        listenable: _ctrl,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Search Field ───────────────────────────────────────────
                CustomText(
                  text: 'Enter Tracking Number',
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                  bottom: 8.h,
                ),
                Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF252525),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                        color: AppColors.dotButtonInactiveColor, width: 0.8),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 14.w),
                      Expanded(
                        child: TextField(
                          controller: _ctrl.trackingController,
                          style: TextStyle(
                            color: AppColors.primaryTextColor,
                            fontSize: 13.sp,
                            fontFamily: 'Poppins',
                          ),
                          onSubmitted: (_) => _ctrl.search(),
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
                        onTap: _ctrl.search,
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

                if (_ctrl.isLoading)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.r),
                      child: CircularProgressIndicator(
                          color: AppColors.primaryColor),
                    ),
                  )
                else if (_ctrl.hasResult) ...[
                  // ── Tracking Result Card ─────────────────────────────────
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
                            // FedEx logo placeholder
                            Container(
                              width: 44.r,
                              height: 44.r,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Center(
                                child: CustomText(
                                  text: 'FedEx',
                                  fontsize: 9.sp,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF4D148C),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: _ctrl.trackedNumber,
                                    fontsize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryTextColor,
                                    textAlign: TextAlign.start,
                                  ),
                                  CustomText(
                                    text: 'Medical Shipment',
                                    fontsize: 11.sp,
                                    color: AppColors.secondaryTextColor,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: AppColors.warningColor,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: CustomText(
                                text: 'In Transit',
                                fontsize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          height: 0.5,
                          color: const Color(0xFF3A3A3A),
                        ),
                        SizedBox(height: 10.h),
                        CustomText(
                          text: 'Expected by 5:00 PM Tomorrow',
                          fontsize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                        CustomText(
                          text: 'Estimated Delivery',
                          fontsize: 11.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // ── Driver Card ──────────────────────────────────────────
                  Container(
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFF252525),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        // Driver avatar
                        Container(
                          width: 44.r,
                          height: 44.r,
                          decoration: BoxDecoration(
                            color: AppColors.warningColor.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/trackdeiver.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.person,
                                color: AppColors.warningColor,
                                size: 24.r,
                              ),
                            ),
                          ),
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
                        ActionIconButton(
                          icon: Icons.chat_bubble_outline,
                          onTap: () {},
                        ),
                        SizedBox(width: 8.w),
                        ActionIconButton(
                          icon: Icons.phone_outlined,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // ── Live Location (Map) ──────────────────────────────────
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
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // ── Tracking History ─────────────────────────────────────
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
                        isDone: true,
                      ),
                      _TrackEvent(
                        label: 'Package Picked Up',
                        subtitle: 'City Hospital Loading Dock',
                        date: 'Feb 15, 2:30 PM',
                        isDone: true,
                      ),
                      _TrackEvent(
                        label: 'Departed FedEx Facility',
                        subtitle: 'Springfield, IL',
                        date: 'Feb 15, 2:30 PM',
                        isDone: true,
                      ),
                      _TrackEvent(
                        label: 'Arrived at FedEx Facility',
                        subtitle: 'Chicago, IL',
                        date: 'Feb 15, 2:30 PM',
                        isDone: false,
                      ),
                      _TrackEvent(
                        label: 'Delivered',
                        date: 'Feb 15, 2:30 PM',
                        isDone: false,
                        isBold: true,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // ── Package Details ──────────────────────────────────────
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
                      Expanded(
                        child: _PackageDetailCard(
                          label: 'Items',
                          value: 'Medical\nImplant (2)',
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _PackageDetailCard(
                          label: 'Weight',
                          value: '5.2 lbs',
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _PackageDetailCard(
                          label: 'Service',
                          value: 'Priority\nOvernight',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Tracking History widget ───────────────────────────────────────────────────

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
                          color: AppColors.primaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              // Label
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
              // Date
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


class _PackageDetailCard extends StatelessWidget {
  final String label;
  final String value;
  const _PackageDetailCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}