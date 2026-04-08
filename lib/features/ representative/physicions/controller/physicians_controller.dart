import 'package:get/get.dart';

class PhysicianItem {
  final String id;
  final String name;
  final String specialty;
  final String facility;
  final String imagePath;

  PhysicianItem({
    required this.id,
    required this.name,
    required this.specialty,
    required this.facility,
    required this.imagePath,
  });
}

class PhysiciansController extends GetxController {
  final searchQuery = ''.obs;

  final physicians = <PhysicianItem>[
    PhysicianItem(
      id: '1',
      name: 'Dr. John Smith',
      specialty: 'Orthopedic Surgeon',
      facility: 'City Hospital',
      imagePath: 'assets/images/physicionprofile.jpg',
    ),
    PhysicianItem(
      id: '2',
      name: 'Dr. John Smith',
      specialty: 'Orthopedic Surgeon',
      facility: 'City Hospital',
      imagePath: 'assets/images/physicionprofile.jpg',
    ),
    PhysicianItem(
      id: '3',
      name: 'Dr. Emily Johnson',
      specialty: 'Pediatrician',
      facility: 'Greenwood Clinic',
      imagePath: 'assets/images/physicionprofile.jpg',
    ),
    PhysicianItem(
      id: '4',
      name: 'Dr. Emily Johnson',
      specialty: 'Pediatrician',
      facility: 'Greenwood Clinic',
      imagePath: 'assets/images/physicionprofile.jpg',
    ),
  ].obs;

  List<PhysicianItem> get filtered {
    if (searchQuery.value.isEmpty) return physicians;
    return physicians.where((p) =>
    p.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        p.facility.toLowerCase().contains(searchQuery.value.toLowerCase())
    ).toList();
  }

  void onSearch(String v) => searchQuery.value = v;

  void deletePhysician(String id) {
    physicians.removeWhere((p) => p.id == id);
  }
}