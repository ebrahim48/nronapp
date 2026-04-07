enum SaleType { sold, consigned }

enum SaleStatus { approved, pending, rejected }

enum ImplantAvailability { available, inStock, backordered }

class SaleModel {
  final String id;
  final String saleNumber;
  final String facility;
  final String saleTypeLabel;
  final String surgeon;
  final double totalBill;
  final SaleStatus status;

  const SaleModel({
    required this.id,
    required this.saleNumber,
    required this.facility,
    required this.saleTypeLabel,
    required this.surgeon,
    required this.totalBill,
    required this.status,
  });
}

class SaleDetailModel {
  final String saleNumber;
  final String saleType;
  final String physician;
  final String facility;
  final String procedureDate;
  final String serialNumbers;
  final String vendor;
  final String ppoNumber;
  final List<InventoryItemModel> inventoryItems;
  final String classification;
  final List<RepSplitModel> repSplits;
  final double totalCommission;
  final List<AttachmentFileModel> attachments;
  final String note;
  final List<AuditTrailModel> auditTrail;

  const SaleDetailModel({
    required this.saleNumber,
    required this.saleType,
    required this.physician,
    required this.facility,
    required this.procedureDate,
    required this.serialNumbers,
    required this.vendor,
    required this.ppoNumber,
    required this.inventoryItems,
    required this.classification,
    required this.repSplits,
    required this.totalCommission,
    required this.attachments,
    required this.note,
    required this.auditTrail,
  });
}

class InventoryItemModel {
  final String name;
  final String serial;
  final String tag;

  const InventoryItemModel({
    required this.name,
    required this.serial,
    required this.tag,
  });
}

class RepSplitModel {
  final String name;
  final int splitPercent;

  const RepSplitModel({required this.name, required this.splitPercent});
}

class AuditTrailModel {
  final String title;
  final String subtitle;
  final String dateTime;
  final AuditType type;

  const AuditTrailModel({
    required this.title,
    required this.subtitle,
    required this.dateTime,
    required this.type,
  });
}

enum AuditType { success, info, warning }

class AttachmentFileModel {
  final String fileName;
  final String size;
  final String date;
  final bool isPdf;

  const AttachmentFileModel({
    required this.fileName,
    required this.size,
    required this.date,
    required this.isPdf,
  });
}

class ImplantItem {
  final String name;
  final String serial;
  final String material;
  final String location;
  final ImplantAvailability availability;
  bool isSelected;

  ImplantItem({
    required this.name,
    required this.serial,
    required this.material,
    required this.location,
    required this.availability,
    this.isSelected = false,
  });
}

class RepresentativeModel {
  final String name;
  final String role;
  final int commissionPercent;

  const RepresentativeModel({
    required this.name,
    required this.role,
    required this.commissionPercent,
  });
}

class PackingSlipItem {
  final String product;
  final String serial;
  final int qty;
  final double price;

  const PackingSlipItem({
    required this.product,
    required this.serial,
    required this.qty,
    required this.price,
  });
}