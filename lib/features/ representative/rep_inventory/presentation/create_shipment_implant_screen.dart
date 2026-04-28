import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/active_implant_banner.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/dotted_upload_box.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../../shipment/controller/create_shipment_controller.dart';
import '../model/implant_model.dart';


class CreateShipmentFromImplantScreen extends StatefulWidget {
  final ImplantModel implant;
  const CreateShipmentFromImplantScreen({super.key, required this.implant});

  @override
  State<CreateShipmentFromImplantScreen> createState() =>
      _CreateShipmentFromImplantScreenState();
}

class _CreateShipmentFromImplantScreenState
    extends State<CreateShipmentFromImplantScreen> {
  final _ctrl = CreateShipmentController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }


  Widget _buildSection(
      {required Widget header, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [header, SizedBox(height: 12.h), ...children],
      ),
    );
  }

  // ── Section header ────────────────────────────────────────────────────────
  Widget _sectionHeader(String title, String iconAsset) {
    return Row(
      children: [
        SvgPicture.asset(iconAsset,
            width: 18.r,
            height: 18.r,
            colorFilter: ColorFilter.mode(
                AppColors.primaryColor, BlendMode.srcIn)),
        SizedBox(width: 8.w),
        CustomText(
          text: title,
          fontsize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }


  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            fontsize: 12.sp,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
            bottom: 6.h,
            left: 2.w,
          ),
          Container(
            height: 46.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: const Color(0x1A4A4A4A),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                  color: AppColors.dotButtonInactiveColor, width: 0.8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                dropdownColor: const Color(0xFF252525),
                iconEnabledColor: AppColors.secondaryTextColor,
                style: TextStyle(
                  color: AppColors.primaryTextColor,
                  fontSize: 13.sp,
                  fontFamily: 'Poppins',
                ),
                onChanged: (v) => onChanged(v!),
                items: items
                    .map((e) =>
                    DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
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
          child: Icon(Icons.arrow_back_ios_new,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        centerTitle: false,
        title: CustomText(
          text: 'Create Shipment Job',
          fontsize: 17.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: ListenableBuilder(
        listenable: _ctrl,
        builder: (context, _) {
          return Form(
            key: _ctrl.formKey,
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding:
                  EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ActiveImplantBanner(
                        serialNumber: widget.implant.serialNumber,
                        implantName: widget.implant.name,
                        imageAsset: widget.implant.imageAsset,
                      ),
                      SizedBox(height: 14.h),

                      _buildSection(
                        header: _sectionHeader(
                          'Logistics - Pickup',
                          'assets/icons/logisticspickup.svg',
                        ),
                        children: [
                          CustomTextField(
                            controller: _ctrl.pickupAddressController,
                            labelText: 'Address',
                            hintText: 'Street Address',
                          ),
                          CustomTextField(
                            controller: _ctrl.pickupCityController,
                            labelText: 'Street, City, Zip',
                            hintText: 'IL',
                          ),
                          CustomTextField(
                            controller: _ctrl.pickupDateController,
                            labelText: 'Pickup Date/Time',
                            hintText: 'mm/dd/yyyy',
                            keyboardType: TextInputType.datetime,
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              size: 16.r,
                              color: AppColors.secondaryTextColor,
                            ),
                          ),
                          CustomTextField(
                            controller: _ctrl.pickupInstructionsController,
                            labelText: 'Pickup Instructions',
                            hintText:
                            'Dock number, contact person, etc.',
                            maxLine: 3,
                          ),
                        ],
                      ),

                      _buildSection(
                        header: _sectionHeader(
                          'Logistics - Drop-off',
                          'assets/icons/location.svg',
                        ),
                        children: [
                          CustomTextField(
                            controller: _ctrl.dropoffAddressController,
                            labelText: 'Drop-off Address',
                            hintText: 'Facility address',
                          ),
                          CustomTextField(
                            controller: _ctrl.dropoffInstructionsController,
                            labelText: 'Drop-off Instructions',
                            hintText:
                            'Floor, department, sterile processing, etc.',
                            maxLine: 3,
                          ),
                        ],
                      ),


                      Padding(
                        padding: EdgeInsets.only(bottom: 6.h),
                        child: Row(
                          children: [
                            CustomText(
                              text: 'Files',
                              fontsize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryTextColor,
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(width: 6.w),
                            CustomText(
                              text: 'image/pdf',
                              fontsize: 11.sp,
                              color: AppColors.secondaryTextColor,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      DottedUploadBox(
                        label: 'Upload Your Files',
                        subtitle: '',
                        onTap: () {},
                        height: 80.h,
                      ),
                      SizedBox(height: 14.h),

                      // ── Package Details ────────────────────────────────
                      _buildSection(
                        header: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/packagedetails.svg',
                              width: 18.r,
                              height: 18.r,
                            ),
                            SizedBox(width: 8.w),
                            CustomText(
                              text: 'Package Details',
                              fontsize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryTextColor,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildDropdown(
                                  label: 'Services Type',
                                  value: _ctrl.selectedServiceType,
                                  items: _ctrl.serviceTypes,
                                  onChanged: _ctrl.setServiceType,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _buildDropdown(
                                  label: 'Package Type',
                                  value: _ctrl.selectedPackageType,
                                  items: _ctrl.packageTypes,
                                  onChanged: _ctrl.setPackageType,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: _ctrl.weightController,
                                  labelText: 'Weight (lbs)',
                                  hintText: '4.5',
                                  keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9.]'))
                                  ],
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: CustomTextField(
                                  controller: _ctrl.dimensionsController,
                                  labelText: 'Dimensions (L*W*H)',
                                  hintText: '12*10*6',
                                ),
                              ),
                            ],
                          ),
                          // Medical implant badge
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E2427),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/medicalimplants.svg',
                                  width: 22.r,
                                  height: 22.r,
                                ),
                                SizedBox(width: 10.w),
                                CustomText(
                                  text:
                                  'Medical Implants - Temperature\nSensitive',
                                  fontsize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryTextColor,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 14.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF252525),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: 'Send Courier Order?',
                                    fontsize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryTextColor,
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(height: 2.h),
                                  CustomText(
                                    text:
                                    'Instantly notify preferred courier network',
                                    fontsize: 11.sp,
                                    color: AppColors.secondaryTextColor,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _ctrl.sendCourierOrder,
                              onChanged: _ctrl.toggleSendCourier,
                              activeColor: AppColors.primaryColor,
                            ),
                          ],
                        ),
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
                        horizontal: 16.w, vertical: 12.h),
                    child: CustomButton(
                      title: 'Create Job',
                      suffixIcon: Icon(Icons.arrow_forward,
                          color: AppColors.primaryTextColor, size: 18.r),
                      onpress: () {
                        if (_ctrl.createJob()) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                              const Text('Shipment job created!'),
                              backgroundColor: AppColors.primaryColor,
                            ),
                          );
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