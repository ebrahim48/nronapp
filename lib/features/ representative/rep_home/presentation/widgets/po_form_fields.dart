import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../../../../core/custom_widgets/custom_text_field.dart';

class PoSectionTitle extends StatelessWidget {
  final String title;
  const PoSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: CustomText(
        text: title,
        fontsize: 15.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.secondaryTextColor,
        textAlign: TextAlign.start,
      ),
    );
  }
}

class PoFieldLabel extends StatelessWidget {
  final String label;
  const PoFieldLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: CustomText(
        text: label,
        fontsize: 13.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryTextColor,
        textAlign: TextAlign.start,
      ),
    );
  }
}

class PoStatusDropdown extends StatelessWidget {
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const PoStatusDropdown({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 48.h,
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: const Color(0x1A4A4A4A),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFD4D4D4), width: 0.8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: const Color(0xFF1E2121),
          isExpanded: true,
          icon: SvgPicture.asset(
            'assets/icons/chevron.svg',
            width: 16.r,
            height: 16.r,
            colorFilter: const ColorFilter.mode(
              AppColors.secondaryTextColor,
              BlendMode.srcIn,
            ),
          ),
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14.sp,
            color: AppColors.primaryTextColor,
          ),
          items: options
              .map((o) => DropdownMenuItem(
            value: o,
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/complete.svg',
                  width: 16.r,
                  height: 16.r,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(o),
              ],
            ),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class PoIconTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? iconPath;
  final bool hasDropdown;
  final TextInputType keyboardType;
  final int maxLines;
  final String? suffixText;
  final VoidCallback? onTap;
  final bool readOnly;

  const PoIconTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.iconPath,
    this.hasDropdown = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.suffixText,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      keyboardType: keyboardType,
      maxLine: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      prefixIcon: iconPath != null
          ? SvgPicture.asset(
        iconPath!,
        width: 16.r,
        height: 16.r,
        colorFilter: const ColorFilter.mode(
          AppColors.secondaryTextColor,
          BlendMode.srcIn,
        ),
      )
          : null,
      suffixIcon: hasDropdown
          ? SvgPicture.asset(
        'assets/icons/chevron.svg',
        width: 10.r,
        height: 10.r,
        colorFilter: const ColorFilter.mode(
          AppColors.secondaryTextColor,
          BlendMode.srcIn,
        ),
      )
          : null,
    );
  }
}

class PoDropdownTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? iconPath;
  final List<String> options;

  const PoDropdownTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.iconPath,
    required this.options,
  });

  @override
  State<PoDropdownTextField> createState() => _PoDropdownTextFieldState();
}

