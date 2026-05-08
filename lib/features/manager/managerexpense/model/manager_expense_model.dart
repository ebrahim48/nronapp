enum ManagerExpenseStatus { all, pending, approved, rejected }

// ── List item model ───────────────────────────────────────────────────────────

class ManagerExpenseModel {
  final String id;
  final String title;       // category
  final String categoryTag; // category uppercase
  final String typeTag;     // physician name or 'PHYSICIAN'
  final String date;        // formatted date
  final double amount;
  final ManagerExpenseStatus status;
  final String repInitials;
  final String repName;
  final String repProfileUrl;

  const ManagerExpenseModel({
    required this.id,
    required this.title,
    required this.categoryTag,
    required this.typeTag,
    required this.date,
    required this.amount,
    required this.status,
    required this.repInitials,
    required this.repName,
    this.repProfileUrl = '',
  });

  static ManagerExpenseStatus _parseStatus(String? s) {
    switch (s?.toLowerCase()) {
      case 'approved': return ManagerExpenseStatus.approved;
      case 'rejected': return ManagerExpenseStatus.rejected;
      default:         return ManagerExpenseStatus.pending;
    }
  }

  static String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw);
      const months = [
        'Jan','Feb','Mar','Apr','May','Jun',
        'Jul','Aug','Sep','Oct','Nov','Dec'
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  static String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  factory ManagerExpenseModel.fromJson(Map<String, dynamic> e) {
    final repMap = e['representative'] is Map
        ? e['representative'] as Map<String, dynamic>
        : <String, dynamic>{};
    final repName = repMap['fullName']?.toString() ??
        e['representativeName']?.toString() ?? '';
    final category = e['category']?.toString() ?? '';

    return ManagerExpenseModel(
      id: e['_id']?.toString() ?? '',
      title: category,
      categoryTag: category.toUpperCase(),
      typeTag: 'PHYSICIAN',
      date: _formatDate(e['date']?.toString()),
      amount: (e['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: _parseStatus(e['status']?.toString()),
      repInitials: _initials(repName),
      repName: repName,
      repProfileUrl: repMap['profileUrl']?.toString() ?? '',
    );
  }
}

// ── Detail model ──────────────────────────────────────────────────────────────

class ManagerExpenseDetailModel {
  final String id;
  final String repName;
  final String repRole;
  final String submittedDate;
  final String repProfileUrl;
  final double totalAmount;
  final ManagerExpenseStatus status;
  final String physicianClient;
  final String category;
  final String dateOfExpense;
  final String paidStatus;
  final String description;
  final List<ExpenseDetailAttachment> attachments;

  const ManagerExpenseDetailModel({
    required this.id,
    required this.repName,
    required this.repRole,
    required this.submittedDate,
    this.repProfileUrl = '',
    required this.totalAmount,
    required this.status,
    required this.physicianClient,
    required this.category,
    required this.dateOfExpense,
    required this.paidStatus,
    required this.description,
    required this.attachments,
  });

  static ManagerExpenseStatus _parseStatus(String? s) {
    switch (s?.toLowerCase()) {
      case 'approved': return ManagerExpenseStatus.approved;
      case 'rejected': return ManagerExpenseStatus.rejected;
      default:         return ManagerExpenseStatus.pending;
    }
  }

  static String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw);
      const months = [
        'Jan','Feb','Mar','Apr','May','Jun',
        'Jul','Aug','Sep','Oct','Nov','Dec'
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  factory ManagerExpenseDetailModel.fromJson(Map<String, dynamic> e) {
    final repMap = e['representative'] is Map
        ? e['representative'] as Map<String, dynamic>
        : <String, dynamic>{};
    final physicianMap = e['physician'] is Map
        ? e['physician'] as Map<String, dynamic>
        : <String, dynamic>{};

    final repName = repMap['fullName']?.toString() ??
        e['representativeName']?.toString() ?? '';
    final createdAt = e['createdAt']?.toString() ?? '';

    // Build attachments from files + attachments arrays
    final fileUrls = e['files'] is List
        ? (e['files'] as List).map((f) => f.toString()).toList()
        : <String>[];
    final attUrls = e['attachments'] is List
        ? (e['attachments'] as List).map((f) => f.toString()).toList()
        : <String>[];
    final allFiles = [...fileUrls, ...attUrls];

    final attachments = allFiles.map((url) {
      final isPdf = url.toLowerCase().endsWith('.pdf');
      final fileName = url.split('/').last;
      return ExpenseDetailAttachment(
        fileName: fileName,
        url: url,
        size: '',
        date: _formatDate(createdAt),
        isPdf: isPdf,
      );
    }).toList();

    return ManagerExpenseDetailModel(
      id: e['_id']?.toString() ?? '',
      repName: repName,
      repRole: 'Sales Representative',
      submittedDate: 'Submitted: ${_formatDate(createdAt)}',
      repProfileUrl: repMap['profileUrl']?.toString() ?? '',
      totalAmount: (e['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: _parseStatus(e['status']?.toString()),
      physicianClient: physicianMap['fullName']?.toString() ?? '',
      category: e['category']?.toString() ?? '',
      dateOfExpense: _formatDate(e['date']?.toString()),
      paidStatus: (e['isPaid'] as bool? ?? false) ? 'Paid' : 'Unpaid',
      description: e['description']?.toString() ?? '',
      attachments: attachments,
    );
  }

  // Fallback empty model
  static const ManagerExpenseDetailModel empty = ManagerExpenseDetailModel(
    id: '',
    repName: '',
    repRole: '',
    submittedDate: '',
    totalAmount: 0,
    status: ManagerExpenseStatus.pending,
    physicianClient: '',
    category: '',
    dateOfExpense: '',
    paidStatus: '',
    description: '',
    attachments: [],
  );
}

// ── Attachment model ──────────────────────────────────────────────────────────

class ExpenseDetailAttachment {
  final String fileName;
  final String url;
  final String size;
  final String date;
  final bool isPdf;

  const ExpenseDetailAttachment({
    required this.fileName,
    this.url = '',
    required this.size,
    required this.date,
    required this.isPdf,
  });
}
