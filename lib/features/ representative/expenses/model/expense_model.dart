enum ExpenseStatus { all, pending, approved, rejected }

class ExpenseModel {
  final String id;
  final String title;
  final String doctor;
  final String date;
  final double amount;
  final ExpenseStatus status;
  final String? thumbnailAsset;

  // Detail fields
  final String? physicianClient;
  final String? category;
  final String? dateOfExpense;
  final String? paidStatus;
  final String? description;
  final List<ExpenseAttachment> attachments;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.doctor,
    required this.date,
    required this.amount,
    required this.status,
    this.thumbnailAsset,
    this.physicianClient,
    this.category,
    this.dateOfExpense,
    this.paidStatus,
    this.description,
    this.attachments = const [],
  });
}

class ExpenseAttachment {
  final String fileName;
  final String size;
  final String date;
  final bool isPdf;

  const ExpenseAttachment({
    required this.fileName,
    required this.size,
    required this.date,
    required this.isPdf,
  });
}