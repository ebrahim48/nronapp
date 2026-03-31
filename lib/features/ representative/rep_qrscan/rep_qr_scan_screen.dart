import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nron_app/features/%20representative/rep_qrscan/presentation/controller/rep_qr_scan_controller.dart';
import 'package:nron_app/features/%20representative/rep_qrscan/presentation/widgets/qr_bottom_actions.dart';
import 'package:nron_app/features/%20representative/rep_qrscan/presentation/widgets/qr_frame_corners.dart';
import 'package:nron_app/features/%20representative/rep_qrscan/presentation/widgets/qr_play_painter.dart';
import 'package:nron_app/features/%20representative/rep_qrscan/presentation/widgets/qr_result_dialog.dart';
import 'package:nron_app/features/%20representative/rep_qrscan/presentation/widgets/qr_scanline_state.dart';
import 'package:nron_app/features/%20representative/rep_qrscan/presentation/widgets/qrtop_bar.dart';
import '../../../core/constants/app_colors.dart';

class QrScanScreen extends StatelessWidget {
  const QrScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(QrScanController());

    // Watch for scan result
    ever(c.scannedValue, (value) {
      if (value.isNotEmpty) {
        QrResultDialog.show(value);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          // Camera
          Positioned.fill(
            child: MobileScanner(
              controller: c.scannerController,
              onDetect: c.onDetect,
            ),
          ),

          const QrOverlayPainter(),

          const QrScanLine(),

          const QrFrameCorners(),

          const QrTopBar(),

          // QrHintText(),

          // Bottom actions
          QrBottomActions(
            onHistory: () {
              // Navigate to history
            },
            onHelp: () {
              // Show help
            },
          ),
        ],
      ),
    );
  }
}
