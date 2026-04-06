import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendTrayController extends GetxController {
  final facilityController = TextEditingController();
  final recipientNameController = TextEditingController();
  final recipientEmailController = TextEditingController();
  final additionalNotesController = TextEditingController();

  final systemTypeIndex = 0.obs;


  final selectedPhoto = Rxn<File>();

  final facilityOptions = [
    'City Hospital',
    'Ortho Health Center',
    'Advanced Care Clinic',
    'Joint Rehabilitation Center',
  ];

  void selectSystemType(int i) => systemTypeIndex.value = i;

  void pickPhoto() {

  }

  void sendTray() {

  }

  @override
  void onClose() {
    facilityController.dispose();
    recipientNameController.dispose();
    recipientEmailController.dispose();
    additionalNotesController.dispose();
    super.onClose();
  }
}