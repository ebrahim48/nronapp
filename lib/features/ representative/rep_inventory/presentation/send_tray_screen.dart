import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/send_tray_widgets.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/send_tray_controller.dart';


class SendTrayScreen extends StatefulWidget {
  final String trayId;
  const SendTrayScreen({super.key, required this.trayId});

  @override
  State<SendTrayScreen> createState() => _SendTrayScreenState();
}

class _SendTrayScreenState extends State<SendTrayScreen> {
  late final SendTrayController c;

  @override
  void initState() {
    super.initState();
    c = Get.put(SendTrayController())..trayId = widget.trayId;
  }

  @override
  void dispose() {
    // Children unmount before their parent, so the fields holding this
    // controller's TextEditingControllers are already gone by now. Deleting
    // it from a button handler instead threw "A TextEditingController was
    // used after being disposed".
    Get.delete<SendTrayController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: SizedBox(
                  height: 52.h,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: EdgeInsets.all(8.r),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.primaryTextColor,
                            size: 18.r,
                          ),
                        ),
                      ),
                      CustomText(
                        text: 'Send Tray',
                        fontsize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Body content
            SliverPadding(
              padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  CustomText(
                    text: 'Tray Details',
                    fontsize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text:
                        'Please fill in the information below to initiate the tray transfer.',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                    textHeight: 1.4,
                  ),

                  SizedBox(height: 24.h),

                  const SendTrayLabel(text: 'Facility / Location'),
                  SendTrayFacilityField(
                    controller: c.facilityController,
                    hintText: 'Search Facility (e.g., City Hospital)',
                  ),

                  SizedBox(height: 16.h),

                  const SendTrayLabel(text: 'System Type'),
                  Obx(() => SendTraySystemType(
                        activeIndex: c.systemTypeIndex.value,
                        onSelect: c.selectSystemType,
                      )),

                  SizedBox(height: 16.h),

                  const SendTrayLabel(text: 'Recipient Name'),
                  SendTrayIconField(
                    controller: c.recipientNameController,
                    hintText: 'Search Surgeon (e.g., Dr. Lee)',
                    iconPath: 'assets/icons/surgeon.svg',
                  ),

                  SizedBox(height: 16.h),

                  const SendTrayLabel(text: 'Recipient Email'),
                  SendTrayIconField(
                    controller: c.recipientEmailController,
                    hintText: 'Enter recipient email',
                    iconPath: 'assets/icons/mail.svg',
                    keyboardType: TextInputType.emailAddress,
                  ),

                  SizedBox(height: 16.h),

                  const SendTrayLabel(text: 'Initial Tray Photo'),
                  Obx(() => SendTrayPhotoSection(
                        selectedPhoto: c.selectedPhoto.value,
                        onAddPhoto: () {},
                      )),

                  SizedBox(height: 16.h),

                  const SendTrayLabel(text: 'Additional Notes'),
                  SendTrayIconField(
                    controller: c.additionalNotesController,
                    hintText:
                        'Add any specific case details or instructions...',
                    iconPath: '',
                    maxLines: 5,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomText(
                      text: 'Write at least 80 characters.',
                      fontsize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.end,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Button scrolls with content
                  Padding(
                    padding: EdgeInsets.only(bottom: 50.h),
                    child: Obx(() => CustomButton(
                      title: 'Send Tray',
                      loading: c.isSending.value,
                      onpress: () async {
                        final ok = await c.sendTray();
                        if (ok && context.mounted) {
                                Navigator.pop(context);
                        }
                      },
                      prefixIcon: SvgPicture.asset(
                        'assets/icons/next.svg',
                        width: 18.r,
                        height: 18.r,
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                    )),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}