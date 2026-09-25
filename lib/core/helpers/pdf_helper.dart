import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart' show Rect, WidgetsBinding;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'toast_mesage_helper.dart';
import '../../features/ representative/all_surgeries/model/surgery_model.dart';
import '../../features/ representative/physicions/domain/model/physician_model.dart';
import '../../features/ representative/sales/model/sales_model.dart';
import '../../features/manager/commission/model/manager_commission_model.dart';

class PdfHelper {
  static const _primary = PdfColor.fromInt(0xFF00C5DA);
  static const _bg = PdfColor.fromInt(0xFF1E2121);
  static const _text = PdfColor.fromInt(0xFFFFFFFF);
  static const _subText = PdfColor.fromInt(0xFF9E9E9E);
  static const _border = PdfColor.fromInt(0xFF3A3A3A);

  // ── Surgery PDF ────────────────────────────────────────────────────────────
  static Future<void> shareSurgeryPdf(SurgeryDetailModel d) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        theme: pw.ThemeData.withFont(
          base: pw.Font.helvetica(),
          bold: pw.Font.helveticaBold(),
        ),
        build: (ctx) => [
          _pageHeader('Surgery Report'),
          pw.SizedBox(height: 20),

          _sectionBox('Physician', [
            _infoRow('Name', d.physicianName),
            _infoRow('Specialty', d.physicianSpecialty),
            _infoRow('Practice', d.physicianPractice),
            _infoRow('Phone', d.physicianPhone),
            _infoRow('Email', d.physicianEmail),
          ]),
          pw.SizedBox(height: 14),

          _sectionBox('Surgery Info', [
            _infoRow('Patient ID', d.patientId),
            _infoRow('Facility', d.facilityName),
            _infoRow('Facility Address', d.facilityAddress),
            _infoRow('Date of Surgery', _fmtDate(d.dateOfSurgery)),
            _infoRow('Surgery Type', d.surgeryType),
          ]),

          if (d.screws.isNotEmpty ||
              d.plates.isNotEmpty ||
              d.rodsOrConnectors.isNotEmpty ||
              d.implants.isNotEmpty) ...[
            pw.SizedBox(height: 14),
            _sectionBox('Surgery Materials', [
              if (d.screws.isNotEmpty) _infoRow('Screws', d.screws),
              if (d.plates.isNotEmpty) _infoRow('Plates', d.plates),
              if (d.rodsOrConnectors.isNotEmpty)
                _infoRow('Rods / Connectors', d.rodsOrConnectors),
              if (d.implants.isNotEmpty) _infoRow('Implants', d.implants),
            ]),
          ],

          pw.SizedBox(height: 14),
          _sectionBox('Case Notes', [
            pw.Text(
              d.caseNotes.isNotEmpty ? d.caseNotes : 'No notes added.',
              style: pw.TextStyle(
                fontSize: 11,
                color: d.caseNotes.isNotEmpty ? PdfColors.black : _subText,
              ),
            ),
          ]),

          pw.SizedBox(height: 20),
          _footer(),
        ],
      ),
    );

    await _saveAndShare(pdf, 'surgery_${d.id}.pdf', 'Surgery Report');
  }

  // ── Physician PDF ──────────────────────────────────────────────────────────
  static Future<void> sharePhysicianPdf(PhysicianModel p) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        theme: pw.ThemeData.withFont(
          base: pw.Font.helvetica(),
          bold: pw.Font.helveticaBold(),
        ),
        build: (ctx) => [
          _pageHeader('Physician Profile'),
          pw.SizedBox(height: 20),

          _sectionBox('Basic Info', [
            _infoRow('Full Name', p.fullName),
            _infoRow('Specialty', p.specialty),
            _infoRow('Practice', p.practice),
            _infoRow('Location', p.location),
          ]),
          pw.SizedBox(height: 14),

          _sectionBox('Contact Info', [
            _infoRow('Phone', p.contactInfo.phoneNumber),
            _infoRow('Cell', p.contactInfo.cellNumber),
            _infoRow('Email', p.contactInfo.email),
            _infoRow('Date of Birth', _fmtDate(p.contactInfo.dateOfBirth)),
          ]),
          pw.SizedBox(height: 14),

          _sectionBox('Notes', [
            pw.Text(
              p.noteToSelf.isNotEmpty ? p.noteToSelf : 'No notes added.',
              style: pw.TextStyle(
                fontSize: 11,
                color: p.noteToSelf.isNotEmpty ? PdfColors.black : _subText,
              ),
            ),
          ]),

          if (p.documents.isNotEmpty) ...[
            pw.SizedBox(height: 14),
            _sectionBox('Documents', [
              ...p.documents.asMap().entries.map(
                    (e) => _infoRow(
                        'Document ${e.key + 1}', e.value.split('/').last),
                  ),
            ]),
          ],

          pw.SizedBox(height: 20),
          _footer(),
        ],
      ),
    );

    await _saveAndShare(pdf, 'physician_${p.id}.pdf', 'Physician Profile');
  }

  // ── Packing slip PDF ───────────────────────────────────────────────────────
  static Future<void> sharePackingSlipPdf(SaleDetailModel d) async {
    final pdf = pw.Document();
    final items = d.inventoryItems;
    final subtotal =
        items.fold<double>(0, (sum, i) => sum + (i.price * i.qty));
    final total = subtotal > 0 ? subtotal : d.totalAmount;
    String money(double v) => '\$${v.toStringAsFixed(2)}';

    pw.Widget cell(String text,
            {pw.TextAlign align = pw.TextAlign.left, bool bold = false}) =>
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 6),
          child: pw.Text(
            text,
            textAlign: align,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: bold ? _subText : PdfColors.black,
            ),
          ),
        );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        theme: pw.ThemeData.withFont(
          base: pw.Font.helvetica(),
          bold: pw.Font.helveticaBold(),
        ),
        build: (ctx) => [
          _pageHeader('Packing Slip'),
          pw.SizedBox(height: 20),

          _sectionBox('Sale Info', [
            _infoRow('Sale ID', d.saleNumber),
            _infoRow('Date', d.procedureDate),
            _infoRow('Facility', d.facility),
            _infoRow('Physician', d.physician),
            _infoRow('Vendor', d.vendor),
            _infoRow('PO Number', d.ppoNumber),
          ]),
          pw.SizedBox(height: 14),

          _sectionBox('Items', [
            pw.Table(
              border: pw.TableBorder(
                horizontalInside: pw.BorderSide(color: _border, width: 0.5),
                bottom: pw.BorderSide(color: _border, width: 0.5),
              ),
              columnWidths: const {
                0: pw.FlexColumnWidth(5),
                1: pw.FlexColumnWidth(2),
                2: pw.FlexColumnWidth(3),
              },
              children: [
                pw.TableRow(children: [
                  cell('PRODUCT', bold: true),
                  cell('QTY', align: pw.TextAlign.center, bold: true),
                  cell('PRICE', align: pw.TextAlign.right, bold: true),
                ]),
                if (items.isEmpty)
                  pw.TableRow(children: [cell('No items.'), cell(''), cell('')])
                else
                  ...items.map((i) => pw.TableRow(children: [
                        cell([
                          i.name.isEmpty ? i.tag : i.name,
                          if (i.serial.isNotEmpty) 'SN: ${i.serial}',
                        ].join('\n')),
                        cell(i.qty.toString().padLeft(2, '0'),
                            align: pw.TextAlign.center),
                        cell(i.price > 0 ? money(i.price * i.qty) : '—',
                            align: pw.TextAlign.right),
                      ])),
              ],
            ),
            pw.SizedBox(height: 10),
            if (subtotal > 0)
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text('Subtotal:  ${money(subtotal)}',
                    style: const pw.TextStyle(fontSize: 11, color: _subText)),
              ),
            pw.SizedBox(height: 4),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text('TOTAL:  ${money(total)}',
                  style: pw.TextStyle(
                      fontSize: 13, fontWeight: pw.FontWeight.bold)),
            ),
          ]),

          pw.SizedBox(height: 20),
          _footer(),
        ],
      ),
    );

    await _saveAndShare(
        pdf, 'packing_slip_${d.saleNumber.isEmpty ? d.id : d.saleNumber}.pdf',
        'Packing Slip');
  }

  // ── Missing / damaged instrument report PDF ────────────────────────────────
  static Future<void> shareMissingReportPdf({
    required String id,
    required String trayTitle,
    required String instrumentName,
    required String issueType,
    required String vendorName,
    String reportedBy = '',
    String date = '',
    String notes = '',
    List<String> evidenceUrls = const [],
  }) async {
    // Download evidence images up front; skip any that fail or aren't images.
    final images = <pw.MemoryImage>[];
    for (final url in evidenceUrls) {
      final lower = url.toLowerCase().split('?').first;
      if (!(lower.endsWith('.png') ||
          lower.endsWith('.jpg') ||
          lower.endsWith('.jpeg') ||
          lower.endsWith('.webp'))) {
        continue;
      }
      try {
        final res = await Dio().get<List<int>>(url,
            options: Options(responseType: ResponseType.bytes));
        if (res.data != null) {
          images.add(pw.MemoryImage(Uint8List.fromList(res.data!)));
        }
      } catch (_) {}
    }

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        theme: pw.ThemeData.withFont(
          base: pw.Font.helvetica(),
          bold: pw.Font.helveticaBold(),
        ),
        build: (ctx) => [
          _pageHeader('Missing Instrument Report'),
          pw.SizedBox(height: 20),
          _sectionBox('Report Info', [
            _infoRow('Tray', trayTitle),
            _infoRow('Instrument', instrumentName),
            _infoRow('Issue Type', issueType),
            _infoRow('Vendor', vendorName),
            _infoRow('Reported By', reportedBy),
            _infoRow('Date', _fmtDate(date)),
          ]),
          pw.SizedBox(height: 14),
          _sectionBox('Description & Notes', [
            pw.Text(
              notes.isNotEmpty ? notes : 'No notes added.',
              style: pw.TextStyle(
                fontSize: 11,
                color: notes.isNotEmpty ? PdfColors.black : _subText,
              ),
            ),
          ]),
          if (images.isNotEmpty) ...[
            pw.SizedBox(height: 14),
            _sectionBox('Evidence', [
              pw.Wrap(
                spacing: 10,
                runSpacing: 10,
                children: images
                    .map((img) => pw.Container(
                          width: 160,
                          height: 160,
                          child: pw.Image(img, fit: pw.BoxFit.cover),
                        ))
                    .toList(),
              ),
            ]),
          ],
          pw.SizedBox(height: 20),
          _footer(),
        ],
      ),
    );

    await _saveAndShare(pdf, 'missing_report_$id.pdf', 'Missing Instrument Report');
  }

  // ── Commission receipt PDF ─────────────────────────────────────────────────
  static Future<void> shareCommissionReceiptPdf(CommissionDetailModel d) async {
    String money(double v) => '\$${v.toStringAsFixed(2)}';
    final isPaid = d.paymentStatus == CommissionPaymentStatus.paid;
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        theme: pw.ThemeData.withFont(
          base: pw.Font.helvetica(),
          bold: pw.Font.helveticaBold(),
        ),
        build: (ctx) => [
          _pageHeader('Commission Receipt'),
          pw.SizedBox(height: 20),

          // Amount + status
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: _border, width: 0.8),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Column(children: [
              pw.Text(money(d.totalCommissionDue),
                  style: pw.TextStyle(
                      fontSize: 26,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromInt(0xFF1DB954))),
              pw.SizedBox(height: 4),
              pw.Text(isPaid ? 'PAID' : 'UNPAID',
                  style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                      color: isPaid
                          ? PdfColor.fromInt(0xFF1DB954)
                          : PdfColors.orange)),
            ]),
          ),
          pw.SizedBox(height: 14),

          _sectionBox('Sale Details', [
            _infoRow('Sale ID', d.saleId),
            _infoRow('Date', d.date),
            _infoRow('Representative', d.repName),
            _infoRow('Facility', d.facility),
            _infoRow('Sale Amount', d.saleAmount > 0 ? money(d.saleAmount) : ''),
            _infoRow('Commission Rate', d.rate > 0 ? '${d.rate.toInt()}%' : ''),
          ]),

          if (d.splits.isNotEmpty) ...[
            pw.SizedBox(height: 14),
            _sectionBox('Commission Split', [
              ...d.splits.map((sp) => _infoRow(
                    sp.name,
                    [
                      '${sp.splitPercent}%',
                      if (sp.splitAmount != null) money(sp.splitAmount!),
                    ].join('  ·  '),
                  )),
              if (d.totalCommissionPool > 0)
                _infoRow('Total Pool', money(d.totalCommissionPool)),
            ]),
          ],

          pw.SizedBox(height: 20),
          _footer(),
        ],
      ),
    );

    final ref = d.saleId.isNotEmpty ? d.saleId : d.id;
    await _saveAndShare(pdf, 'commission_receipt_$ref.pdf', 'Commission Receipt');
  }

  // ── Shared widgets ─────────────────────────────────────────────────────────
  static pw.Widget _pageHeader(String title) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const pw.BoxDecoration(
        color: _primary,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 20,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.black,
        ),
      ),
    );
  }

  static pw.Widget _sectionBox(String title, List<pw.Widget> children) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _border, width: 0.8),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: _primary,
              letterSpacing: 1.2,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Divider(color: _border, thickness: 0.5),
          pw.SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  static pw.Widget _infoRow(String label, String value) {
    final v = value.isNotEmpty ? value : '—';
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 130,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: _subText,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              v,
              style: const pw.TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _footer() {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Text(
        'Generated by NRON · ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
        style: const pw.TextStyle(fontSize: 9, color: _subText),
      ),
    );
  }

  // ── Save & share (generated PDF) ──────────────────────────────────────────
  static Future<void> _saveAndShare(
      pw.Document pdf, String fileName, String subject) async {
    final bytes = await pdf.save();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    await _share([XFile(file.path)], subject: subject);
  }

  // iOS/iPad requires a non-zero sharePositionOrigin, otherwise the share
  // sheet throws a PlatformException. Anchor it to the screen centre.
  static Rect _shareOrigin() {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final size = view.physicalSize / view.devicePixelRatio;
    return Rect.fromLTWH(size.width / 2, size.height / 2, 1, 1);
  }

  static Future<void> _share(List<XFile> files, {String? subject}) async {
    try {
      await Share.shareXFiles(files,
          subject: subject, sharePositionOrigin: _shareOrigin());
    } catch (_) {
      ToastMessageHelper.showToastMessage('Failed to share file.', title: 'Error');
    }
  }

  // ── Save a base64-encoded file (e.g. chatbot attachment) & share ───────────
  static Future<void> saveBase64AndShare(
      String base64Data, String fileName) async {
    if (base64Data.isEmpty) return;
    // Strip a data-URI prefix if present (e.g. "data:application/pdf;base64,")
    final commaIndex = base64Data.indexOf(',');
    final cleaned = base64Data.startsWith('data:') && commaIndex != -1
        ? base64Data.substring(commaIndex + 1)
        : base64Data;
    final bytes = base64Decode(cleaned);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    await _share([XFile(file.path)]);
  }

  // ── Download from URL & share ──────────────────────────────────────────────
  static Future<void> downloadAndShare(String url) async {
    if (url.isEmpty) return;
    final fileName = Uri.parse(url).pathSegments.last.isNotEmpty
        ? Uri.parse(url).pathSegments.last
        : 'document';
    final dir = await getTemporaryDirectory();
    final savePath = '${dir.path}/$fileName';
    try {
      await Dio().download(url, savePath);
    } catch (_) {
      ToastMessageHelper.showToastMessage('Failed to download file.', title: 'Error');
      return;
    }
    await _share([XFile(savePath)]);
  }

  static String _fmtDate(String iso) {
    if (iso.isEmpty) return '—';
    try {
      return DateFormat('MM/dd/yyyy').format(DateTime.parse(iso));
    } catch (_) {
      return iso;
    }
  }
}
