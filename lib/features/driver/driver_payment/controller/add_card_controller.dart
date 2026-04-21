import 'package:flutter/material.dart';

class AddCardController extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expireDateController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();

  String? selectedCountry;
  bool isLoading = false;
  bool showSuccess = false;

  final List<String> countries = [
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'Germany',
    'France',
    'Bangladesh',
    'India',
  ];

  void setCountry(String? value) {
    selectedCountry = value;
    notifyListeners();
  }

  bool get isVisa => cardNumberController.text.startsWith('4');
  bool get isMaster =>
      cardNumberController.text.startsWith('5') ||
          cardNumberController.text.startsWith('2');

  void onCardNumberChanged(String value) {
    notifyListeners();
  }

  Future<bool> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return false;
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    isLoading = false;
    showSuccess = true;
    notifyListeners();
    return true;
  }

  void dismissSuccess() {
    showSuccess = false;
    notifyListeners();
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    expireDateController.dispose();
    cvcController.dispose();
    super.dispose();
  }
}