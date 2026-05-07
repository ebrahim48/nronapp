import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../../shipment/controller/create_shipment_controller.dart';
import '../model/implant_model.dart';
import 'widgets/active_implant_banner.dart';

class CreateShipmentFromImplantScreen extends StatefulWidget {
  final ImplantModel implant;
  const CreateShipmentFromImplantScreen({super.key, required this.implant});

  @override
  State<CreateShipmentFromImplantScreen> createState() =>
      _CreateShipmentFromImplantScreenState();
}

class _CreateShipmentFromImplantScreenState
    extends State<CreateShipmentFromImplantScreen> {
  late final CreateShipmentController _ctrl;
  final _imagePicker = ImagePicker();
  final _sendCourier = false.obs;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(CreateShipmentController());
    // Pre-populate the implant as a selected product
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrl.selectedProducts.assignAll([
        {
          'product': widget.implant.id,
          'productType': 'Implant',
        }
      ]);
      // Pre-fill company/job name from implant data
      if (_ctrl.companyController.text.isEmpty) {
        _ctrl.jobNameController.text = widget.implant.name.isNotEmpty
            ? widget.implant.name
            : widget.implant.systemType;
      }
    });
  }

  @override
  void dispose() {
    Get.delete<CreateShipmentController>(force: true);
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController ctrl) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.dark(
            primary: AppColors.primaryColor,
            onPrimary: Colors.white,
            surface: const Color(0xFF252525),
            onSurface: Colors.white,
          ),
          dialogTheme:
              const DialogThemeData(backgroundColor: Color(0xFF1E2427)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      ctrl.text = DateFormat('MM/dd/yyyy').format(picked);
    }
  }

  Future<void> _showUploadOptions() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF252525),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFF555555),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            _sheetOption(
              icon: Icons.photo_camera_outlined,
              label: 'Take Photo',
              onTap: () async {
                Navigator.pop(context);
                final xf = await _imagePicker.pickImage(
                    source: ImageSource.camera, imageQuality: 85);
                if (xf != null) _ctrl.addFile(File(xf.path));
              },
            ),
            _sheetOption(
              icon: Icons.photo_library_outlined,
              label: 'Choose from Gallery',
              onTap: () async {
                Navigator.pop(context);
                final xf = await _imagePicker.pickImage(
                    source: ImageSource.gallery, imageQuality: 85);
                if (xf != null) _ctrl.addFile(File(xf.path));
              },
            ),
            _sheetOption(
              icon: Icons.picture_as_pdf_outlined,
              label: 'Upload PDF',
              onTap: () async {
                Navigator.pop(context);
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf'],
                );
                if (result != null && result.files.single.path != null) {
                  _ctrl.addFile(File(result.files.single.path!));
                }
              },
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget _sheetOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor, size: 22.r),
      title: CustomText(
        text: label,
        fontsize: 14.sp,
        color: AppColors.primaryTextColor,
        textAlign: TextAlign.start,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSection({
    required Widget header,
    required List<Widget> children,
  }) {
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

  Widget _sectionHeader(String title, String iconAsset) {
    return Row(
      children: [
        SvgPicture.asset(
          iconAsset,
          width: 18.r,
          height: 18.r,
          colorFilter:
              ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
        ),
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
    required RxString value,
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
          Obx(() => Container(
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
                    value: value.value,
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
              )),
        ],
      ),
    );
  }

  Widget _fileChip(File f, int idx) {
    final isPdf = f.path.toLowerCase().endsWith('.pdf');
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2427),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
            color: AppColors.dotButtonInactiveColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          if (!isPdf)
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: Image.file(f,
                  width: 40.r, height: 40.r, fit: BoxFit.cover),
            )
          else
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: const Color(0xFF252525),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(Icons.picture_as_pdf,
                  color: Colors.redAccent, size: 22.r),
            ),
          SizedBox(width: 10.w),
          Expanded(
            child: CustomText(
              text: f.path.split('/').last.split('\\').last,
              fontsize: 11.sp,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
          ),
          GestureDetector(
            onTap: () => _ctrl.removeFile(idx),
            child: Icon(Icons.close,
                color: AppColors.secondaryTextColor, size: 16.r),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Active implant banner ──
                ActiveImplantBanner(
                  serialNumber: widget.implant.serialNumber,
                  implantName: widget.implant.name.isNotEmpty
                      ? widget.implant.name
                      : widget.implant.systemType,
                  imageAsset: widget.implant.imageAsset,
                ),
                SizedBox(height: 14.h),

                // ── Shipment Info ──
                _buildSection(
                  header: _sectionHeader(
                      'Shipment Information', 'assets/icons/infocircle.svg'),
                  children: [
                    CustomTextField(
                      controller: _ctrl.companyController,
                      labelText: 'Company',
                      hintText: 'Courier',
                    ),
                    CustomTextField(
                      controller: _ctrl.recipientController,
                      labelText: 'Recipient',
                      hintText: 'e.g., Dr. Lee',
                      prefixIcon: Icon(
                        Icons.person_outline,
                        size: 16.r,
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                  ],
                ),

                // ── Logistics - Pickup ──
                _buildSection(
                  header: _sectionHeader(
                      'Logistics - Pickup', 'assets/icons/logisticspickup.svg'),
                  children: [
                    CustomTextField(
                      controller: _ctrl.pickupAddressController,
                      labelText: 'Address',
                      hintText: 'Street, City, Zip',
                    ),
                    CustomTextField(
                      controller: _ctrl.pickupContactController,
                      labelText: 'Contact Person',
                      hintText: 'Physician',
                      prefixIcon: Icon(Icons.person_outline,
                          size: 16.r, color: AppColors.secondaryTextColor),
                    ),
                    CustomTextField(
                      controller: _ctrl.pickupPhoneController,
                      labelText: 'Phone Number',
                      hintText: '01324567899',
                      keyboardType: TextInputType.phone,
                    ),
                    GestureDetector(
                      onTap: () => _pickDate(_ctrl.pickupDateController),
                      child: AbsorbPointer(
                        child: CustomTextField(
                          controller: _ctrl.pickupDateController,
                          labelText: 'Pickup Date',
                          hintText: 'mm/dd/yyyy',
                          keyboardType: TextInputType.datetime,
                          suffixIcon: Icon(Icons.calendar_today,
                              size: 16.r,
                              color: AppColors.secondaryTextColor),
                        ),
                      ),
                    ),
                    CustomTextField(
                      controller: _ctrl.pickupInstructionsController,
                      labelText: 'Pickup Instructions',
                      hintText: 'Dock number, contact person, etc.',
                      maxLine: 3,
                    ),
                  ],
                ),

                // ── Logistics - Drop-off ──
                _buildSection(
                  header: _sectionHeader(
                      'Logistics - Drop-off', 'assets/icons/location.svg'),
                  children: [
                    CustomTextField(
                      controller: _ctrl.dropoffAddressController,
                      labelText: 'Drop-off Address',
                      hintText: 'Facility address',
                    ),
                    CustomTextField(
                      controller: _ctrl.dropoffContactController,
                      labelText: 'Contact Person',
                      hintText: 'Contact name',
                    ),
                    CustomTextField(
                      controller: _ctrl.dropoffPhoneController,
                      labelText: 'Phone Number',
                      hintText: '01324567899',
                      keyboardType: TextInputType.phone,
                    ),
                    CustomTextField(
                      controller: _ctrl.dropoffInstructionsController,
                      labelText: 'Drop-off Instructions',
                      hintText: 'Floor, department, sterile processing, etc.',
                      maxLine: 3,
                    ),
                  ],
                ),

                // ── Files ──
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
                GestureDetector(
                  onTap: _showUploadOptions,
                  child: Container(
                    width: double.infinity,
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: const Color(0x0DFFFFFF),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                          color: const Color(0xFF4A4A4A), width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined,
                            color: AppColors.secondaryTextColor, size: 24.r),
                        SizedBox(height: 6.h),
                        CustomText(
                          text: 'Upload Your Files',
                          fontsize: 12.sp,
                          color: AppColors.secondaryTextColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(() {
                  if (_ctrl.uploadedFiles.isEmpty) return const SizedBox.shrink();
                  return Column(
                    children: [
                      SizedBox(height: 10.h),
                      ..._ctrl.uploadedFiles.asMap().entries
                          .map((e) => _fileChip(e.value, e.key)),
                    ],
                  );
                }),
                SizedBox(height: 14.h),

                // ── Package Details ──
                _buildSection(
                  header: Row(
                    children: [
                      SvgPicture.asset('assets/icons/packagedetails.svg',
                          width: 18.r, height: 18.r),
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
                            items: CreateShipmentController.serviceTypes,
                            onChanged: _ctrl.setServiceType,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildDropdown(
                            label: 'Package Type',
                            value: _ctrl.selectedPackageType,
                            items: CreateShipmentController.packageTypes,
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
                            text: 'Medical Implants - Temperature\nSensitive',
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

                // ── Send Courier Order toggle ──
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                      Obx(() => Switch(
                            value: _sendCourier.value,
                            onChanged: (v) => _sendCourier.value = v,
                            activeColor: AppColors.primaryColor,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Sticky submit button ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.backgroundColor,
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Obx(() => CustomButton(
                    loading: _ctrl.isLoading.value,
                    title: 'Create Job',
                    titlecolor: const Color(0xFF1E2121),
                    suffixIcon: SvgPicture.asset(
                      'assets/icons/createjob.svg',
                      width: 18.r,
                      height: 18.r,
                      colorFilter: const ColorFilter.mode(
                          Color(0xFF1E2121), BlendMode.srcIn),
                    ),
                    onpress: () async {
                      final ok = await _ctrl.createJob();
                      if (ok && context.mounted) Navigator.pop(context);
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
