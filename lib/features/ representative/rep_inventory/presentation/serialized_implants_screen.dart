import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/implant_list_tile.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/implant_controller.dart';


class SerializedImplantsScreen extends StatefulWidget {
  const SerializedImplantsScreen({super.key});

  @override
  State<SerializedImplantsScreen> createState() =>
      _SerializedImplantsScreenState();
}

class _SerializedImplantsScreenState extends State<SerializedImplantsScreen> {
  final _ctrl = ImplantsController();
  final _searchCtrl = TextEditingController();

  static const _tabs = ['Implants', 'Trays', 'Bio'];

  @override
  void dispose() {
    _ctrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: _BottomNav(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(AppRoutes.addImplantScreen),
        backgroundColor: AppColors.primaryColor,
        shape: const CircleBorder(),
        child: Icon(Icons.add,
            color: AppColors.primaryTextColor, size: 26.r),
      ),
      body: ListenableBuilder(
        listenable: _ctrl,
        builder: (context, _) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      Icon(Icons.menu,
                          color: AppColors.primaryTextColor, size: 22.r),
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
                                color: AppColors.dotButtonInactiveColor,
                                width: 0.6),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 12.w),
                              Icon(Icons.search,
                                  color: AppColors.secondaryTextColor,
                                  size: 18.r),
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
                      // Filter icon button
                      Container(
                        width: 44.r,
                        height: 44.r,
                        decoration: BoxDecoration(
                          color: const Color(0xFF252525),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                              color: AppColors.dotButtonInactiveColor,
                              width: 0.6),
                        ),
                        child: Icon(Icons.tune,
                            color: AppColors.secondaryTextColor, size: 20.r),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),


                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: List.generate(_tabs.length, (i) {
                      final selected = _ctrl.selectedTabIndex == i;
                      return GestureDetector(
                        onTap: () => _ctrl.setTab(i),
                        child: Container(
                          margin: EdgeInsets.only(right: 8.w),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 7.h),
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
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: selected
                                ? AppColors.backgroundColor
                                : AppColors.secondaryTextColor,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 14.h),


                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: _ctrl.filtered.length,
                    itemBuilder: (_, i) {
                      final imp = _ctrl.filtered[i];
                      return ImplantListTile(
                        implant: imp,
                        onDetailsTap: () => context.pushNamed(
                          AppRoutes.implantDetailsScreen,
                          extra: imp,
                        ),
                        onDelete: () => _ctrl.deleteImplant(imp.id),
                        onEdit: () => context.pushNamed(
                          AppRoutes.addImplantScreen,
                          extra: imp,
                        ),
                      );
                    },
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



class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      decoration: const BoxDecoration(
        color: Color(0xFF1E2427),
        border: Border(top: BorderSide(color: Color(0xFF3A3A3A), width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.home_outlined, label: 'Home', active: false),
          _NavItem(
              icon: Icons.inventory_2_outlined,
              label: 'Inventory',
              active: true),
          _NavItem(icon: Icons.qr_code_scanner, label: 'QR Scan', active: false),
          _NavItem(
              icon: Icons.receipt_long_outlined,
              label: 'P. Order',
              active: false),
          _NavItem(
              icon: Icons.person_outline, label: 'Profile', active: false),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavItem(
      {required this.icon, required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    final color =
    active ? AppColors.primaryColor : AppColors.secondaryTextColor;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 22.r),
        SizedBox(height: 2.h),
        CustomText(text: label, fontsize: 10.sp, color: color),
        if (active)
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 4.r,
            height: 4.r,
            decoration: BoxDecoration(
                color: AppColors.primaryColor, shape: BoxShape.circle),
          ),
      ],
    );
  }
}