import 'package:flutter/material.dart';

import '../model/profile_model.dart';

class DocumentsController extends ChangeNotifier {
  List<DocumentItemModel> documents = [
    const DocumentItemModel(
      id: 'nid',
      title: 'NID/Tax ID',
      imageAsset: 'assets/images/nid.png',
      status: DocumentStatus.uploaded,
    ),
    const DocumentItemModel(
      id: 'driving_license',
      title: 'Driving License',
      imageAsset: 'assets/images/drivinglicense.png',
      status: DocumentStatus.notUploaded,
    ),
    const DocumentItemModel(
      id: 'driver_car',
      title: 'Driver & Car Picture',
      imageAsset: 'assets/images/drivercar.png',
      status: DocumentStatus.notUploaded,
    ),
  ];

  bool isLoading = false;

  void markUploaded(String id) {
    final index = documents.indexWhere((d) => d.id == id);
    if (index == -1) return;
    documents[index] = DocumentItemModel(
      id: documents[index].id,
      title: documents[index].title,
      imageAsset: documents[index].imageAsset,
      status: DocumentStatus.uploaded,
    );
    notifyListeners();
  }

  bool get allUploaded =>
      documents.every((d) => d.status == DocumentStatus.uploaded);

  Future<void> submit() async {
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    isLoading = false;
    notifyListeners();
  }
}