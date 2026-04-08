enum CommissionStatus { pending, paid, overdue, approved }

class CommissionModel {
  final String id;
  final String saleId;
  final String facility;
  final double amount;
  final CommissionStatus status;
  final String dateLabel; 

  const CommissionModel({
    required this.id,
    required this.saleId,
    required this.facility,
    required this.amount,
    required this.status,
    required this.dateLabel,
  });
}

class CommissionDetailModel {
  final String saleId;
  final CommissionStatus status;
  final String loggedDate;
  final String? imageAsset;
  final String productName;
  final String surgeon;
  final String facility;
  final String procedureDate;
  final double saleAmount;
  final double commissionRate;
  final double yourCommission;
  final String quickBooksRef;
  final String quickBooksSyncTime;

  const CommissionDetailModel({
    required this.saleId,
    required this.status,
    required this.loggedDate,
    this.imageAsset,
    required this.productName,
    required this.surgeon,
    required this.facility,
    required this.procedureDate,
    required this.saleAmount,
    required this.commissionRate,
    required this.yourCommission,
    required this.quickBooksRef,
    required this.quickBooksSyncTime,
  });
}

class CommissionHistoryGroup {
  final String dateLabel;
  final List<CommissionModel> items;

  const CommissionHistoryGroup({
    required this.dateLabel,
    required this.items,
  });
}

class TrendPoint {
  final String month;
  final double value;

  const TrendPoint({required this.month, required this.value});
}