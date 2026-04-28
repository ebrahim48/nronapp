import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/core/config/app-routes/app_routes.dart';
import 'package:nron_app/features/%20representative/rep_home/presentation/widgets/add_product_widgets.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/add_product_controller.dart';


class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AddProductController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar
              Container(
                color: const Color(0xFF1E2427),
                height: 52.h,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.primaryTextColor,
                          size: 18.r,
                        ),
                      ),
                    ),
                    CustomText(
                      text: 'Add Products',
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),

              // Body + Button
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductDetailsCard(
                      itemNameController: c.itemNameController,
                      quantityController: c.quantityController,
                      unitPriceController: c.unitPriceController,
                      onAddProduct: c.addProduct,
                    ),

                    SizedBox(height: 24.h),

                    Obx(() => AddedItemsSection(
                      items: c.addedItems.toList(),
                      onRemove: c.removeItem,
                    )),

                    SizedBox(height: 16.h),

                    Obx(() => TotalEstCostRow(
                      total: c.addedItems.fold(0.0, (sum, item) => sum + item.price),
                    )),

                    SizedBox(height: 24.h),

                    CustomButton(
                      title: 'Add to PO',
                      onpress: c.addToPO,
                      prefixIcon: SvgPicture.asset(
                        'assets/icons/cart.svg',
                        width: 16.r,
                        height: 16.r,
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    CustomButton(
                      title: 'Barcode Scanner',
                      onpress: () => context.pushNamed(AppRoutes.qrScanScreen),
                      color: const Color(0xFF1E2427),
                      borderColor: AppColors.primaryColor,
                      titlecolor: AppColors.primaryColor,
                      prefixIcon: Icon(
                        Icons.qr_code_scanner,
                        color: AppColors.primaryColor,
                        size: 18.r,
                      ),
                    ),

                    SizedBox(height: 24.h),
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