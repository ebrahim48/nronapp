import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/%20representative/expenses/presentation/widgets/attachment_section.dart';
import 'package:nron_app/features/%20representative/expenses/presentation/widgets/dark_dropdown_filed.dart';
import 'package:nron_app/features/%20representative/expenses/presentation/widgets/form_section_header.dart';
import 'package:nron_app/features/%20representative/expenses/presentation/widgets/paidtoggle.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../controller/expense_controller.dart';

class CreateExpenseScreen extends StatefulWidget {
  final String? expenseId;
  const CreateExpenseScreen({super.key, this.expenseId});

  @override
  State<CreateExpenseScreen> createState() => _CreateExpenseScreenState();
}

class _CreateExpenseScreenState extends State<CreateExpenseScreen> {
  late final ExpenseController c;

  @override
  void initState() {
    super.initState();
    c = Get.isRegistered<ExpenseController>()
        ? Get.find<ExpenseController>()
        : Get.put(ExpenseController());
    c.fetchRepresentatives();
    c.fetchPhysiciansForDropdown();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.expenseId != null;

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
          text: isEdit ? 'Edit Expense' : 'Create Expense',
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

            _FieldLabel(text: 'Representative'),
            Obx(() {
              if (c.isLoadingRepresentatives.value) return _ShimmerDropdown();
              final ids = c.representatives.map((r) => r.id).toList();
              final names = c.representatives.map((r) => r.fullName).toList();
              final safeVal = ids.contains(c.selectedRepresentativeId.value)
                  ? c.selectedRepresentativeId.value
                  : null;
              return DarkDropdown(
                label: '',
                hint: 'Select Representative',
                value: safeVal,
                items: names,
                values: ids,
                onChanged: (id) {
                  if (id != null) {
                    final rep =
                        c.representatives.firstWhereOrNull((r) => r.id == id);
                    if (rep != null) c.selectRepresentative(rep.id, rep.fullName);
                  }
                },
              );
            }),

            _FieldLabel(text: 'Physician'),
            Obx(() {
              if (c.isLoadingPhysicians.value) return _ShimmerDropdown();
              final ids = c.physicianList.map((p) => p.id).toList();
              final names = c.physicianList.map((p) => p.fullName).toList();
              final safeVal = ids.contains(c.selectedPhysicianId.value)
                  ? c.selectedPhysicianId.value
                  : null;
              return DarkDropdown(
                label: '',
                hint: 'Select Physician',
                value: safeVal,
                items: names,
                values: ids,
                onChanged: (id) {
                  if (id != null) {
                    final ph =
                        c.physicianList.firstWhereOrNull((p) => p.id == id);
                    if (ph != null) c.selectPhysician(ph.id, ph.fullName);
                  }
                },
              );
            }),

            _FieldLabel(text: 'Category'),
            Obx(() {
              final safeVal = c.categories.contains(c.selectedCategory.value)
                  ? c.selectedCategory.value
                  : null;
              return DarkDropdown(
                label: '',
                hint: 'Select Category',
                value: safeVal,
                items: c.categories,
                onChanged: (v) => c.selectedCategory.value = v ?? '',
              );
            }),

            SizedBox(height: 6.h),

            const FormSectionHeader(title: 'Date & Accounting Period'),

            _FieldLabel(text: 'Expense Date'),
            CustomTextField(
              controller: c.expenseDateController,
              hintText: 'mm/dd/yyyy',
              readOnly: true,
              onTap: () => c.pickDate(context),
              suffixIcon: Icon(Icons.calendar_today_outlined,
                  color: AppColors.secondaryTextColor, size: 18.r),
            ),

            _FieldLabel(text: 'Accounting Period'),
            CustomTextField(
              controller: c.periodController,
              hintText: 'Month Year',
              readOnly: true,
              onTap: () => c.pickMonthYear(context),
              suffixIcon: Icon(Icons.calendar_month_outlined,
                  color: AppColors.secondaryTextColor, size: 18.r),
            ),

            SizedBox(height: 6.h),

            const FormSectionHeader(title: 'Financials'),

            _FieldLabel(text: 'Amount'),
            CustomTextField(
              controller: c.amountController,
              hintText: '\$ 0.00',
              keyboardType: TextInputType.number,
            ),

            const PaidToggle(),

            SizedBox(height: 6.h),

            const FormSectionHeader(title: 'Description'),

            _FieldLabel(text: 'Description'),
            CustomTextField(
              controller: c.descriptionController,
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

            Obx(() => CustomButton(
                  title: isEdit ? 'Update Expense' : 'Submit Expense',
                  loading: c.isSubmitting.value,
                  titlecolor: AppColors.blackColor,
                  fontWeight: FontWeight.w700,
                  onpress: () async {
                    final ok = await c.submitExpense(
                      context,
                      expenseId: widget.expenseId,
                    );
                    if (ok && context.mounted) {
                      if (isEdit) {
                        Navigator.pop(context);
                      } else {
                        context.pushNamed(AppRoutes.expenseSuccessScreen);
                      }
                    }
                  },
                )),

            SizedBox(height: 12.h),

            CustomButton(
              title: 'Cancel',
              onpress: () => Navigator.pop(context),
              color: Colors.transparent,
              borderColor: const Color(0xFF3A3A3A),
              titlecolor: AppColors.secondaryTextColor,
              fontWeight: FontWeight.w500,
            ),

            if (isEdit) ...[
              SizedBox(height: 10.h),
              Obx(() => CustomButton(
                    title: 'Delete Expense',
                    loading: c.isDeleting.value,
                    color: Colors.transparent,
                    borderColor: AppColors.redColorFF1D1D,
                    titlecolor: AppColors.redColorFF1D1D,
                    fontWeight: FontWeight.w500,
                    onpress: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: const Color(0xFF1E2427),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          title: Text(
                            'Delete Expense',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                          content: Text(
                            'Are you sure you want to delete this expense? This action cannot be undone.',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontFamily: 'Poppins',
                              color: AppColors.secondaryTextColor,
                              height: 1.5,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: 'Poppins',
                                  color: AppColors.secondaryTextColor,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.redColorFF1D1D,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true && context.mounted) {
                        final ok =
                            await c.deleteExpense(widget.expenseId!);
                        if (ok && context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                  )),
            ],

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

class _ShimmerDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: Container(
        height: 48.h,
        margin: EdgeInsets.only(bottom: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
