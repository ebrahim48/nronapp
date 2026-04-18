import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nron_app/features/driver/driverjob/presentation/widgets/earnings_card.dart';
import 'package:nron_app/features/driver/driverjob/presentation/widgets/location_card.dart';
import 'package:nron_app/features/driver/driverjob/presentation/widgets/packages_details_card.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../driver_home/presentation/widgets/special_instructions_card.dart';
import '../controller/new_delivery_controller.dart';


class NewDeliveryDetailsScreen extends StatefulWidget {
  const NewDeliveryDetailsScreen({super.key});

  @override
  State<NewDeliveryDetailsScreen> createState() =>
      _NewDeliveryDetailsScreenState();
}

class _NewDeliveryDetailsScreenState
    extends State<NewDeliveryDetailsScreen> {
  final _ctrl = NewDeliveryController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = _ctrl.delivery;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 60.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.only(left: 16.w),
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: const Color(0xFF252525),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.primaryTextColor,
              size: 16.r,
            ),
          ),
        ),
        leadingWidth: 60.w,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'New Delivery',
              fontsize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
            CustomText(
              text: 'Job Request',
              fontsize: 12.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: _ctrl,
        builder: (context, _) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding:
                EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 100.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Shipment ID + Urgent badge ─────────────────────
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2427),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFF3A3A3A),
                          width: 0.6,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Shipment ID',
                                fontsize: 11.sp,
                                color: AppColors.secondaryTextColor,
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 3.h),
                              CustomText(
                                text: d.shipmentId,
                                fontsize: 20.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryTextColor,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          if (d.isUrgent) _UrgentBadge(),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // ── Earnings card ──────────────────────────────────
                    EarningsCard(
                      earnings: d.earnings,
                      distanceKm: d.distanceKm,
                    ),
                    SizedBox(height: 12.h),

                    // ── Location card ──────────────────────────────────
                    LocationCard(
                      pickupName: d.pickupName,
                      pickupAddress: d.pickupAddress,
                      pickupContact: d.pickupContact,
                      pickupPhone: d.pickupPhone,
                      dropoffName: d.dropoffName,
                      dropoffAddress: d.dropoffAddress,
                      dropoffContact: d.dropoffContact,
                      dropoffPhone: d.dropoffPhone,
                    ),
                    SizedBox(height: 12.h),

                    // ── Package details ────────────────────────────────
                    PackageDetailsCard(
                      servicesType: d.servicesType,
                      weight: d.weight,
                      dimensions: d.dimensions,
                    ),
                    SizedBox(height: 12.h),

                    // ── Special instructions ───────────────────────────
                    if (d.specialInstructions != null &&
                        d.specialInstructions!.isNotEmpty)
                      SpecialInstructionsCard(
                        instructions: d.specialInstructions!,
                      ),
                  ],
                ),
              ),

              // ── Sticky bottom: Decline | Accept ───────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: AppColors.backgroundColor,
                  padding: EdgeInsets.fromLTRB(
                      16.w, 10.h, 16.w, 24.h),
                  child: Row(
                    children: [
                      // Decline
                      Expanded(
                        child: CustomButton(
                          title: 'Decline',
                          color: const Color(0xFF252525),
                          borderColor: const Color(0xFF3A3A3A),
                          titlecolor: AppColors.primaryTextColor,
                          loading: _ctrl.isLoading,
                          onpress: () async {
                            final ok = await _ctrl.declineJob();
                            if (ok && context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Accept
                      Expanded(
                        child: CustomButton(
                          title: 'Accept Job',
                          prefixIcon: Icon(
                            Icons.send_outlined,
                            color: AppColors.primaryTextColor,
                            size: 16.r,
                          ),
                          loading: _ctrl.isLoading,
                          onpress: () async {
                            final ok = await _ctrl.acceptJob();
                            if (ok && context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      'Job accepted successfully!'),
                                  backgroundColor:
                                  AppColors.primaryColor,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Urgent badge ──────────────────────────────────────────────────────────────

class _UrgentBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: const Color(0xFF4A1010),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.redAccent.withValues(alpha: 0.5),
          width: 0.8,
        ),
      ),
      child: CustomText(
        text: 'Urgent',
        fontsize: 12.sp,
        fontWeight: FontWeight.w600,
        color: Colors.redAccent,
      ),
    );
  }
}