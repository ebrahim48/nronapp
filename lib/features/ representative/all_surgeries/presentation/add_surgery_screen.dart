import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/%20representative/all_surgeries/presentation/widgets/document_upload_widget.dart';
import 'package:nron_app/features/%20representative/all_surgeries/presentation/widgets/physician_dropdown.dart';
import 'package:nron_app/features/%20representative/all_surgeries/presentation/widgets/radiology_image_grid.dart';
import 'package:nron_app/features/%20representative/all_surgeries/presentation/widgets/surgery_material_field.dart';
import 'package:nron_app/features/%20representative/all_surgeries/presentation/widgets/surgery_section_header.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../controller/surgery_controller.dart';

class AddSurgeryScreen extends StatelessWidget {
  final String? surgeryId;
  const AddSurgeryScreen({super.key, this.surgeryId});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SurgeryController>();
    final isEdit = surgeryId != null;

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
        title: CustomText(
          text: isEdit ? 'Edit Surgery' : 'Add Surgery',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SurgerySectionHeader(title: 'Surgery Info'),

            const PhysicianDropdown(),

            CustomTextField(
              controller: c.patientIdController,
              labelText: 'Patient identifier (PT ID)',
              hintText: 'Enter patient ID',
            ),

            CustomTextField(
              controller: c.facilityIdController,
              labelText: 'Facility',
              hintText: 'Enter facility ID',
            ),

            Obx(() => GestureDetector(
              onTap: () => c.pickDate(context),
              child: AbsorbPointer(
                child: CustomTextField(
                  controller: TextEditingController(
                      text: c.dateOfSurgery.value),
                  labelText: 'Date of Surgery',
                  hintText: 'mm/dd/yyyy',
                  readOnly: true,
                  suffixIcon: Icon(Icons.calendar_today_outlined,
                      color: AppColors.secondaryTextColor, size: 18.r),
                ),
              ),
            )),

            CustomTextField(
              controller: c.surgeryTypeController,
              labelText: 'Surgery Type',
              hintText: 'Specific procedure name',
            ),

            SizedBox(height: 6.h),

            const SurgerySectionHeader(title: 'Surgery Materials'),

            SurgeryMaterialField(
              label: 'Screws',
              hint: 'Pedicle Screw 6.5mm x 45mm QTY (4)',
              controller: c.screwsController,
            ),

            SurgeryMaterialField(
              label: 'Plates',
              hint: 'Details...',
              controller: c.platesController,
            ),

            SurgeryMaterialField(
              label: 'Rods/Connectors',
              hint: 'Details...',
              controller: c.rodsController,
            ),

            SurgeryMaterialField(
              label: 'Implants',
              hint: 'Details...',
              controller: c.implantsController,
            ),

            SurgeryMaterialField(
              label: 'Biologics',
              hint: 'Details...',
              controller: c.biologicsController,
            ),

            SizedBox(height: 6.h),

            const SurgerySectionHeader(title: 'Radiology & Clinical Images'),

            const RadiologyImageGrid(),

            SizedBox(height: 20.h),

            const SurgerySectionHeader(title: 'Documents & Notes'),

            const DocumentUploadWidget(),

            SizedBox(height: 14.h),

            CustomTextField(
              controller: c.caseNotesController,
              labelText: 'Case Notes',
              hintText:
              'Enter surgical notes, complications, or specific instructions...',
              maxLine: 4,
            ),

            Align(
              alignment: Alignment.centerRight,
              child: CustomText(
                text: 'Write at least 80 characters.',
                fontsize: 10.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
            ),

            SizedBox(height: 24.h),

            Obx(() => c.isSubmitting.value
                ? Center(
                    child: SpinKitThreeBounce(
                      color: AppColors.primaryColor,
                      size: 28.r,
                    ),
                  )
                : CustomButton(
                    title: isEdit ? 'Update Surgery' : 'Save Surgery',
                    onpress: () => c.submitSurgery(context, surgeryId: surgeryId),
                    titlecolor: AppColors.blackColor,
                    fontWeight: FontWeight.w700,
                    suffixIcon: SvgPicture.asset(
                      'assets/icons/createjob.svg',
                      width: 18.r,
                      height: 18.r,
                      colorFilter: const ColorFilter.mode(
                        AppColors.blackColor,
                        BlendMode.srcIn,
                      ),
                    ),
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

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
