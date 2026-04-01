import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/features/%20representative/rep_home/presentation/widgets/new_po_appbar.dart';
import 'package:nron_app/features/%20representative/rep_home/presentation/widgets/new_pos_ordercard.dart';

import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';

import '../controller/rep_purchase_order_controller.dart';
import 'widgets/new_po_step_header.dart';

class NewPoScreen extends StatelessWidget {
  const NewPoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(NewPoController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const NewPoAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          top: 18.h,
          bottom: 24.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 10.h),
            const NewPoStepHeader(),

            SizedBox(height: 20.h),

            // Order cards
            Obx(() => Column(
              children: [
                // Standard PO
                NewPoOrderCard(
                  type: OrderType.standard,
                  imagePath: 'assets/images/standard.png',
                  svgIcon: 'assets/icons/standard.svg',
                  title: 'Standard PO',
                  subtitle: 'Individual Procurement',
                  description:
                  'Upload PDF or enter details manually for routine clinic supplies and equipment orders.',
                  isSelected: c.isSelected(OrderType.standard),
                  onTap: () => c.selectType(OrderType.standard),
                  onButtonTap: () => context.pushNamed(AppRoutes.createPurchaseScreen),
                ),

                SizedBox(height: 20.h),

                NewPoOrderCard(
                  type: OrderType.bulkBio,
                  imagePath: 'assets/images/bulkbio.png',
                  svgIcon: 'assets/icons/bulkbio.svg',
                  title: 'Bulk BIO Order',
                  subtitle: 'Enterprise Logistics',
                  description:
                  'Complex multi-line items and advanced routing for large scale laboratory and hospital distributions.',
                  isSelected: c.isSelected(OrderType.bulkBio),
                  onTap: () => c.selectType(OrderType.bulkBio),
                  onButtonTap: () => context.pushNamed(AppRoutes.bulkPurchaseScreen),
                ),
              ],
            )),

            SizedBox(height: 32.h),


          ],
        ),
      ),
    );
  }
}
