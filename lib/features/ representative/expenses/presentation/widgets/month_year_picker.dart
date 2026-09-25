import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';

/// Calendar-style dialog that picks a month + year.
/// Returns a DateTime (day = 1) or null when cancelled.
Future<DateTime?> showMonthYearPicker(
  BuildContext context, {
  required DateTime initial,
  required int firstYear,
  required int lastYear,
}) {
  return showDialog<DateTime>(
    context: context,
    builder: (_) => _MonthYearPickerDialog(
      initial: initial,
      firstYear: firstYear,
      lastYear: lastYear,
    ),
  );
}

class _MonthYearPickerDialog extends StatefulWidget {
  final DateTime initial;
  final int firstYear;
  final int lastYear;

  const _MonthYearPickerDialog({
    required this.initial,
    required this.firstYear,
    required this.lastYear,
  });

  @override
  State<_MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<_MonthYearPickerDialog> {
  static const _primary = Color(0xFF00C5DA);
  static const _monthLabels = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  late int _year;
  late int _month;

  @override
  void initState() {
    super.initState();
    _year = widget.initial.year.clamp(widget.firstYear, widget.lastYear);
    _month = widget.initial.month;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final canPrev = _year > widget.firstYear;
    final canNext = _year < widget.lastYear;

    return Dialog(
      backgroundColor: const Color(0xFF1E2427),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Year selector ──────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: canPrev ? () => setState(() => _year--) : null,
                  icon: Icon(Icons.chevron_left,
                      size: 24.r,
                      color: canPrev
                          ? AppColors.primaryTextColor
                          : const Color(0xFF4A4A4A)),
                ),
                Text(
                  '$_year',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                IconButton(
                  onPressed: canNext ? () => setState(() => _year++) : null,
                  icon: Icon(Icons.chevron_right,
                      size: 24.r,
                      color: canNext
                          ? AppColors.primaryTextColor
                          : const Color(0xFF4A4A4A)),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // ── Month grid ─────────────────────────────────────────────────
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 12,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8.h,
                crossAxisSpacing: 8.w,
                childAspectRatio: 1.6,
              ),
              itemBuilder: (_, i) {
                final m = i + 1;
                final selected = m == _month;
                final isCurrent = m == now.month && _year == now.year;
                return GestureDetector(
                  onTap: () => setState(() => _month = m),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? _primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: selected || isCurrent
                            ? _primary
                            : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      _monthLabels[i],
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: 'Poppins',
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w400,
                        color: selected
                            ? Colors.white
                            : isCurrent
                                ? _primary
                                : AppColors.primaryTextColor,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 8.h),

            // ── Actions ────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel',
                      style: TextStyle(color: _primary, fontFamily: 'Poppins')),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pop(context, DateTime(_year, _month)),
                  child: const Text('OK',
                      style: TextStyle(
                          color: _primary,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
