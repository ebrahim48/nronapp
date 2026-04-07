enum POStatus { all, open, lost, complete, sent }

class PurchaseOrderModel {
  final String poNumber;
  final String date;
  final String surgeon;
  final String facility;
  final double totalAmount;
  final POStatus status;

  PurchaseOrderModel({
    required this.poNumber,
    required this.date,
    required this.surgeon,
    required this.facility,
    required this.totalAmount,
    required this.status,
  });
}