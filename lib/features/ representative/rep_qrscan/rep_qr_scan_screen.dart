import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/constants/app_colors.dart';
import 'presentation/controller/rep_qr_scan_controller.dart';
import 'presentation/widgets/qr_bottom_actions.dart';
import 'presentation/widgets/qr_frame_corners.dart';
import 'presentation/widgets/qr_play_painter.dart';
import 'presentation/widgets/qr_result_dialog.dart';
import 'presentation/widgets/qr_scanline_state.dart';
import 'presentation/widgets/qrtop_bar.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  late final MobileScannerController _scanner;
  late final QrScanController _c;

  @override
  void initState() {
    super.initState();

    _scanner = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
      autoStart: false, // we start it ourselves after first frame
    );

    // Always create a fresh controller instance
    if (Get.isRegistered<QrScanController>()) {
      Get.delete<QrScanController>(force: true);
    }
    _c = Get.put(QrScanController());
    _c.attachScanner(_scanner);

    // Start camera after the first frame so the surface is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scanner.start();
    });
  }

  @override
  void dispose() {
    _scanner.dispose();
    if (Get.isRegistered<QrScanController>()) {
      Get.delete<QrScanController>(force: true);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera feed — plain Stack child, no Positioned.fill wrapper
          MobileScanner(
            key: const ValueKey('qr_scanner'),
            controller: _scanner,
            fit: BoxFit.cover,
            onDetect: _c.onDetect,
            errorBuilder: (context, error, child) {
              return ColoredBox(
                color: Colors.black,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.no_photography_outlined,
                          color: AppColors.secondaryTextColor, size: 52),
                      const SizedBox(height: 12),
                      Text(
                        'Camera unavailable\n${error.errorCode.name}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.secondaryTextColor,
                          fontSize: 13,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Semi-transparent overlay with cutout
          const QrOverlayPainter(),

          // Scan line — hidden after scan
          Obx(() => _c.hasScanned.value
              ? const SizedBox.shrink()
              : const QrScanLine()),

          // Corner brackets — hidden after scan
          Obx(() => _c.hasScanned.value
              ? const SizedBox.shrink()
              : const QrFrameCorners()),

          // Top bar: X + flash
          QrTopBar(controller: _c),

          // Bottom actions — hidden after scan
          Obx(() => _c.hasScanned.value
              ? const SizedBox.shrink()
              : QrBottomActions(
                  onHistory: () {},
                  onHelp: () {},
                )),

          // Result panel — shown on scan success
          Obx(() => _c.hasScanned.value
              ? QrResultPanel(value: _c.scannedValue.value)
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
