import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/features/%20representative/rep_home/presentation/widgets/po_detail_card.dart';
import 'package:nron_app/features/%20representative/rep_home/presentation/widgets/po_document_file.dart';
import 'package:nron_app/features/%20representative/rep_home/presentation/widgets/po_handwritten_preview.dart';
import '../../../../../core/config/app-routes/app_routes.dart';
import '../controller/review_send_po_controller.dart';


class ReviewSendPoScreen extends StatelessWidget {
  const ReviewSendPoScreen({super.key});

  static const Color _bg = Color(0xff0E0E0E);
  static const Color _card = Color(0xff1A1A1A);
  static const Color _cardBorder = Color(0xff2A2A2A);
  static const Color _accent = Color(0xff00C2CB);
  static const Color _textPrimary = Color(0xffFFFFFF);
  static const Color _textSecondary = Color(0xff8A8A8A);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReviewSendPoController());

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.goNamed(AppRoutes.purchaseOrderScreen),
          child: Icon(Icons.arrow_back, color: _textPrimary, size: 22.sp),
        ),
        title: Text(
          'Review & Send PO',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            color: _textPrimary,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Obx(() => RichText(
              text: TextSpan(
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14.sp),
                children: [
                  TextSpan(
                    text: '${controller.currentStep.value}',
                    style: const TextStyle(
                      color: Color(0xFF137FEC),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: '/${controller.totalSteps.value}',
                    style: TextStyle(
                      color: _textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            _heroImage(controller),

            // PO Detail Card
            Obx(() => Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 16.w, vertical: 12.h),
              child: PoDetailCard(
                poNumber: controller.poNumber.value,
                poType: controller.poType.value,
                poStatus: controller.poStatus.value,
                poTitle: controller.poTitle.value,
                patientId: controller.patientId.value,
                facility: controller.facility.value,
                facilityEmail: controller.facilityEmail.value,
                surgeon: controller.surgeon.value,
                surgeonSpecialty: controller.surgeonSpecialty.value,
                dateOfSurgery: controller.dateOfSurgery.value,
                surgeryTime: controller.surgeryTime.value,
                vendor: controller.vendor.value,
                vendorEmail: controller.vendorEmail.value,
                totalAmount: controller.totalAmount.value,
                onAddNote: controller.addNote,
                cardColor: _card,
                cardBorder: _cardBorder,
                accentColor: _accent,
                textPrimary: _textPrimary,
                textSecondary: _textSecondary,
              ),
            )),

            // Handwritten PO
            Obx(() => Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: PoHandwrittenPreview(
                imagePath: controller.handwrittenPoImage.value,
                fileName: controller.handwrittenPoFileName.value,
                onView: controller.viewHandwrittenPo,
                cardColor: _card,
                cardBorder: _cardBorder,
                accentColor: _accent,
                textPrimary: _textPrimary,
                textSecondary: _textSecondary,
              ),
            )),

            SizedBox(height: 16.h),

            // Documents section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 12.h),
                      child: Text(
                        'Documents',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: _textPrimary,
                        ),
                      ),
                    ),
                    Divider(height: 1, color: _cardBorder),
                    Obx(() => Column(
                      children:
                      controller.documents.asMap().entries.map((e) {
                        final isLast =
                            e.key == controller.documents.length - 1;
                        return Column(
                          children: [
                            PoDocumentTile(
                              doc: e.value,
                              onView: () =>
                                  controller.viewDocument(e.value),
                              accentColor: _accent,
                              textPrimary: _textPrimary,
                              textSecondary: _textSecondary,
                            ),
                            if (!isLast)
                              Divider(height: 1, color: _cardBorder),
                          ],
                        );
                      }).toList(),
                    )),
                  ],
                ),
              ),
            ),

            SizedBox(height: 100.h),
          ],
        ),
      ),

      // Bottom button
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
        color: _bg,
        child: GestureDetector(
          onTap: () => context.goNamed(AppRoutes.purchaseOrderScreen),
          child: Container(
            height: 54.h,
            decoration: BoxDecoration(
              color: _accent,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back_ios_rounded,
                    color: Colors.white, size: 16.sp),
                SizedBox(width: 8.w),
                Text(
                  'Back to Purchase order',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _heroImage(ReviewSendPoController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      height: 180.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: const Color(0xff2A2A2A),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.asset(
          'assets/images/review.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}