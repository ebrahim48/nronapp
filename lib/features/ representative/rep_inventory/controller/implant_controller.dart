import 'package:flutter/material.dart';

import '../model/implant_model.dart';

class ImplantsController extends ChangeNotifier {
  String searchQuery = '';
  int selectedTabIndex = 0; // 0=Implants, 1=Trays, 2=Bio

  final List<ImplantModel> implants = [
    ImplantModel(
      id: '1',
      serialNumber: 'SN-9823471',
      name: 'Shoulder Implant',
      lotNumber: '#SHO456',
      material: 'Polyethylene',
      systemType: 'Orthopedic System X',
      vendor: 'MedTech Corp',
      status: 'available',
      facility: 'Advanced Care Clinic',
      recipientEmail: 'Adr.smith@cityhosp.org',
      additionalNote:
      'Lunch meeting with Dr. Smith to discuss the new pharmaceutical lineup and distribution schedule for the downtown clinic.',
      uploadedFiles: [
        ImplantFile(
          fileName: 'PO_889_Final.pdf',
          size: '1.2 MB',
          date: 'FEB 15',
          category: 'inbound_image',
        ),
        ImplantFile(
          fileName: 'PO_889_Final.pdf',
          size: '1.2 MB',
          date: 'FEB 15',
          category: 'broken_instruments',
        ),
      ],
    ),
    ImplantModel(
      id: '2',
      serialNumber: 'SN-9823472',
      name: 'Shoulder Implant',
      lotNumber: '#SHO456',
      material: 'Polyethylene',
      systemType: 'Orthopedic System X',
      vendor: 'MedTech Corp',
      status: 'available',
      facility: 'Advanced Care Clinic',
      recipientEmail: 'Adr.smith@cityhosp.org',
    ),
    ImplantModel(
      id: '3',
      serialNumber: 'SN-KNE789',
      name: 'Knee Replacement',
      lotNumber: '#KNE789',
      material: 'Titanium',
      systemType: 'Orthopedic System X',
      vendor: 'MedTech Corp',
      status: 'in_stock',
      facility: 'Ortho Health Center',
      recipientEmail: '',
    ),
    ImplantModel(
      id: '4',
      serialNumber: 'SN-HIP123',
      name: 'Hip Prosthesis',
      lotNumber: '#HIP123',
      material: 'Ceramic',
      systemType: 'Hip System Pro',
      vendor: 'MedTech Corp',
      status: 'shipped',
      facility: 'Joint Rehabilitation Center',
      recipientEmail: '',
    ),
  ];

  List<ImplantModel> get filtered {
    return implants.where((i) {
      final q = searchQuery.toLowerCase();
      return q.isEmpty ||
          i.name.toLowerCase().contains(q) ||
          i.serialNumber.toLowerCase().contains(q) ||
          i.lotNumber.toLowerCase().contains(q);
    }).toList();
  }

  void setSearch(String q) {
    searchQuery = q;
    notifyListeners();
  }

  void setTab(int i) {
    selectedTabIndex = i;
    notifyListeners();
  }

  void deleteImplant(String id) {
    implants.removeWhere((i) => i.id == id);
    notifyListeners();
  }
}