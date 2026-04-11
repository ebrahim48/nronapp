// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../../ representative/shipment/model/shipment_model.dart';
// import '../../../../../core/constants/app_colors.dart';
// import '../../../../../core/custom_widgets/custom_text.dart';
// import '../../model/shipment_model.dart' hide ShipmentModel;
//
// class ActiveShipmentCard extends StatelessWidget {
//   final ShipmentModel shipment;
//   final VoidCallback? onTap;
//
//   const ActiveShipmentCard({
//     super.key,
//     required this.shipment,
//     this.onTap,
//   });
//
//   Color _statusColor(ShipmentStatus s) {
//     switch (s) {
//       case ShipmentStatus.pending:
//         return AppColors.warningColor;
//       case ShipmentStatus.inTransit:
//         return const Color(0xFF1DB954);
//       case ShipmentStatus.delivered:
//         return AppColors.primaryColor;
//     }
//   }
//
//   String _statusLabel(ShipmentStatus s) {
//     switch (s) {
//       case ShipmentStatus.pending:
//         return 'Pending';
//       case ShipmentStatus.inTransit:
//         return 'In Transit';
//       case ShipmentStatus.delivered:
//         return 'Delivered';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final sc = _statusColor(shipment.status);
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.only(bottom: 14.h),
//         padding: EdgeInsets.all(14.r),
//         decoration: BoxDecoration(
//           color: const Color(0xFF1E2121),
//           borderRadius: BorderRadius.circular(12.r),
//           border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Title + status
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: CustomText(
//                     text: shipment.title,
//                     fontsize: 14.sp,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.primaryTextColor,
//                     textAlign: TextAlign.start,
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
//                   decoration: BoxDecoration(
//                     color: sc.withValues(alpha: 0.15),
//                     borderRadius: BorderRadius.circular(20.r),
//                   ),
//                   child: Text(
//                     _statusLabel(shipment.status),
//                     style: TextStyle(
//                       fontSize: 11.sp,
//                       fontFamily: 'Poppins',
//                       fontWeight: FontWeight.w600,
//                       color: sc,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//             SizedBox(height: 2.h),
//             CustomText(
//               text: shipment.refNumber,
//               fontsize: 11.sp,
//               color: AppColors.secondaryTextColor,
//               textAlign: TextAlign.start,
//             ),
//
//             SizedBox(height: 10.h),
//
//             // Driver + Pickup Date row
//             Row(
//               children: [
//                 Container(
//                   width: 34.r,
//                   height: 34.r,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF2A2A2A),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(Icons.person_outline,
//                       color: AppColors.secondaryTextColor, size: 18.r),
//                 ),
//                 SizedBox(width: 10.w),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CustomText(
//                         text: 'Driver',
//                         fontsize: 10.sp,
//                         color: AppColors.secondaryTextColor,
//                         textAlign: TextAlign.start,
//                       ),
//                       CustomText(
//                         text: shipment.driver,
//                         fontsize: 12.sp,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.primaryTextColor,
//                         textAlign: TextAlign.start,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     CustomText(
//                       text: 'Pickup Date',
//                       fontsize: 10.sp,
//                       color: AppColors.secondaryTextColor,
//                       textAlign: TextAlign.start,
//                     ),
//                     CustomText(
//                       text: shipment.pickupDate,
//                       fontsize: 12.sp,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.primaryTextColor,
//                       textAlign: TextAlign.start,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//
//             SizedBox(height: 12.h),
//
//             // Pickup → Drop route
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Column(
//                   children: [
//                     Container(
//                       width: 10.r,
//                       height: 10.r,
//                       decoration: const BoxDecoration(
//                         color: AppColors.primaryColor,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     Container(
//                       width: 1.5,
//                       height: 36.h,
//                       color: const Color(0xFF3A3A3A),
//                     ),
//                     Container(
//                       width: 10.r,
//                       height: 10.r,
//                       decoration: const BoxDecoration(
//                         color: Color(0xFF5A5A5A),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(width: 10.w),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CustomText(
//                         text: 'Pickup',
//                         fontsize: 10.sp,
//                         color: AppColors.secondaryTextColor,
//                         textAlign: TextAlign.start,
//                       ),
//                       CustomText(
//                         text: shipment.pickup,
//                         fontsize: 12.sp,
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.primaryTextColor,
//                         textAlign: TextAlign.start,
//                       ),
//                       SizedBox(height: 12.h),
//                       CustomText(
//                         text: 'Drop Address',
//                         fontsize: 10.sp,
//                         color: AppColors.secondaryTextColor,
//                         textAlign: TextAlign.start,
//                       ),
//                       CustomText(
//                         text: shipment.dropAddress,
//                         fontsize: 12.sp,
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.primaryTextColor,
//                         textAlign: TextAlign.start,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }