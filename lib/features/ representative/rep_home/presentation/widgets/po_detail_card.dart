import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PoDetailCard extends StatelessWidget {
  final String poNumber;
  final String poType;
  final String poStatus;
  final String poTitle;
  final String patientId;
  final String facility;
  final String facilityEmail;
  final String surgeon;
  final String surgeonSpecialty;
  final String dateOfSurgery;
  final String surgeryTime;
  final String vendor;
  final String vendorEmail;
  final double totalAmount;
  final VoidCallback onAddNote;

  final Color cardColor;
  final Color cardBorder;
  final Color accentColor;
  final Color textPrimary;
  final Color textSecondary;

  const PoDetailCard({
    super.key,
    required this.poNumber,
    required this.poType,
    required this.poStatus,
    required this.poTitle,
    required this.patientId,
    required this.facility,
    required this.facilityEmail,
    required this.surgeon,
    required this.surgeonSpecialty,
    required this.dateOfSurgery,
    required this.surgeryTime,
    required this.vendor,
    required this.vendorEmail,
    required this.totalAmount,
    required this.onAddNote,
    required this.cardColor,
    required this.cardBorder,
    required this.accentColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PO number + status badge
          Padding(
            padding:
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$poNumber - ',
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: accentColor,
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: poType,
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: accentColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      poTitle,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: cardBorder),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    poStatus,
                    style: TextStyle(
                        fontSize: 11.sp, color: textSecondary),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: cardBorder),

          // Grid details
          Padding(
            padding:
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            child: Column(
              children: [
                // Row 1: Patient ID + Additional Notes
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _detailItem('Patient ID', patientId),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _detailItem('Additional Notes', ''),
                          SizedBox(width: 6.w),
                          GestureDetector(
                            onTap: onAddNote,
                            child: Icon(
                              Icons.content_paste_outlined,
                              size: 18.sp,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),

                // Row 2: Facility + Date of Surgery
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _detailItem(
                        'Facility',
                        facility,
                        subtitle: facilityEmail,
                      ),
                    ),
                    Expanded(
                      child: _detailItem(
                        'Date of Surgery',
                        dateOfSurgery,
                        subtitle: surgeryTime,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),

                // Row 3: Surgeon + Vendor
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _detailItem(
                        'Surgeon',
                        surgeon,
                        subtitle: surgeonSpecialty,
                      ),
                    ),
                    Expanded(
                      child: _detailItem(
                        'Vendor',
                        vendor,
                        subtitle: vendorEmail,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Divider(height: 1, color: cardBorder),

          // Total Amount
          Padding(
            padding:
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Amount',
                    style: TextStyle(
                        fontSize: 13.sp, color: textSecondary)),
                Text(
                  '\$${totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailItem(String label, String value, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 10.sp, color: textSecondary)),
        SizedBox(height: 3.h),
        if (value.isNotEmpty)
          Text(value,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: textPrimary)),
        if (subtitle != null && subtitle.isNotEmpty)
          Text(subtitle,
              style: TextStyle(fontSize: 10.sp, color: textSecondary)),
      ],
    );
  }
}