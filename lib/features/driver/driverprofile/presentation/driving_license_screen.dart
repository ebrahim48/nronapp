import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nron_app/features/driver/driverprofile/presentation/widgets/doc_upload_box.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../controller/driving_license_controller.dart';


class DrivingLicenseScreen extends StatefulWidget {
  final VoidCallback? onSubmitted;

  const DrivingLicenseScreen({super.key, this.onSubmitted});

  @override
  State<DrivingLicenseScreen> createState() =>
      _DrivingLicenseScreenState();
}

class _DrivingLicenseScreenState extends State<DrivingLicenseScreen> {
  final _ctrl = DrivingLicenseController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          text: 'Driving License',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
      ),
      body: ListenableBuilder(
        listenable: _ctrl,
        builder: (context, _) {
          return SafeArea(
            child: Form(
              key: _ctrl.formKey,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                        24.w, 40.h, 24.w, 110.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        CustomText(
                          text: 'Driving License',
                          fontsize: 22.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(height: 28.h),

                        CustomTextField(
                          controller: _ctrl.licenseController,
                          labelText: 'Driving License No',
                          hintText: 'Enter Driving License number',
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(height: 8.h),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            text:
                            'Upload Your Driving License picture (Front)',
                            fontsize: 12.sp,
                            color: AppColors.secondaryTextColor,
                            textAlign: TextAlign.start,
                            bottom: 10.h,
                          ),
                        ),
                        DocUploadBox(
                          imagePath: _ctrl.frontImagePath,
                          onTap: _ctrl.setFrontImage,
                        ),
                        SizedBox(height: 20.h),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            text:
                            'Upload Your Driving License picture (Back)',
                            fontsize: 12.sp,
                            color: AppColors.secondaryTextColor,
                            textAlign: TextAlign.start,
                            bottom: 10.h,
                          ),
                        ),
                        DocUploadBox(
                          imagePath: _ctrl.backImagePath,
                          onTap: _ctrl.setBackImage,
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: AppColors.backgroundColor,
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 12.h),
                      child: CustomButton(
                        title: 'Submit',
                        loading: _ctrl.isLoading,
                        onpress: () async {
                          final ok = await _ctrl.submit();
                          if (ok && context.mounted) {
                            widget.onSubmitted?.call();
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}