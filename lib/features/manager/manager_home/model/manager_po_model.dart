enum ManagerPOStatus { all, complete, open, lost }

class ManagerPOModel {
  final String id;
  final String date;
  final String serialNumber;
  final String doctor;
  final String facility;
  final String typeLabel; // Commission / Consultation / Surgery
  final double commissionAmount;
  final double totalAmount;
  final ManagerPOStatus status;

  const ManagerPOModel({
    required this.id,
    required this.date,
    required this.serialNumber,
    required this.doctor,
    required this.facility,
    required this.typeLabel,
    required this.commissionAmount,
    required this.totalAmount,
    required this.status,
  });
}

class ManagerPODetailModel {
  final String poNumber;
  final String urgencyTag;
  final String title;
  final String patientId;
  final String facility;
  final String facilityEmail;
  final String dateOfSurgery;
  final String surgeryTime;
  final String surgeon;
  final String surgeonSpecialty;
  final String vendor;
  final String vendorEmail;
  final double totalAmount;
  final String? imageAsset;
  final List<POProductItem> products;
  final List<PODocumentItem> documents;
  final List<POTimelineItem> timeline;
  final String? repName;
  final String? repAvatarAsset;

  const ManagerPODetailModel({
    required this.poNumber,
    required this.urgencyTag,
    required this.title,
    required this.patientId,
    required this.facility,
    required this.facilityEmail,
    required this.dateOfSurgery,
    required this.surgeryTime,
    required this.surgeon,
    required this.surgeonSpecialty,
    required this.vendor,
    required this.vendorEmail,
    required this.totalAmount,
    this.imageAsset,
    required this.products,
    required this.documents,
    required this.timeline,
    this.repName,
    this.repAvatarAsset,
  });
}

class POProductItem {
  final String name;
  final String spec;
  final double price;

  const POProductItem({
    required this.name,
    required this.spec,
    required this.price,
  });
}

class PODocumentItem {
  final String fileName;
  final String size;
  final String date;
  final bool isPdf;

  const PODocumentItem({
    required this.fileName,
    required this.size,
    required this.date,
    required this.isPdf,
  });
}

enum POTimelineStatus { done, inProgress, pending }

class POTimelineItem {
  final String title;
  final String subtitle;
  final POTimelineStatus status;

  const POTimelineItem({
    required this.title,
    required this.subtitle,
    required this.status,
  });
}