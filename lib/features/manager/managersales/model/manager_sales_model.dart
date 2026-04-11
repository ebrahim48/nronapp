enum ManagerSaleStatus { allSales, pending, paid }

class ManagerSaleModel {
  final String id;
  final String facility;
  final String saleTypeLabel;
  final String surgeon;
  final double totalBill;
  final ManagerSaleStatus status;

  const ManagerSaleModel({
    required this.id,
    required this.facility,
    required this.saleTypeLabel,
    required this.surgeon,
    required this.totalBill,
    required this.status,
  });
}

class ManagerSaleDetailModel {
  final String saleNumber;
  final String repName;
  final String transactionStatus;
  final String saleType;
  final String doctor;
  final String facility;
  final String procedureDate;
  final String vendor;
  final String poNumber;
  final double totalBill;
  final double commission;
  final double commissionPercent;
  final List<SaleInventoryItem> inventoryItems;
  final List<SaleRepSplit> repSplits;
  final double totalCommissionPool;
  final List<SaleAttachmentItem> attachments;
  final bool billVerificationStatus;
  final String note;

  const ManagerSaleDetailModel({
    required this.saleNumber,
    required this.repName,
    required this.transactionStatus,
    required this.saleType,
    required this.doctor,
    required this.facility,
    required this.procedureDate,
    required this.vendor,
    required this.poNumber,
    required this.totalBill,
    required this.commission,
    required this.commissionPercent,
    required this.inventoryItems,
    required this.repSplits,
    required this.totalCommissionPool,
    required this.attachments,
    required this.billVerificationStatus,
    required this.note,
  });
}

class SaleInventoryItem {
  final String name;
  final String serial;
  final String tag;

  const SaleInventoryItem({
    required this.name,
    required this.serial,
    required this.tag,
  });
}

class SaleRepSplit {
  final String name;
  final int splitPercent;

  const SaleRepSplit({
    required this.name,
    required this.splitPercent,
  });
}

class SaleAttachmentItem {
  final String fileName;
  final String size;
  final String date;
  final bool isPdf;

  const SaleAttachmentItem({
    required this.fileName,
    required this.size,
    required this.date,
    required this.isPdf,
  });
}