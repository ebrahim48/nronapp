import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/manager_sales_model.dart';

class SaleInventoryList extends StatefulWidget {
  final List<SaleInventoryItem> items;

  const SaleInventoryList({super.key, required this.items});

  @override
  State<SaleInventoryList> createState() => _SaleInventoryListState();
}

class _SaleInventoryListState extends State<SaleInventoryList> {
  static const _collapsedCount = 3;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    final visible = _expanded || items.length <= _collapsedCount
        ? items
        : items.take(_collapsedCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Inventory Item List',
          fontsize: 15.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E2121),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
          ),
          child: Column(
            children: [
              if (items.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  child: CustomText(
                    text: 'No items.',
                    fontsize: 12.sp,
                    color: AppColors.secondaryTextColor,
                  ),
                ),
              ...visible.asMap().entries.map((entry) {
                final item = entry.value;
                final isLast = entry.key == visible.length - 1;
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 12.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: item.name,
                                  fontsize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryTextColor,
                                  textAlign: TextAlign.start,
                                  maxline: 2,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                                if (item.serial.isNotEmpty)
                                  CustomText(
                                    text: 'SN: ${item.serial}',
                                    fontsize: 10.sp,
                                    color: AppColors.secondaryTextColor,
                                    textAlign: TextAlign.start,
                                    maxline: 1,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                  color: const Color(0xFF3A3A3A)),
                            ),
                            child: CustomText(
                              text: item.tag,
                              fontsize: 11.sp,
                              color: AppColors.primaryTextColor,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Divider(
                          height: 1,
                          color: const Color(0xFF3A3A3A),
                          thickness: 0.5),
                  ],
                );
              }),
              if (items.length > _collapsedCount) ...[
                Divider(
                    height: 1, color: const Color(0xFF3A3A3A), thickness: 0.5),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Center(
                      child: CustomText(
                        text: _expanded
                            ? 'Show Less'
                            : 'View All ${items.length} Items',
                        fontsize: 13.sp,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}