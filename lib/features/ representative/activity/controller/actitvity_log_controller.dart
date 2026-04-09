import 'package:get/get.dart';

enum ActivityType { inventory, sale, implant, billing }

class ActivityItem {
  final String id;
  final ActivityType type;
  final Map<String, dynamic> data;

  const ActivityItem({
    required this.id,
    required this.type,
    required this.data,
  });
}

class ActivityLogController extends GetxController {
  final modules = ['All', 'Sales', 'Inventory', 'Shipping'];
  final selectedModule = 'All'.obs;

  final ranges = ['Last 7 Days', 'Last 30 Days'];
  final selectedRange = 'Last 7 Days'.obs;

  final allItems = <ActivityItem>[
    ActivityItem(
      id: '1',
      type: ActivityType.inventory,
      data: {
        'title': 'Reagent A',
        'subtitle': 'Lot-1234',
        'date': '12/12/2026',
        'facility': 'Joint Rehabilitation Center',
      },
    ),
    ActivityItem(
      id: '2',
      type: ActivityType.sale,
      data: {
        'date': 'Mar 15, 2026',
        'status': 'Complete',
        'serial': 'SN: DEF98765',
        'doctor': 'Dr. Michael Lee',
        'facility': 'Downtown Medical Center',
        'surgeryAmount': '\$1,200.00',
        'totalAmount': '\$7,200.00',
      },
    ),
    // Implant card
    ActivityItem(
      id: '3',
      type: ActivityType.implant,
      data: {
        'name': 'Knee Replacement',
        'serial': '#KNE789',
        'material': 'Titanium',
        'status': 'In Stock',
        'facility': 'Ortho Health Center',
        'imagePath': 'assets/images/implant.png',
      },
    ),
    // Billing card
    ActivityItem(
      id: '4',
      type: ActivityType.billing,
      data: {
        'clinic': 'City Otho Clinic',
        'type': 'Implant',
        'status': 'Paid',
        'surgeon': 'Dr. Robert Chen',
        'totalBill': '\$12,450.00',
      },
    ),
  ].obs;

  List<ActivityItem> get filtered {
    var items = allItems.toList();
    if (selectedModule.value != 'All') {
      items = items.where((e) {
        switch (selectedModule.value) {
          case 'Sales':     return e.type == ActivityType.sale;
          case 'Inventory': return e.type == ActivityType.inventory || e.type == ActivityType.implant;
          default:          return true;
        }
      }).toList();
    }
    return items;
  }

  void selectModule(String m) => selectedModule.value = m;
  void selectRange(String r) => selectedRange.value = r;
}