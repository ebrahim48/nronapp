import 'package:get/get.dart';

class DetailsBioInventoryController extends GetxController {
  final Map<String, dynamic> item = {
    'name': 'Reagent A',
    'lotNumber': '1234',
    'quantity': '500 ml',
    'vendor': 'BioTech Supplies Inc.',
    'expiryDate': '12/12/2026',
    'location': 'Joint Rehabilitation Center',
    'status': 'In Stock',
    'notes':
        'Launch meeting with Dr. Smith to discuss the new pharmaceutical lineup and distribution schedule for the downtown clinic.',
  }.obs;
}
