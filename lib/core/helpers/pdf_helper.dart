import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../features/ representative/all_surgeries/model/surgery_model.dart';
import '../../features/ representative/physicions/domain/model/physician_model.dart';

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
    await Share.shareXFiles([XFile(file.path)], subject: subject);
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
    await Share.shareXFiles([XFile(file.path)]);
  }

  // ── Download from URL & share ──────────────────────────────────────────────
  static Future<void> downloadAndShare(String url) async {
    if (url.isEmpty) return;
    final fileName = Uri.parse(url).pathSegments.last.isNotEmpty
        ? Uri.parse(url).pathSegments.last
        : 'document';
    final dir = await getTemporaryDirectory();
    final savePath = '${dir.path}/$fileName';
    await Dio().download(url, savePath);
    await Share.shareXFiles([XFile(savePath)]);
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
