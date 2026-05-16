import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerHelper {
  static Future<BitmapDescriptor> pickup() =>
      _pin(const Color(0xFF22C55E), Icons.inventory_2_rounded);

  static Future<BitmapDescriptor> dropoff() =>
      _pin(const Color(0xFFEF4444), Icons.flag_rounded);

  static Future<BitmapDescriptor> waypoint() =>
      _pin(const Color(0xFFF59E0B), Icons.local_shipping_rounded);

  static Future<BitmapDescriptor> _pin(Color color, IconData icon) async {
    const double w = 88, h = 116;
    const double cx = w / 2, r = 36, cy = r + 9;

    final rec = ui.PictureRecorder();
    final cvs = Canvas(rec);

    // Drop shadow (ellipse under tail)
    cvs.drawOval(
      Rect.fromCenter(
          center: const Offset(cx, h - 7), width: 28, height: 9),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.28)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Tail / pointer
    cvs.drawPath(
      Path()
        ..moveTo(cx - 12, cy + r - 8)
        ..lineTo(cx, h - 13)
        ..lineTo(cx + 12, cy + r - 8)
        ..close(),
      Paint()..color = color,
    );

    // White outer ring
    cvs.drawCircle(
      const Offset(cx, cy),
      r + 5,
      Paint()..color = Colors.white,
    );

    // Subtle inner shadow ring
    cvs.drawCircle(
      const Offset(cx, cy),
      r + 4,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Gradient-like colored circle (simulate depth with two circles)
    cvs.drawCircle(const Offset(cx, cy), r, Paint()..color = color);
    cvs.drawCircle(
      Offset(cx - 5, cy - 5),
      r,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.12)
        ..style = PaintingStyle.fill,
    );

    // Icon text
    final pb = ui.ParagraphBuilder(
      ui.ParagraphStyle(textAlign: TextAlign.center),
    )
      ..pushStyle(ui.TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontFamily: icon.fontFamily,
      ))
      ..addText(String.fromCharCode(icon.codePoint));

    final para = pb.build()
      ..layout(ui.ParagraphConstraints(width: w));
    cvs.drawParagraph(para, Offset(0, cy - para.height / 2));

    final pic = rec.endRecording();
    final img = await pic.toImage(w.toInt(), h.toInt());
    final bd = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bd!.buffer.asUint8List());
  }
}
