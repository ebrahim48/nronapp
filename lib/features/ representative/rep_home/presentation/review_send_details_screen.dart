// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../../core/custom_widgets/custom_button.dart';
// import '../../../../core/custom_widgets/custom_text.dart';
// import '../../../../core/utils/app_colors.dart';
// import '../controller/review_send_po_controller.dart';
//
//
// class ReviewSendPoDetailsScreen extends StatelessWidget {
//   ReviewSendPoDetailsScreen({super.key});
//
//
//   final ReviewSendPoController ctrl = Get.put(ReviewSendPoController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: AppColors.backgroundColor,
//         elevation: 0,
//         toolbarHeight: 52.h,
//         leading: GestureDetector(
//           onTap: () => Get.back(), // no context needed
//           child: Icon(Icons.arrow_back_ios_new,
//               color: AppColors.primaryTextColor, size: 18.r),
//         ),
//         title: CustomText(
//           text: 'Review & Send PO',
//           fontsize: 17.sp,
//           fontWeight: FontWeight.w600,
//           color: AppColors.primaryTextColor,
//           textAlign: TextAlign.start,
//         ),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 100.h),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _PoHeaderCard(ctrl: ctrl),
//                 SizedBox(height: 14.h),
//
//                 CustomText(
//                   text: 'Documents',
//                   fontsize: 12.sp,
//                   color: AppColors.secondaryTextColor,
//                   textAlign: TextAlign.start,
//                   bottom: 8.h,
//                 ),
//                 _ViewPoDocButton(),
//                 SizedBox(height: 14.h),
//
//                 // Obx watches only expandedStates — minimal rebuild
//                 Obx(() => _PoProductListCard(ctrl: ctrl)),
//                 SizedBox(height: 14.h),
//
//                 _PoDocumentsSection(ctrl: ctrl),
//               ],
//             ),
//           ),
//
//           // Sticky button — Obx watches only isLoading
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               color: AppColors.backgroundColor,
//               padding:
//               EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//               child: Obx(() => CustomButton(
//                 title: 'Save and send to vendor',
//                 prefixIcon: Icon(Icons.send_outlined,
//                     color: AppColors.primaryTextColor, size: 16.r),
//                 loading: ctrl.isLoading.value,
//                 onpress: ctrl.saveAndSend,
//               )),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ── PO Header Card ────────────────────────────────────────────────────────────
//
// class _PoHeaderCard extends StatelessWidget {
//   final ReviewSendPoController ctrl;
//   const _PoHeaderCard({required this.ctrl});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF252525),
//         borderRadius: BorderRadius.circular(14.r),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius:
//             BorderRadius.vertical(top: Radius.circular(14.r)),
//             child: Image.asset(
//               ctrl.heroImageAsset,
//               width: double.infinity,
//               height: 140.h,
//               fit: BoxFit.cover,
//               errorBuilder: (_, __, ___) => Container(
//                 height: 140.h,
//                 color: const Color(0xFF1E2427),
//                 child: Icon(Icons.image_outlined,
//                     color: AppColors.secondaryTextColor, size: 40.r),
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(14.r),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     CustomText(
//                       text: 'PO ${ctrl.poNumber} - ',
//                       fontsize: 12.sp,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.primaryColor,
//                       textAlign: TextAlign.start,
//                     ),
//                     CustomText(
//                       text: ctrl.poType,
//                       fontsize: 12.sp,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.primaryColor,
//                       textAlign: TextAlign.start,
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 4.h),
//                 CustomText(
//                   text: ctrl.title,
//                   fontsize: 17.sp,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.primaryTextColor,
//                   textAlign: TextAlign.start,
//                 ),
//                 SizedBox(height: 14.h),
//
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: _InfoCell(
//                           label: 'Patient ID', value: ctrl.patientId),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         CustomText(
//                           text: 'Additional Notes',
//                           fontsize: 10.sp,
//                           color: AppColors.secondaryTextColor,
//                           textAlign: TextAlign.end,
//                         ),
//                         SizedBox(height: 4.h),
//                         Icon(Icons.content_paste_outlined,
//                             color: AppColors.primaryColor, size: 20.r),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 12.h),
//
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: _InfoCell(
//                         label: 'Facility',
//                         value: ctrl.facility,
//                         sub: ctrl.facilityEmail,
//                       ),
//                     ),
//                     Expanded(
//                       child: _InfoCell(
//                         label: 'Date of Surgery',
//                         value: ctrl.dateOfSurgery,
//                         sub: ctrl.surgeryTime,
//                         alignEnd: true,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 12.h),
//
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: _InfoCell(
//                         label: 'Surgeon',
//                         value: ctrl.surgeon,
//                         sub: ctrl.surgeonSpecialty,
//                       ),
//                     ),
//                     Expanded(
//                       child: _InfoCell(
//                         label: 'Vendor',
//                         value: ctrl.vendor,
//                         sub: ctrl.vendorEmail,
//                         alignEnd: true,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 14.h),
//
//                 Divider(
//                     color: const Color(0xFF3A3A3A),
//                     height: 1,
//                     thickness: 0.5),
//                 SizedBox(height: 12.h),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     CustomText(
//                       text: 'Total Amount',
//                       fontsize: 13.sp,
//                       color: AppColors.secondaryTextColor,
//                       textAlign: TextAlign.start,
//                     ),
//                     CustomText(
//                       text:
//                       '\$${ctrl.totalAmount.toStringAsFixed(2)}',
//                       fontsize: 16.sp,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.primaryColor,
//                       textAlign: TextAlign.end,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Info Cell ─────────────────────────────────────────────────────────────────
//
// class _InfoCell extends StatelessWidget {
//   final String label;
//   final String value;
//   final String? sub;
//   final bool alignEnd;
//
//   const _InfoCell({
//     required this.label,
//     required this.value,
//     this.sub,
//     this.alignEnd = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final align =
//     alignEnd ? TextAlign.end : TextAlign.start;
//     final cross =
//     alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start;
//     return Column(
//       crossAxisAlignment: cross,
//       children: [
//         CustomText(
//             text: label,
//             fontsize: 10.sp,
//             color: AppColors.secondaryTextColor,
//             textAlign: align),
//         SizedBox(height: 2.h),
//         CustomText(
//             text: value,
//             fontsize: 13.sp,
//             fontWeight: FontWeight.w600,
//             color: AppColors.primaryTextColor,
//             textAlign: align),
//         if (sub != null)
//           CustomText(
//               text: sub!,
//               fontsize: 10.sp,
//               color: AppColors.secondaryTextColor,
//               textAlign: align),
//       ],
//     );
//   }
// }
//
// // ── View PO Doc Button ────────────────────────────────────────────────────────
//
// class _ViewPoDocButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {},
//       child: Container(
//         width: double.infinity,
//         padding:
//         EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//         decoration: BoxDecoration(
//           color: const Color(0xFF0F2A1A),
//           borderRadius: BorderRadius.circular(12.r),
//           border: Border.all(
//               color: AppColors.primaryColor.withValues(alpha: 0.3),
//               width: 0.8),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 36.r,
//               height: 36.r,
//               decoration: BoxDecoration(
//                 color: AppColors.primaryColor.withValues(alpha: 0.15),
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//               child: Icon(Icons.picture_as_pdf_outlined,
//                   color: AppColors.primaryColor, size: 18.r),
//             ),
//             SizedBox(width: 12.w),
//             Expanded(
//               child: CustomText(
//                 text: 'View PO Document (PDF)',
//                 fontsize: 13.sp,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.primaryTextColor,
//                 textAlign: TextAlign.start,
//               ),
//             ),
//             Icon(Icons.open_in_new,
//                 color: AppColors.primaryColor, size: 16.r),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ── Product List Card ─────────────────────────────────────────────────────────
//
// class _PoProductListCard extends StatelessWidget {
//   final ReviewSendPoController ctrl;
//   const _PoProductListCard({required this.ctrl});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF252525),
//         borderRadius: BorderRadius.circular(14.r),
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(
//                 horizontal: 16.w, vertical: 14.h),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 CustomText(
//                   text: 'PRODUCT LIST',
//                   fontsize: 11.sp,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.secondaryTextColor,
//                   textAlign: TextAlign.start,
//                 ),
//                 CustomText(
//                   text: '${ctrl.products.length} Items',
//                   fontsize: 12.sp,
//                   color: AppColors.secondaryTextColor,
//                   textAlign: TextAlign.end,
//                 ),
//               ],
//             ),
//           ),
//           ...ctrl.products.asMap().entries.map((entry) {
//             final i = entry.key;
//             final product = entry.value;
//             return _ProductRow(
//               product: product,
//               isExpanded: ctrl.expandedStates[i],
//               onToggle: () => ctrl.toggleProduct(i),
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }
//
// class _ProductRow extends StatelessWidget {
//   final PoProductItem product;
//   final bool isExpanded;
//   final VoidCallback onToggle;
//
//   const _ProductRow({
//     required this.product,
//     required this.isExpanded,
//     required this.onToggle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Divider(
//             color: const Color(0xFF3A3A3A),
//             height: 1,
//             thickness: 0.5),
//         Padding(
//           padding: EdgeInsets.all(14.r),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CustomText(
//                     text: product.boxCode,
//                     fontsize: 14.sp,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.primaryTextColor,
//                     textAlign: TextAlign.start,
//                   ),
//                   SizedBox(height: 2.h),
//                   CustomText(
//                     text: product.description,
//                     fontsize: 11.sp,
//                     color: AppColors.secondaryTextColor,
//                     textAlign: TextAlign.start,
//                   ),
//                 ],
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: 10.w, vertical: 5.h),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF3A3A3A),
//                   borderRadius: BorderRadius.circular(20.r),
//                 ),
//                 child: CustomText(
//                   text:
//                   '${product.itemCount.toString().padLeft(2, '0')} ITEMS',
//                   fontsize: 10.sp,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.primaryTextColor,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         GestureDetector(
//           onTap: onToggle,
//           child: Container(
//             width: double.infinity,
//             padding: EdgeInsets.symmetric(vertical: 8.h),
//             color: const Color(0xFF1E2427),
//             child: Icon(
//               isExpanded
//                   ? Icons.keyboard_arrow_up
//                   : Icons.keyboard_arrow_down,
//               color: AppColors.secondaryTextColor,
//               size: 20.r,
//             ),
//           ),
//         ),
//         if (isExpanded && product.serialRanges.isNotEmpty)
//           Container(
//             color: const Color(0xFF1E2427),
//             child: Column(
//               children: product.serialRanges
//                   .map(
//                     (sr) => Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 14.w, vertical: 8.h),
//                   child: Row(
//                     children: [
//                       Icon(Icons.drag_indicator,
//                           color: AppColors.secondaryTextColor,
//                           size: 14.r),
//                       SizedBox(width: 8.w),
//                       CustomText(
//                         text: sr,
//                         fontsize: 12.sp,
//                         color: AppColors.secondaryTextColor,
//                         textAlign: TextAlign.start,
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//                   .toList(),
//             ),
//           ),
//       ],
//     );
//   }
// }
//
// // ── Documents Section ─────────────────────────────────────────────────────────
//
// class _PoDocumentsSection extends StatelessWidget {
//   final ReviewSendPoController ctrl;
//   const _PoDocumentsSection({required this.ctrl});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF252525),
//         borderRadius: BorderRadius.circular(14.r),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
//             child: CustomText(
//               text: 'Documents',
//               fontsize: 13.sp,
//               fontWeight: FontWeight.w600,
//               color: AppColors.secondaryTextColor,
//               textAlign: TextAlign.start,
//             ),
//           ),
//           Divider(
//               color: const Color(0xFF3A3A3A),
//               height: 1,
//               thickness: 0.5),
//           ...ctrl.documents.map((doc) {
//             final isPdf = doc.type == 'pdf';
//             final iconColor =
//             isPdf ? Colors.redAccent : AppColors.primaryColor;
//             final bgColor = isPdf
//                 ? Colors.redAccent.withValues(alpha: 0.12)
//                 : AppColors.primaryColor.withValues(alpha: 0.12);
//             final icon =
//             isPdf ? Icons.picture_as_pdf : Icons.image_outlined;
//
//             return Column(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 14.w, vertical: 12.h),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 36.r,
//                         height: 36.r,
//                         decoration: BoxDecoration(
//                             color: bgColor,
//                             borderRadius:
//                             BorderRadius.circular(8.r)),
//                         child: Icon(icon,
//                             color: iconColor, size: 18.r),
//                       ),
//                       SizedBox(width: 12.w),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment:
//                           CrossAxisAlignment.start,
//                           children: [
//                             CustomText(
//                               text: doc.fileName,
//                               fontsize: 13.sp,
//                               fontWeight: FontWeight.w500,
//                               color: AppColors.primaryTextColor,
//                               textAlign: TextAlign.start,
//                             ),
//                             CustomText(
//                               text: '${doc.size} - ${doc.date}',
//                               fontsize: 10.sp,
//                               color: AppColors.secondaryTextColor,
//                               textAlign: TextAlign.start,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Icon(Icons.remove_red_eye_outlined,
//                           color: AppColors.primaryColor, size: 20.r),
//                     ],
//                   ),
//                 ),
//                 Divider(
//                     color: const Color(0xFF3A3A3A),
//                     height: 1,
//                     thickness: 0.5,
//                     indent: 14.w,
//                     endIndent: 14.w),
//               ],
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }