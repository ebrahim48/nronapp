import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/new_tray_widgets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/edit_tray_controller.dart';

class EditTrayScreen extends StatefulWidget {
  final String trayId;
  const EditTrayScreen({super.key, required this.trayId});

  @override
  State<EditTrayScreen> createState() => _EditTrayScreenState();
}

class _EditTrayScreenState extends State<EditTrayScreen> {
  late final EditTrayController c;

  @override
  void initState() {
    super.initState();
    c = Get.put(EditTrayController(trayId: widget.trayId));
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF252525),
        title: const Text('Delete Tray', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
        content: const Text('Are you sure you want to delete this tray? This cannot be undone.', style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Poppins')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel', style: TextStyle(color: Colors.white54, fontFamily: 'Poppins'))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Color(0xFFFF4B4B), fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      final ok = await c.deleteTray();
      if (ok && mounted) {
        Navigator.pop(context); // pop EditTrayScreen
        Navigator.pop(context); // pop TrayDetailsScreen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (c.isLoadingDetail.value) {
            return Shimmer.fromColors(
              baseColor: const Color(0xFF2A2A2A),
              highlightColor: const Color(0xFF3A3A3A),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
                child: Column(
                  children: List.generate(5, (_) => Container(
                    margin: EdgeInsets.only(bottom: 14.h),
                    height: 50.h,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
                  )),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios, color: AppColors.primaryTextColor, size: 18.r),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: CustomText(
                        text: 'Edit Tray',
                        fontsize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    GestureDetector(
                      onTap: _confirmDelete,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3A1A1A),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: const Color(0xFFFF4B4B).withValues(alpha: 0.5)),
                        ),
                        child: Row(children: [
                          Icon(Icons.delete_outline, color: const Color(0xFFFF4B4B), size: 14.r),
                          SizedBox(width: 4.w),
                          Text('Delete', style: TextStyle(color: const Color(0xFFFF4B4B), fontSize: 12.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
                        ]),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Photo
                const TrayFieldLabel(text: 'Tray Photo'),
                Obx(() => TrayPhotoSection(
                  selectedPhoto: c.selectedPhoto.value,
                  onAddPhoto: () => c.pickPhoto(context),
                  existingImageUrl: c.existingImageUrl.value,
                )),

                SizedBox(height: 20.h),

                const TrayFieldLabel(text: 'Tray Title'),
                TrayIconTextField(controller: c.trayTitleController, hintText: 'e.g. TR-90210-ORTHO'),

                SizedBox(height: 4.h),

                const TrayFieldLabel(text: 'Facility / Location'),
                Obx(() => TrayFacilityDropdown(
                  value: c.selectedFacilityName.value,
                  options: c.facilityOptions,
                  onChanged: c.selectFacilityByName,
                )),

                SizedBox(height: 4.h),

                const TrayFieldLabel(text: 'Vendor'),
                Obx(() => TrayVendorDropdown(
                  value: c.selectedVendorName.value,
                  options: c.vendorOptions,
                  isLoading: c.isLoadingDropdowns.value,
                  onChanged: c.selectVendorByName,
                )),

                SizedBox(height: 4.h),

                const TrayFieldLabel(text: 'System Type'),
                TrayIconTextField(controller: c.systemTypeController, hintText: 'e.g. invictuss'),

                SizedBox(height: 20.h),

                const TrayFieldLabel(text: 'Inventory Model', isTeal: true),
                Obx(() => InventoryModelToggle(
                  activeIndex: c.inventoryModelIndex.value,
                  onSelect: c.selectInventoryModel,
                )),

                SizedBox(height: 16.h),

                const TrayFieldLabel(text: 'Return By Date'),
                TrayReturnDateField(
                  controller: c.returnDateController,
                  onTap: () => c.pickReturnDate(context),
                ),

                SizedBox(height: 12.h),
                const TrayReturnWarningBanner(),
                SizedBox(height: 16.h),

                const TrayFieldLabel(text: 'Status'),
                Obx(() => TrayStatusSelector(
                  activeIndex: c.statusIndex.value,
                  onSelect: c.selectStatus,
                )),

                SizedBox(height: 16.h),

                const TrayFieldLabel(text: 'Additional Notes'),
                TrayIconTextField(
                  controller: c.additionalNotesController,
                  hintText: 'Add any specific case details or instructions...',
                  maxLines: 5,
                ),

                SizedBox(height: 24.h),

                Obx(() => CustomButton(
                  title: 'Update Tray',
                  loading: c.isSaving.value,
                  onpress: () async {
                    final ok = await c.saveUpdate();
                    if (ok && context.mounted) Navigator.pop(context);
                  },
                  prefixIcon: SvgPicture.asset(
                    'assets/icons/add.svg',
                    width: 18.r,
                    height: 18.r,
                    colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  ),
                )),

                SizedBox(height: 16.h),
              ],
            ),
          );
        }),
      ),
    );
  }
}
