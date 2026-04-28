import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../appdrawer/app_drawer.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/physicians_controller.dart';
import 'add_physicians_screen.dart';
import 'physicions_profile_screen.dart';
import 'widgets/physician_card.dart';


class PhysiciansScreen extends StatelessWidget {
  const PhysiciansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(PhysiciansController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 60.h,
        automaticallyImplyLeading: false,
        centerTitle: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        titleSpacing: 8.w,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: 'Physicians',
              fontsize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
            CustomText(
              text: 'Manage doctors & surgeries',
              fontsize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.start,
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (ctx) => Padding(
              padding: EdgeInsets.only(right: 24.w),
              child: GestureDetector(
                onTap: () => Scaffold.of(ctx).openDrawer(),
                child: SvgPicture.asset(
                  'assets/icons/drawer.svg',
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 40.h),
        child: Column(
          children: [
            Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2121),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/search.svg',
                    width: 18.r,
                    height: 18.r,
                    colorFilter: const ColorFilter.mode(
                      AppColors.secondaryTextColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextFormField(
                      onChanged: c.onSearch,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13.sp,
                        color: AppColors.primaryTextColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search by PO#, Surgeon, or facility',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13.sp,
                          color: AppColors.secondaryTextColor,
                        ),
                        border: InputBorder.none,
                        isCollapsed: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 2.h),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 14.h),

            // ── Add Physician button ────────────────────────────────
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddPhysicianScreen(),
                ),
              ),
              child: Container(
                width: double.infinity,
                height: 48.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF137FEC),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 18.r),
                    SizedBox(width: 8.w),
                    CustomText(
                      text: 'Add Physician',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // ── Physician cards ─────────────────────────────────────
            Obx(() => Column(
              children: c.filtered
                  .map((p) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: PhysicianCard(
                  physician: p,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PhysicianProfileScreen(physician: p),),),
                  onAddSurgeries: () {
                    // TODO: navigate to add surgeries
                  },
                  onEdit: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddPhysicianScreen(),
                    ),
                  ),
                  onDelete: () => _confirmDelete(context, c, p),
                ),
              ))
                  .toList(),
            )),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, PhysiciansController c, PhysicianItem p) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E2121),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        title: CustomText(
          text: 'Delete Physician',
          fontsize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
        ),
        content: CustomText(
          text: 'Are you sure you want to delete ${p.name}?',
          fontsize: 13.sp,
          color: AppColors.secondaryTextColor,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: CustomText(
              text: 'Cancel',
              fontsize: 13.sp,
              color: AppColors.secondaryTextColor,
            ),
          ),
          TextButton(
            onPressed: () {
              c.deletePhysician(p.id);
              Navigator.pop(context);
            },
            child: CustomText(
              text: 'Delete',
              fontsize: 13.sp,
              color: const Color(0xFFFF4D4F),
            ),
          ),
        ],
      ),
    );
  }
}
