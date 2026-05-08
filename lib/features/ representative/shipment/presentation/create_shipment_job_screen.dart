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
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controller/create_shipment_controller.dart';
import 'map_location_picker_screen.dart';
import 'shipment_select_implants_screen.dart';

class CreateShipmentJobScreen extends StatefulWidget {
  const CreateShipmentJobScreen({super.key});

  @override
  State<CreateShipmentJobScreen> createState() =>
      _CreateShipmentJobScreenState();
}

class _CreateShipmentJobScreenState extends State<CreateShipmentJobScreen> {
  late final CreateShipmentController _ctrl;
  final _imagePicker = ImagePicker();
  int _currentStep = 1;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(CreateShipmentController());
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

  Future<void> _openMapPicker({required bool isPickup}) async {
    final existing = isPickup
        ? (_ctrl.pickupLat != null
            ? LatLng(_ctrl.pickupLat!, _ctrl.pickupLng!)
            : null)
        : (_ctrl.dropoffLat != null
            ? LatLng(_ctrl.dropoffLat!, _ctrl.dropoffLng!)
            : null);

    final result = await Navigator.push<LocationPickResult>(
      context,
      MaterialPageRoute(
        builder: (_) => MapLocationPickerScreen(initialPosition: existing),
      ),
    );
    if (result != null) {
      if (isPickup) {
        _ctrl.setPickupLocation(result.address, result.lat, result.lng);
      } else {
        _ctrl.setDropoffLocation(result.address, result.lat, result.lng);
      }
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

  Widget _buildDropdown({
    required String label,
    required RxString value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontsize: 12.sp,
          color: AppColors.secondaryTextColor,
          textAlign: TextAlign.start,
          bottom: 6.h,
          left: 2.w,
        ),
        Obx(() => Container(
              height: 46.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2427),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                    color: const Color(0xFF3A3A3A), width: 0.8),
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
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                ),
              ),
            )),
        SizedBox(height: 12.h),
      ],
    );
  }

  Widget _buildFacilityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Drop-off Facility *',
          fontsize: 12.sp,
          color: AppColors.secondaryTextColor,
          textAlign: TextAlign.start,
          bottom: 6.h,
          left: 2.w,
        ),
        Obx(() => Container(
              height: 46.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2427),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                    color: const Color(0xFF3A3A3A), width: 0.8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _ctrl.selectedFacilityId.value.isEmpty
                      ? null
                      : _ctrl.selectedFacilityId.value,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF252525),
                  iconEnabledColor: AppColors.secondaryTextColor,
                  hint: CustomText(
                    text: 'Select facility',
                    fontsize: 13.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  style: TextStyle(
                    color: AppColors.primaryTextColor,
                    fontSize: 13.sp,
                    fontFamily: 'Poppins',
                  ),
                  onChanged: (id) {
                    final f = _ctrl.facilities.firstWhere((f) => f.id == id);
                    _ctrl.setFacility(f);
                  },
                  items: _ctrl.facilities
                      .map((f) => DropdownMenuItem(
                            value: f.id,
                            child: Text(f.name),
                          ))
                      .toList(),
                ),
              ),
            )),
        SizedBox(height: 12.h),
      ],
    );
  }

  // ── Step Indicator ──────────────────────────────────────────────────────────
  Widget _buildStepIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Step 0$_currentStep of 02',
                fontsize: 12.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
              Row(
                children: [
                  CustomText(
                    text: '$_currentStep',
                    fontsize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                    textAlign: TextAlign.start,
                  ),
                  CustomText(
                    text: '/2',
                    fontsize: 14.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: _currentStep / 2,
              backgroundColor: const Color(0xFF3A3A3A),
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              minHeight: 4.h,
            ),
          ),
        ],
      ),
    );
  }

  // ── STEP 1 ──────────────────────────────────────────────────────────────────
  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 100.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            iconAsset: 'assets/icons/infocircle.svg',
            title: 'Shipment Information',
            children: [
              CustomTextField(
                controller: _ctrl.companyController,
                labelText: 'Company',
                hintText: 'Courier',
              ),
              CustomTextField(
                controller: _ctrl.jobNameController,
                labelText: 'Job Name',
                hintText: 'e.g., Spinal Kit Delivery',
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'Type',
                      value: _ctrl.selectedPackageType,
                      items: CreateShipmentController.packageTypes,
                      onChanged: _ctrl.setPackageType,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildDropdown(
                      label: 'Priority',
                      value: _ctrl.selectedPriority,
                      items: CreateShipmentController.priorities,
                      onChanged: _ctrl.setPriority,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Add Products
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push<List<Map<String, String>>>(
                context,
                MaterialPageRoute(
                  builder: (_) => ShipmentSelectImplantsScreen(
                    initialSelected: _ctrl.selectedProducts.toList(),
                  ),
                ),
              );
              if (result != null) {
                _ctrl.selectedProducts.assignAll(result);
              }
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              margin: EdgeInsets.only(bottom: 8.h),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: AppColors.primaryColor, size: 18.r),
                  SizedBox(width: 8.w),
                  Obx(() => CustomText(
                        text: _ctrl.selectedProducts.isEmpty
                            ? 'Add Products from Inventory'
                            : 'Products (${_ctrl.selectedProducts.length}) — Edit',
                        fontsize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                        textAlign: TextAlign.start,
                      )),
                ],
              ),
            ),
          ),

          // Selected products list
          Obx(() {
            if (_ctrl.selectedProducts.isEmpty) {
              return SizedBox(height: 8.h);
            }
            return Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2427),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                    color: AppColors.primaryColor.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._ctrl.selectedProducts.asMap().entries.map((e) {
                    final idx = e.key;
                    final p = e.value;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 6.h),
                      child: Row(
                        children: [
                          Container(
                            width: 28.r,
                            height: 28.r,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Icon(Icons.medical_services_outlined,
                                color: AppColors.primaryColor, size: 14.r),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: 'Implant ${idx + 1}',
                                  fontsize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryTextColor,
                                  textAlign: TextAlign.start,
                                ),
                                CustomText(
                                  text: p['productType'] ?? 'implant',
                                  fontsize: 10.sp,
                                  color: AppColors.secondaryTextColor,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _ctrl.selectedProducts.removeAt(idx),
                            child: Icon(Icons.close,
                                color: AppColors.secondaryTextColor,
                                size: 16.r),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          }),

          // Package Details
          _buildSection(
            iconAsset: 'assets/icons/packagedetails.svg',
            title: 'Package Details',
            children: [
              _buildDropdown(
                label: 'Services Type',
                value: _ctrl.selectedServiceType,
                items: CreateShipmentController.serviceTypes,
                onChanged: _ctrl.setServiceType,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _ctrl.weightController,
                      labelText: 'Weight (lbs)',
                      hintText: '4.5',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
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
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _ctrl.distanceController,
                      labelText: 'Distance (miles) *',
                      hintText: '12.5',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomTextField(
                      controller: _ctrl.totalCostController,
                      labelText: 'Total Cost (\$) *',
                      hintText: '150.00',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                    ),
                  ),
                ],
              ),
              CustomTextField(
                controller: _ctrl.specialInstructionsController,
                labelText: 'Special Instructions',
                hintText: 'Medical Implants - Temperature Sensitive',
                maxLine: 3,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── STEP 2 ──────────────────────────────────────────────────────────────────
  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 180.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pickup
          _buildSection(
            iconAsset: 'assets/icons/logisticspickup.svg',
            title: 'Logistics - Pickup',
            children: [
              GestureDetector(
                onTap: () => _openMapPicker(isPickup: true),
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: _ctrl.pickupAddressController,
                    labelText: 'Address *',
                    hintText: 'Tap to select on map',
                    readOnly: true,
                    suffixIcon: Icon(Icons.map_outlined,
                        size: 16.r, color: AppColors.primaryColor),
                  ),
                ),
              ),
              CustomTextField(
                controller: _ctrl.pickupPhoneController,
                labelText: 'Phone Number *',
                hintText: 'phone no',
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

          // Drop-off
          _buildSection(
            iconAsset: 'assets/icons/location.svg',
            title: 'Logistics - Drop-off',
            children: [
              GestureDetector(
                onTap: () => _openMapPicker(isPickup: false),
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: _ctrl.dropoffAddressController,
                    labelText: 'Address *',
                    hintText: 'Tap to select on map',
                    readOnly: true,
                    suffixIcon: Icon(Icons.map_outlined,
                        size: 16.r, color: AppColors.primaryColor),
                  ),
                ),
              ),
              CustomTextField(
                controller: _ctrl.dropoffPhoneController,
                labelText: 'Phone Number *',
                hintText: 'phone no',
                keyboardType: TextInputType.phone,
              ),
              CustomTextField(
                controller: _ctrl.dropoffInstructionsController,
                labelText: 'Drop-off Instructions',
                hintText: 'Dock number, contact person, etc.',
                maxLine: 3,
              ),
              // Facility picker
              Obx(() {
                if (_ctrl.isFacilitiesLoading.value) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Center(
                      child: SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  );
                }
                if (_ctrl.facilities.isEmpty) return const SizedBox.shrink();
                return _buildFacilityDropdown();
              }),
            ],
          ),

          // Files
          _buildSection(
            title: 'Files',
            subtitle: 'image/pdf',
            children: [
              GestureDetector(
                onTap: _showUploadOptions,
                child: CustomPaint(
                  painter: _DashedBorderPainter(
                    color: AppColors.dotButtonInactiveColor.withValues(alpha: 0.6),
                    borderRadius: 8.r,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined,
                            color: AppColors.secondaryTextColor, size: 28.r),
                        SizedBox(height: 8.h),
                        CustomText(
                          text: 'Upload Your Files',
                          fontsize: 13.sp,
                          color: AppColors.secondaryTextColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(() {
                if (_ctrl.uploadedFiles.isEmpty) return const SizedBox.shrink();
                return Column(
                  children: [
                    SizedBox(height: 12.h),
                    ..._ctrl.uploadedFiles.asMap().entries.map(
                          (e) => _fileChip(e.value, e.key),
                        ),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    String? iconAsset,
    required String title,
    String? subtitle,
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
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: Row(
              children: [
                if (iconAsset != null) ...[
                  SvgPicture.asset(iconAsset, width: 18.r, height: 18.r),
                  SizedBox(width: 8.w),
                ],
                CustomText(
                  text: title,
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                if (subtitle != null) ...[
                  SizedBox(width: 6.w),
                  CustomText(
                    text: subtitle,
                    fontsize: 11.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ],
            ),
          ),
          ...children,
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
              child: Image.file(
                f,
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
          onTap: () {
            if (_currentStep == 2) {
              setState(() => _currentStep = 1);
            } else {
              Navigator.pop(context);
            }
          },
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
          Column(
            children: [
              _buildStepIndicator(),
              Expanded(
                child: _currentStep == 1 ? _buildStep1() : _buildStep2(),
              ),
            ],
          ),

          // ── Sticky button ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.backgroundColor,
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: _currentStep == 1
                  ? CustomButton(
                      title: 'Continue to Logistics',
                      titlecolor: const Color(0xFF1E2121),
                      suffixIcon: Icon(Icons.arrow_forward,
                          color: const Color(0xFF1E2121), size: 18.r),
                      onpress: () {
                        if (_ctrl.validateStep1()) {
                          setState(() => _currentStep = 2);
                        }
                      },
                    )
                  : Obx(() => CustomButton(
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

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;

  const _DashedBorderPainter(
      {required this.color, required this.borderRadius});

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
        canvas.drawPath(metric.extractPath(distance, end.toDouble()), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) =>
      old.color != color || old.borderRadius != borderRadius;
}
