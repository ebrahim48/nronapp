import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nron_app/features/driver/driverprofile/presentation/widgets/doc_upload_box.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/car_pictures_controller.dart';


class CarPicturesScreen extends StatefulWidget {
  final VoidCallback? onSubmitted;

  const CarPicturesScreen({super.key, this.onSubmitted});

  @override
  State<CarPicturesScreen> createState() => _CarPicturesScreenState();
}

class _CarPicturesScreenState extends State<CarPicturesScreen> {
  final _ctrl = CarPicturesController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: ListenableBuilder(
        listenable: _ctrl,
        builder: (context, _) {
          return SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                      24.w, 40.h, 24.w, 110.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        text: 'Upload your Car plate\npicture',
                        fontsize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                        textHeight: 1.4,
                      ),
                      SizedBox(height: 10.h),
                      CustomText(
                        text: 'Upload your Car number plate picture',
                        fontsize: 12.sp,
                        color: AppColors.secondaryTextColor,
                        bottom: 14.h,
                      ),
                      DocUploadBox(
                        imagePath: _ctrl.carPlatePath,
                        onTap: () =>
                            _ctrl.setCarPlate('plate_placeholder'),
                        height: 140.h,
                      ),
                      SizedBox(height: 30.h),

                      CustomText(
                        text: 'Upload your Car picture',
                        fontsize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                      ),
                      SizedBox(height: 10.h),
                      CustomText(
                        text: 'Upload your Car picture',
                        fontsize: 12.sp,
                        color: AppColors.secondaryTextColor,
                        bottom: 14.h,
                      ),
                      DocUploadBox(
                        imagePath: _ctrl.carPicturePath,
                        onTap: () => _ctrl
                            .setCarPicture('car_placeholder'),
                        height: 140.h,
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
          );
        },
      ),
    );
  }
}