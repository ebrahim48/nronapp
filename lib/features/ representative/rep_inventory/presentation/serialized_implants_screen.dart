import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/implant_list_tile.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../appdrawer/app_drawer.dart';
import '../controller/implant_controller.dart';


class SerializedImplantsScreen extends StatefulWidget {
  const SerializedImplantsScreen({super.key});

  @override
  State<SerializedImplantsScreen> createState() => _SerializedImplantsScreenState();
}

class _SerializedImplantsScreenState extends State<SerializedImplantsScreen> {
  late final ImplantsController _ctrl;
  final _searchCtrl = TextEditingController();

  static const _tabs = ['Implants', 'Trays', 'Bio'];

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(ImplantsController());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(AppRoutes.addImplantScreen),
        backgroundColor: AppColors.primaryColor,
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: AppColors.primaryTextColor, size: 26.r),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Icon(Icons.arrow_back_ios,
                            color: AppColors.primaryTextColor, size: 18.r),
                      ),
                      SizedBox(width: 8.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Serialized Implants',
                            fontsize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                          CustomText(
                            text: 'Manage and track medical hardware',
                            fontsize: 11.sp,
                            color: AppColors.secondaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Builder(
                    builder: (ctx) => GestureDetector(
                      onTap: () => Scaffold.of(ctx).openDrawer(),
                      child: Icon(Icons.menu,
                          color: AppColors.primaryTextColor, size: 22.r),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF252525),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                            color: AppColors.dotButtonInactiveColor, width: 0.6),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 12.w),
                          Icon(Icons.search,
                              color: AppColors.secondaryTextColor, size: 18.r),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: TextField(
                              controller: _searchCtrl,
                              style: TextStyle(
                                color: AppColors.primaryTextColor,
                                fontSize: 13.sp,
                                fontFamily: 'Poppins',
                              ),
                              onChanged: _ctrl.setSearch,
                              decoration: InputDecoration(
                                hintText: 'Search Serial, lot, or name ...',
                                hintStyle: TextStyle(
                                  color: AppColors.secondaryTextColor,
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10.h),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    width: 44.r,
                    height: 44.r,
                    decoration: BoxDecoration(
                      color: const Color(0xFF252525),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                          color: AppColors.dotButtonInactiveColor, width: 0.6),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/filter.svg',
                      width: 20.r,
                      height: 20.r,
                      colorFilter: ColorFilter.mode(
                        AppColors.secondaryTextColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: List.generate(_tabs.length, (i) {
                  final selected = i == 0;
                  return Container(
                    margin: EdgeInsets.only(right: 8.w),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primaryTextColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: selected
                            ? AppColors.primaryTextColor
                            : AppColors.dotButtonInactiveColor,
                        width: 1,
                      ),
                    ),
                    child: CustomText(
                      text: _tabs[i],
                      fontsize: 12.sp,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected
                          ? AppColors.backgroundColor
                          : AppColors.secondaryTextColor,
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 14.h),

            Expanded(
              child: Obx(() {
                if (_ctrl.isLoading.value) {
                  return Shimmer.fromColors(
                    baseColor: const Color(0xFF2A2A2A),
                    highlightColor: const Color(0xFF3A3A3A),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: 6,
                      itemBuilder: (_, __) => Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        height: 88.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  );
                }
                final items = _ctrl.filtered;
                if (items.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: 'No implants found.',
                      fontsize: 14.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final imp = items[i];
                    return ImplantListTile(
                      implant: imp,
                      onDetailsTap: () => context.pushNamed(
                        AppRoutes.implantDetailsScreen,
                        extra: imp.id,
                      ),
                      onDelete: () => _ctrl.deleteImplant(imp.id),
                      onEdit: () => context.pushNamed(
                        AppRoutes.addImplantScreen,
                        extra: imp,
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
