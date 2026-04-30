import 'package:intl/intl.dart';

enum ExpenseStatus { all, pending, approved, rejected }

ExpenseStatus _statusFromApi(String s) {
  switch (s.toLowerCase()) {
    case 'approved':
      return ExpenseStatus.approved;
    case 'rejected':
      return ExpenseStatus.rejected;
    default:
      return ExpenseStatus.pending;
  }
}

String _fmt(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  try {
    return DateFormat('MMM dd, yyyy').format(DateTime.parse(raw).toLocal());
  } catch (_) {
    return raw;
  }
}

class RepresentativeModel {
  final String id;
  final String fullName;
  final String email;
  final String profileUrl;

  const RepresentativeModel({
    this.id = '',
    this.fullName = '',
    this.email = '',
    this.profileUrl = '',
  });

  factory RepresentativeModel.fromJson(Map<String, dynamic> json) =>
      RepresentativeModel(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
        fullName: json['fullName']?.toString() ??
            json['name']?.toString() ??
            json['firstName']?.toString() ??
            '',
        email: json['email']?.toString() ?? '',
        profileUrl: json['profileUrl']?.toString() ??
            json['avatar']?.toString() ??
            '',
      );
}

class ExpenseAttachment {
  final String fileName;
  final String size;
  final String date;
  final bool isPdf;
  final String? url;

  const ExpenseAttachment({
    required this.fileName,
    required this.size,
    required this.date,
    required this.isPdf,
    this.url,
  });

  factory ExpenseAttachment.fromUrl(String url) {
    final fileName = url.split('/').last.split('?').first;
    final isPdf = fileName.toLowerCase().endsWith('.pdf');
    return ExpenseAttachment(
      fileName: fileName,
      size: '',
      date: '',
      isPdf: isPdf,
      url: url,
    );
  }
}

class ExpenseModel {
  final String id;
  final String title;
  final String doctor;
  final String date;
  final double amount;
  final ExpenseStatus status;
  final String? thumbnailUrl;

  final String? physicianId;
  final String? representativeId;
  final String? category;
  final String? dateOfExpense;
  final bool? isPaid;
  final String? description;
  final List<ExpenseAttachment> attachments;
  final String year;
  final String month;
  final String createdAt;

  const ExpenseModel({
    this.id = '',
    this.title = '',
    this.doctor = '',
    this.date = '',
    this.amount = 0,
    this.status = ExpenseStatus.pending,
    this.thumbnailUrl,
    this.physicianId,
    this.representativeId,
    this.category,
    this.dateOfExpense,
    this.isPaid,
    this.description,
    this.attachments = const [],
    this.year = '',
    this.month = '',
    this.createdAt = '',
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    final files = (json['files'] as List<dynamic>?) ?? [];
    final attachmentUrls = (json['attachments'] as List<dynamic>?) ?? [];

    final repRaw = json['representative'];
    final repId = repRaw is String
        ? repRaw
        : (repRaw is Map ? repRaw['_id']?.toString() ?? '' : '');

    final physRaw = json['physician'];
    final physId = physRaw is String
        ? physRaw
        : (physRaw is Map ? physRaw['_id']?.toString() ?? '' : '');

    final desc = json['description']?.toString() ?? '';
    final descPreview = desc.length > 45 ? '${desc.substring(0, 45)}...' : desc;

    return ExpenseModel(
      id: json['_id']?.toString() ?? '',
      title: json['category']?.toString() ?? '',
      doctor: descPreview,
      date: _fmt(json['createdAt']?.toString()),
      amount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      status: _statusFromApi(json['status']?.toString() ?? ''),
      thumbnailUrl: files.isNotEmpty ? files.first.toString() : null,
      physicianId: physId.isEmpty ? null : physId,
      representativeId: repId.isEmpty ? null : repId,
      category: json['category']?.toString(),
      dateOfExpense: _fmt(json['date']?.toString()),
      isPaid: json['isPaid'] as bool?,
      description: json['description']?.toString(),
      attachments: attachmentUrls
          .map((u) => ExpenseAttachment.fromUrl(u.toString()))
          .toList(),
      year: json['year']?.toString() ?? '',
      month: json['month']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}

class ExpenseDetailModel extends ExpenseModel {
  final RepresentativeModel? representative;

  const ExpenseDetailModel({
    super.id,
    super.title,
    super.doctor,
    super.date,
    super.amount,
    super.status,
    super.thumbnailUrl,
    super.physicianId,
    super.representativeId,
    super.category,
    super.dateOfExpense,
    super.isPaid,
    super.description,
    super.attachments,
    super.year,
    super.month,
    super.createdAt,
    this.representative,
  });

  String get representativeName => representative?.fullName ?? '';

  factory ExpenseDetailModel.fromJson(Map<String, dynamic> json) {
    final base = ExpenseModel.fromJson(json);

    final repRaw = json['representative'];
    RepresentativeModel? rep;
    if (repRaw is Map<String, dynamic>) {
      rep = RepresentativeModel.fromJson(repRaw);
    }

    return ExpenseDetailModel(
      id: base.id,
      title: base.title,
      doctor: base.doctor,
      date: base.date,
      amount: base.amount,
      status: base.status,
      thumbnailUrl: base.thumbnailUrl,
      physicianId: base.physicianId,
      representativeId: base.representativeId,
      category: base.category,
      dateOfExpense: base.dateOfExpense,
      isPaid: base.isPaid,
      description: base.description,
      attachments: base.attachments,
      year: base.year,
      month: base.month,
      createdAt: base.createdAt,
      representative: rep,
    );
  }
}
