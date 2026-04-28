import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/features/%20representative/expenses/presentation/widgets/attachment_section.dart';
import 'package:nron_app/features/%20representative/expenses/presentation/widgets/dark_dropdown_filed.dart';
import 'package:nron_app/features/%20representative/expenses/presentation/widgets/form_section_header.dart';
import 'package:nron_app/features/%20representative/expenses/presentation/widgets/paidtoggle.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../controller/expense_controller.dart';


class CreateExpenseScreen extends StatelessWidget {
  const CreateExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExpenseController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        centerTitle: false,
        title: CustomText(
          text: 'Create Expense',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FormSectionHeader(title: 'Basic Information'),

            _FieldLabel(text: 'Representative Name'),
            CustomTextField(
              controller: controller.representativeNameController,
              hintText: 'Enter name',
              prefixIcon: Icon(
                Icons.person_outline,
                color: AppColors.secondaryTextColor,
                size: 18.r,
              ),
            ),

            _FieldLabel(text: 'Physician'),
            Obx(() => DarkDropdown(
              label: '',
              hint: 'Select Physician',
              value: controller.selectedPhysician.value,
              items: controller.physicians,
              onChanged: (v) =>
                  controller.selectedPhysician.value = v ?? '',
            )),

            _FieldLabel(text: 'Category'),
            Obx(() => DarkDropdown(
              label: '',
              hint: 'Select Category',
              value: controller.selectedCategory.value,
              items: controller.categories,
              onChanged: (v) =>
                  controller.selectedCategory.value = v ?? '',
            )),

            SizedBox(height: 6.h),

            const FormSectionHeader(title: 'Date & Accounting Period'),

            _FieldLabel(text: 'Expense Date'),
            CustomTextField(
              controller: controller.expenseDateController,
              hintText: 'mm/dd/yyyy',
              readOnly: true,
              onTap: () => controller.pickDate(context),
              suffixIcon: Icon(
                Icons.calendar_today_outlined,
                color: AppColors.secondaryTextColor,
                size: 18.r,
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(text: 'Year'),
                      Obx(() => DarkDropdown(
                        label: '',
                        hint: '2026',
                        value: controller.selectedYear.value,
                        items: controller.years,
                        onChanged: (v) =>
                            controller.selectedYear.value = v ?? '2026',
                      )),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(text: 'Month'),
                      Obx(() => DarkDropdown(
                        label: '',
                        hint: 'MARCH',
                        value: controller.selectedMonth.value,
                        items: controller.months,
                        onChanged: (v) =>
                            controller.selectedMonth.value = v ?? 'MARCH',
                      )),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 6.h),

            const FormSectionHeader(title: 'Financials'),

            _FieldLabel(text: 'Amount'),
            CustomTextField(
              controller: controller.amountController,
              hintText: '\$ 0.00',
              keyboardType: TextInputType.number,
            ),

            const PaidToggle(),

            SizedBox(height: 6.h),

            const FormSectionHeader(title: 'Description'),

            _FieldLabel(text: 'Description'),
            CustomTextField(
              controller: controller.descriptionController,
              hintText: 'Business purpose of this expense...',
              maxLine: 4,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: CustomText(
                  text: 'Write at least 80 characters.',
                  fontsize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.end,
                ),
              ),
            ),

            const AttachmentSection(),

            GestureDetector(
              onTap: () {
                controller.submitExpense();
                context.pushNamed(AppRoutes.expenseSuccessScreen);
              },
              child: Container(
                width: double.infinity,
                height: 52.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Submit Expense',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.arrow_forward,
                        color: AppColors.blackColor, size: 18.r),
                  ],
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // Cancel Button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                height: 52.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(
        text: text,
        fontsize: 13.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryTextColor,
        textAlign: TextAlign.start,
      ),
    );
  }
}