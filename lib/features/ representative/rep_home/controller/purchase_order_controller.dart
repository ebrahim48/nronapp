import 'package:get/get.dart';

class PurchaseOrderController extends GetxController {
  final activeTab = 0.obs;
  final tabs = ['All', 'Pending', 'Completed'];

  final allOrders = <Map<String, dynamic>>[
    {
      'poNumber': 'PO-2025-001',
      'date': '15 Jan 2025',
      'status': 'Pending',
      'items': 12,
      'total': '\$4,250.00',
      'location': 'City Hospital',
    },
    {
      'poNumber': 'PO-2025-002',
      'date': '12 Jan 2025',
      'status': 'Completed',
      'items': 8,
      'total': '\$2,180.00',
      'location': 'St. Mary Medical Center',
    },
    {
      'poNumber': 'PO-2025-003',
      'date': '10 Jan 2025',
      'status': 'Pending',
      'items': 15,
      'total': '\$6,320.00',
      'location': 'General Health Clinic',
    },
    {
      'poNumber': 'PO-2025-004',
      'date': '08 Jan 2025',
      'status': 'Completed',
      'items': 5,
      'total': '\$1,450.00',
      'location': 'Metro Surgical Center',
    },
  ].obs;

  List<Map<String, dynamic>> get orders {
    if (activeTab.value == 0) return allOrders;
    final status = tabs[activeTab.value];
    return allOrders.where((o) => o['status'] == status).toList();
  }

  void selectTab(int index) => activeTab.value = index;
}
