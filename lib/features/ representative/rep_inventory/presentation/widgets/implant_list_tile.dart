import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/implant_model.dart';


class ImplantListTile extends StatefulWidget {
  final ImplantModel implant;
  final VoidCallback onDetailsTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ImplantListTile({
    super.key,
    required this.implant,
    required this.onDetailsTap,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<ImplantListTile> createState() => _ImplantListTileState();
}

class _ImplantListTileState extends State<ImplantListTile> {
  bool _swiped = false;

  static const double _actionWidth = 72.0;

  void _close() => setState(() => _swiped = false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! < -200) {
          setState(() => _swiped = true);
        } else if (details.primaryVelocity != null &&
            details.primaryVelocity! > 200) {
          setState(() => _swiped = false);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            children: [
              // ── Action buttons (always behind tile) ──────────────────────
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Delete
                    GestureDetector(
                      onTap: () {
                        _close();
                        widget.onDelete();
                      },
                      child: Container(
                        width: _actionWidth.w,
                        color: const Color(0xFFFF4B4B),
                        child: Center(
                          child: CustomText(
                            text: 'Delete',
                            fontsize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // Edit
                    GestureDetector(
                      onTap: () {
                        _close();
                        widget.onEdit();
                      },
                      child: Container(
                        width: _actionWidth.w,
                        color: AppColors.primaryColor,
                        child: Center(
                          child: CustomText(
                            text: 'Edit',
                            fontsize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Main tile (slides left to reveal actions) ─────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(
                    _swiped ? -(_actionWidth * 2).w : 0, 0, 0),
                decoration: const BoxDecoration(
                  color: Color(0xFF252525),
                ),
                padding: EdgeInsets.all(12.r),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A3A3A),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.medical_services_outlined,
                        color: AppColors.secondaryTextColor,
                        size: 22.r,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name + status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: widget.implant.name,
                                  fontsize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryTextColor,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              _StatusBadge(status: widget.implant.status),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          // Lot + material
                          CustomText(
                            text:
                                '${widget.implant.lotNumber} • ${widget.implant.material}',
                            fontsize: 11.sp,
                            color: AppColors.secondaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 6.h),
                          // Facility + Details link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined,
                                      color: AppColors.primaryColor,
                                      size: 13.r),
                                  SizedBox(width: 4.w),
                                  CustomText(
                                    text: widget.implant.facility,
                                    fontsize: 11.sp,
                                    color: AppColors.secondaryTextColor,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: widget.onDetailsTap,
                                child: Row(
                                  children: [
                                    CustomText(
                                      text: 'Details',
                                      fontsize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primaryColor,
                                    ),
                                    Icon(Icons.chevron_right,
                                        color: AppColors.primaryColor,
                                        size: 14.r),
                                  ],
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

// ── Status Badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    String label;
    switch (status) {
      case 'available':
        bg = AppColors.primaryColor;
        label = 'Available';
        break;
      case 'in_stock':
        bg = AppColors.warningColor;
        label = 'In Stock';
        break;
      case 'shipped':
        bg = const Color(0xFF6E6E6E);
        label = 'Shipped';
        break;
      default:
        bg = Colors.grey;
        label = status;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.15),
        border: Border.all(color: bg, width: 0.8),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        text: label,
        fontsize: 10.sp,
        fontWeight: FontWeight.w600,
        color: bg,
      ),
    );
  }
}