class _PoDropdownTextFieldState extends State<PoDropdownTextField> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _open = !_open),
            child: Container(
              width: 345.w,
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: const Color(0x1A4A4A4A),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: _open
                      ? AppColors.primaryColor
                      : const Color(0xFFD4D4D4),
                  width: 0.8,
                ),
              ),
              child: Row(
                children: [
                  if (widget.iconPath != null) ...[
                    SvgPicture.asset(
                      widget.iconPath!,
                      width: 16.r,
                      height: 16.r,
                      colorFilter: const ColorFilter.mode(
                        AppColors.secondaryTextColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  Expanded(
                    child: Text(
                      widget.controller.text.isEmpty
                          ? widget.hintText
                          : widget.controller.text,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.sp,
                        color: widget.controller.text.isEmpty
                            ? AppColors.secondaryTextColor
                            : AppColors.primaryTextColor,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: SvgPicture.asset(
                      'assets/icons/chevron.svg',
                      width: 10.r,
                      height: 10.r,
                      colorFilter: const ColorFilter.mode(
                        AppColors.secondaryTextColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_open)
            Container(
              width: 345.w,
              margin: EdgeInsets.only(top: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2121),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
              ),
              child: Column(
                children: widget.options.asMap().entries.map((entry) {
                  final isLast = entry.key == widget.options.length - 1;
                  return GestureDetector(
                    onTap: () {
                      widget.controller.text = entry.value;
                      setState(() => _open = false);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        border: isLast
                            ? null
                            : const Border(
                                bottom: BorderSide(
                                  color: Color(0xFF3A3A3A),
                                  width: 0.8,
                                ),
                              ),
                      ),
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13.sp,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class PoProcedurePoRow extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController poController;

  const PoProcedurePoRow({
    super.key,
    required this.dateController,
    required this.poController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Procedure Date — width 165
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PoFieldLabel(label: 'Procedure Date'),
              _HalfField(
                controller: dateController,
                hintText: 'mm/dd/yyyy',
                suffixIcon: SvgPicture.asset(
                  'assets/icons/calendar.svg',
                  width: 16.r,
                  height: 16.r,
                  colorFilter: const ColorFilter.mode(
                    AppColors.secondaryTextColor,
                    BlendMode.srcIn,
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    builder: (ctx, child) => Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: AppColors.primaryColor,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) {
                    dateController.text =
                    '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
                  }
                },
              ),
            ],
          ),
        ),

        SizedBox(width: 12.w),

        // PO Number — width 165
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PoFieldLabel(label: 'PO Number'),
              _HalfField(
                controller: poController,
                hintText: 'PO-0000',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HalfField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;

  const _HalfField({
    required this.controller,
    required this.hintText,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0x1A4A4A4A),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFD4D4D4), width: 0.8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              readOnly: readOnly,
              onTap: onTap,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13.sp,
                color: AppColors.primaryTextColor,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.sp,
                  color: AppColors.secondaryTextColor,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (suffixIcon != null) suffixIcon!,
        ],
      ),
    );
  }
}

class PoVendorEmailToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const PoVendorEmailToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: 'Send Vendor Email',
            fontsize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
          // Custom toggle matching design spec
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: value ? AppColors.primaryColor : const Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment:
                value ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(3.r),
                  child: Container(
                    width: 18.r,
                    height: 18.r,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2121),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFA8A8A8),
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 5,
                          offset: Offset(0, 1),
                        ),
                        BoxShadow(
                          color: Color(0x1F000000),
                          blurRadius: 1,
                          offset: Offset(0, 3),
                        ),
                        BoxShadow(
                          color: Color(0x24000000),
                          blurRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PoDocumentItem extends StatelessWidget {
  final File file;
  final VoidCallback onDelete;

  const PoDocumentItem({
    super.key,
    required this.file,
    required this.onDelete,
  });

  String _getFileIcon(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    if (ext == 'pdf') return 'assets/icons/pdf.svg';
    if (['jpg', 'jpeg', 'png', 'gif'].contains(ext)) return 'assets/icons/image.svg';
    return 'assets/icons/document.svg';
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file.path.split('/').last;
    final sizeKb = (file.lengthSync() / 1024).toStringAsFixed(1);

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: const Color(0xFF1B1B1B),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                _getFileIcon(fileName),
                width: 18.r,
                height: 18.r,
                colorFilter: const ColorFilter.mode(
                  AppColors.secondaryTextColor,
                  BlendMode.srcIn,
                ),
                errorBuilder: (_, __, ___) => Icon(
                  Icons.insert_drive_file_outlined,
                  color: AppColors.secondaryTextColor,
                  size: 18.r,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: fileName,
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 2.h),
                CustomText(
                  text: '$sizeKb KB',
                  fontsize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: Icon(
              Icons.close_rounded,
              color: const Color(0xFFEC0101),
              size: 20.r,
            ),
          ),
        ],
      ),
    );
  }
}

class PoAttachDocumentBox extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;

  const PoAttachDocumentBox({
    super.key,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: SizedBox(
        width: double.infinity,
        height: 80.h,
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: const Color(0xFF3A3A3A),
            borderRadius: 12,
            dashWidth: 6,
            dashSpace: 4,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0x0D1AC8DB),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryColor,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.attach_file_rounded,
                        color: AppColors.primaryColor,
                        size: 22.r,
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Attach File',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          Text(
                            'PDF, JPG, PNG (max 10MB)',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: 'Poppins',
                              color: AppColors.secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;
  final double dashWidth;
  final double dashSpace;

  const _DashedBorderPainter({
    required this.color,
    required this.borderRadius,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);
    final PathMetrics metrics = path.computeMetrics();

    for (final PathMetric metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final extractPath = metric.extractPath(
          distance,
          distance + dashWidth,
        );
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => false;
}