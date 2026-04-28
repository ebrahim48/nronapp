import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../controller/add_product_controller.dart';

class ProductDetailsCard extends StatelessWidget {
  final TextEditingController itemNameController;
  final TextEditingController quantityController;
  final TextEditingController unitPriceController;
  final VoidCallback onAddProduct;

  const ProductDetailsCard({
    super.key,
    required this.itemNameController,
    required this.quantityController,
    required this.unitPriceController,
    required this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title row — icon + "Product Details"
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/productdetails.svg',
              width: 20.r,
              height: 20.r,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryColor,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 8.w),
            CustomText(
              text: 'Product Details',
              fontsize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
          ],
        ),

        SizedBox(height: 12.h),

        // Card container
        Container(
          width: 345.w,
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: const Color(0x4D1E293B), // 30%
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFF3A3A3A)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item Name label
              _Label(text: 'Item Name'),
              SizedBox(height: 6.h),

              // Item Name field — full width, search icon right
              _ItemNameField(controller: itemNameController),

              SizedBox(height: 20.h),

              // Quantity + Unit Price row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Label(text: 'Quantity'),
                        SizedBox(height: 6.h),
                        _HalfInputField(
                          controller: quantityController,
                          hintText: '0',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Label(text: 'Unit Price (\$)'),
                        SizedBox(height: 6.h),
                        _HalfInputField(
                          controller: unitPriceController,
                          hintText: '0.00',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // Add Product button — teal bg, full width
              GestureDetector(
                onTap: onAddProduct,
                child: Container(
                  width: double.infinity,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D3D3D),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.primaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/add.svg',
                        width: 16.r,
                        height: 16.r,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      CustomText(
                        text: 'Add Product',
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ItemNameField extends StatelessWidget {
  final TextEditingController controller;

  const _ItemNameField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1B),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13.sp,
                color: AppColors.primaryTextColor,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. Organic Chia Seeds',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.sp,
                  color: AppColors.secondaryTextColor,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          SvgPicture.asset(
            'assets/icons/search.svg',
            width: 18.r,
            height: 18.r,
            colorFilter: const ColorFilter.mode(
              AppColors.secondaryTextColor,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}

class _HalfInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const _HalfInputField({
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1B),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14.sp,
          color: AppColors.primaryTextColor,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14.sp,
            color: AppColors.secondaryTextColor,
          ),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
}

                                                                                                                                                                                                                                                          class AddedItemsSection extends StatelessWidget {
  final List<AddedProduct> items;
  final Function(int) onRemove;

  const AddedItemsSection({
    super.key,
    required this.items,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Added Items (2)" title
        CustomText(
          text: 'Added Items (${items.length})',
          fontsize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryColor,
          textAlign: TextAlign.start,
        ),

        SizedBox(height: 12.h),

        // Item rows
        ...items.asMap().entries.map((e) => Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: _AddedItemRow(
            item: e.value,
            onRemove: () => onRemove(e.key),
          ),
        )),
      ],
    );
  }
}

class _AddedItemRow extends StatelessWidget {
  final AddedProduct item;
  final VoidCallback onRemove;

  const _AddedItemRow({required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 74.h,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0x0D00C5DA), // 5%
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Row(
        children: [
          // Icon box — teal bg 10%
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: const Color(0x1A1AC8DB),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                item.iconPath,
                width: 20.r,
                height: 20.r,
                colorFilter: const ColorFilter.mode(
                  AppColors.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: item.name,
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 2.h),
                CustomText(
                  text: item.detail,
                  fontsize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),

          // Price + Remove
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: '\$${item.price.toStringAsFixed(2)}',
                fontsize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.end,
              ),
              SizedBox(height: 2.h),
              GestureDetector(
                onTap: onRemove,
                child: CustomText(
                  text: 'Remove',
                  fontsize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFFF2828),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TotalEstCostRow extends StatelessWidget {
  final double total;

  const TotalEstCostRow({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: 'Total Est. Cost',
          fontsize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        CustomText(
          text: '\$${total.toStringAsFixed(2)}',
          fontsize: 16.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryColor,
          textAlign: TextAlign.end,
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: text,
      fontsize: 12.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.secondaryTextColor,
      textAlign: TextAlign.start,
    );
  }
}