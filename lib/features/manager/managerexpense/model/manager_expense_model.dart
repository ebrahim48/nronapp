enum ManagerExpenseStatus { all, pending, approved, rejected }

class ManagerExpenseModel {
  final String id;
  final String title;
  final String categoryTag;
  final String typeTag;
  final String date;
  final double amount;
  final ManagerExpenseStatus status;
  final String repInitials;
  final String repName;

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
  });
}

class ManagerExpenseDetailModel {
  final String repName;
  final String repRole;
  final String submittedDate;
  final String? repAvatarAsset;
  final double totalAmount;
  final ManagerExpenseStatus status;
  final String physicianClient;
  final String category;
  final String dateOfExpense;
  final String paidStatus;
  final String description;
  final List<ExpenseDetailAttachment> attachments;

  const ManagerExpenseDetailModel({
    required this.repName,
    required this.repRole,
    required this.submittedDate,
    this.repAvatarAsset,
    required this.totalAmount,
    required this.status,
    required this.physicianClient,
    required this.category,
    required this.dateOfExpense,
    required this.paidStatus,
    required this.description,
    required this.attachments,
  });
}

class ExpenseDetailAttachment {
  final String fileName;
  final String size;
  final String date;
  final bool isPdf;

  const ExpenseDetailAttachment({
    required this.fileName,
    required this.size,
    required this.date,
    required this.isPdf,
  });
}