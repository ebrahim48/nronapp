import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../controller/create_shipment_controller.dart';


class CreateShipmentJobScreen extends StatefulWidget {
  const CreateShipmentJobScreen({super.key});

  @override
  State<CreateShipmentJobScreen> createState() =>
      _CreateShipmentJobScreenState();
}

class _CreateShipmentJobScreenState extends State<CreateShipmentJobScreen> {
  final _ctrl = CreateShipmentController();
  final _imagePicker = ImagePicker();

  // Uploaded files: maps file path → isPdf
  final List<_UploadedFile> _uploadedFiles = [];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ── Date picker ──────────────────────────────────────────────────────────────
  Future<void> _pickDate(TextEditingController controller) async {
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
          dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF1E2427)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      controller.text = DateFormat('MM/dd/yyyy').format(picked);
    }
  }

  // ── File upload ──────────────────────────────────────────────────────────────
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
                if (xf != null) _addFile(xf.path, isPdf: false);
              },
            ),
            _sheetOption(
              icon: Icons.photo_library_outlined,
              label: 'Choose from Gallery',
              onTap: () async {
                Navigator.pop(context);
                final xf = await _imagePicker.pickImage(
                    source: ImageSource.gallery, imageQuality: 85);
                if (xf != null) _addFile(xf.path, isPdf: false);
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
                  _addFile(result.files.single.path!, isPdf: true);
                }
              },
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  void _addFile(String path, {required bool isPdf}) {
    setState(() {
      _uploadedFiles.add(_UploadedFile(path: path, isPdf: isPdf));
    });
  }

  void _removeFile(int index) {
    setState(() => _uploadedFiles.removeAt(index));
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

  // ── Custom Toggle ────────────────────────────────────────────────────────────
  Widget _customToggle(bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44.w,
        height: 24.h,
        decoration: BoxDecoration(
          color: value ? const Color(0xFF00C5DA) : const Color(0xFF555555),
          borderRadius: BorderRadius.circular(9999),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Container(
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2121),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF1E2121), width: 1),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Dropdown ─────────────────────────────────────────────────────────────────
  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
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
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }

  // ── Section header ───────────────────────────────────────────────────────────
  Widget _sectionHeader(String title, String iconAsset) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        children: [
          SvgPicture.asset(iconAsset, width: 18.r, height: 18.r),
          SizedBox(width: 8.w),
          CustomText(
            text: title,
            fontsize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
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
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Shipment Information ─────────────────────────────────
                      _buildSection(
                        header: _sectionHeader(
                            'Shipment Information',
                            'assets/icons/infocircle.svg'),
                        children: [
                          CustomTextField(
                            controller: _ctrl.companyController,
                            labelText: 'Company',
                            hintText: 'Enter company name',
                          ),
                          CustomTextField(
                            controller: _ctrl.jobNameController,
                            labelText: 'Job Name',
                            hintText: 'e.g. INV-2023-001',
                          ),
                          CustomTextField(
                            controller: _ctrl.recipientNameController,
                            labelText: 'Recipient Name',
                            hintText: 'Full Name',
                          ),
                        ],
                      ),

                      // ── Logistics – Pickup ───────────────────────────────────
                      _buildSection(
                        header: _sectionHeader(
                            'Logistics - Pickup',
                            'assets/icons/logisticspickup.svg'),
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
                          // Calendar date picker
                          GestureDetector(
                            onTap: () => _pickDate(_ctrl.pickupDateController),
                            child: AbsorbPointer(
                              child: CustomTextField(
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

                      // ── Logistics – Drop-off ─────────────────────────────────
                      _buildSection(
                        header: _sectionHeader(
                            'Logistics - Drop-off',
                            'assets/icons/location.svg'),
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

                      // ── Files ────────────────────────────────────────────────
                      _buildSection(
                        header: Padding(
                          padding: EdgeInsets.only(bottom: 14.h),
                          child: Row(
                            children: [
                              CustomText(
                                text: 'Files',
                                fontsize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTextColor,
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(width: 6.w),
                              CustomText(
                                text: 'image / pdf',
                                fontsize: 11.sp,
                                color: AppColors.secondaryTextColor,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                        children: [
                          // Dotted upload area
                          GestureDetector(
                            onTap: _showUploadOptions,
                            child: CustomPaint(
                              painter: _DashedBorderPainter(
                                color: AppColors.dotButtonInactiveColor
                                    .withValues(alpha: 0.6),
                                borderRadius: 8.r,
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.cloud_upload_outlined,
                                        color: AppColors.primaryColor,
                                        size: 28.r),
                                    SizedBox(height: 6.h),
                                    CustomText(
                                      text: 'Tap to upload image or PDF',
                                      fontsize: 12.sp,
                                      color: AppColors.secondaryTextColor,
                                    ),
                                    SizedBox(height: 2.h),
                                    CustomText(
                                      text: 'JPG, PNG, PDF supported',
                                      fontsize: 10.sp,
                                      color: AppColors.secondaryTextColor
                                          .withValues(alpha: 0.6),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Uploaded file list
                          if (_uploadedFiles.isNotEmpty) ...[
                            SizedBox(height: 12.h),
                            ..._uploadedFiles.asMap().entries.map((e) {
                              final idx = e.key;
                              final f = e.value;
                              return _fileChip(f, idx);
                            }),
                          ],
                        ],
                      ),

                      // ── Package Details ──────────────────────────────────────
                      _buildSection(
                        header: _sectionHeader(
                            'Package Details',
                            'assets/icons/packagedetails.svg'),
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

                      // ── Send Courier Order toggle ─────────────────────────────
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
                            _customToggle(
                              _ctrl.sendCourierOrder,
                              _ctrl.toggleSendCourier,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Sticky Create Job button ─────────────────────────────────
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: AppColors.backgroundColor,
                    padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: CustomButton(
                      title: 'Create Job',
                      titlecolor: const Color(0xFF1E2121),
                      suffixIcon: SvgPicture.asset(
                        'assets/icons/createjob.svg',
                        width: 18.r,
                        height: 18.r,
                        colorFilter: const ColorFilter.mode(
                            Color(0xFF1E2121), BlendMode.srcIn),
                      ),
                      onpress: () {
                        if (_ctrl.createJob()) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Job created successfully!'),
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

  Widget _fileChip(_UploadedFile f, int idx) {
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
          if (!f.isPdf)
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: Image.file(
                File(f.path),
                width: 40.r,
                height: 40.r,
                fit: BoxFit.cover,
              ),
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
            onTap: () => _removeFile(idx),
            child: Icon(Icons.close,
                color: AppColors.secondaryTextColor, size: 16.r),
          ),
        ],
      ),
    );
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
        children: [header, ...children],
      ),
    );
  }
}

// ── Uploaded file model ──────────────────────────────────────────────────────
class _UploadedFile {
  final String path;
  final bool isPdf;
  const _UploadedFile({required this.path, required this.isPdf});
}

// ── Dashed border painter ────────────────────────────────────────────────────
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;

  const _DashedBorderPainter({required this.color, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const dashWidth = 6.0;
    const dashSpace = 4.0;

    final rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rRect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0, metric.length);
        canvas.drawPath(
          metric.extractPath(distance, end.toDouble()),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) =>
      old.color != color || old.borderRadius != borderRadius;
}
