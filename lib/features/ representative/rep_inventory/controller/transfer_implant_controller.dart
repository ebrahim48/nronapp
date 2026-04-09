import 'package:flutter/material.dart';

class TransferImplantController extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController fromController =
  TextEditingController(text: 'Warehouse A - Shelf 4');
  final TextEditingController toController =
  TextEditingController(text: 'Warehouse A - Shelf 4');
  final TextEditingController reasonController = TextEditingController();

  bool isLoading = false;

  Future<bool> requestTransfer() async {
    if (!(formKey.currentState?.validate() ?? false)) return false;
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    isLoading = false;
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    reasonController.dispose();
    super.dispose();
  }
}