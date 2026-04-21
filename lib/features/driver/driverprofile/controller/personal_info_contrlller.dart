import 'package:flutter/material.dart';

class PersonalInfoController extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController =
  TextEditingController(text: 'Abdullah Al Jamil');
  final TextEditingController addressController =
  TextEditingController(text: '***********');
  final TextEditingController phoneController =
  TextEditingController(text: '12345678910');
  final TextEditingController dobController = TextEditingController();
  final TextEditingController bioController =
  TextEditingController(text: 'dgshbsfdnbfdnfdn vfgbn');

  String selectedGender = 'Male';
  final List<String> genders = ['Male', 'Female', 'Other'];

  bool isLoading = false;

  int get bioCharCount => bioController.text.length;

  void setGender(String value) {
    selectedGender = value;
    notifyListeners();
  }

  Future<bool> saveProfile() async {
    if (!(formKey.currentState?.validate() ?? false)) return false;
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    isLoading = false;
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    fullNameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    dobController.dispose();
    bioController.dispose();
    super.dispose();
  }
}