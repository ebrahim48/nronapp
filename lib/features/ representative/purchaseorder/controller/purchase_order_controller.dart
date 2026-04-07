import 'package:get/get.dart';

import '../model/purchase_order_model.dart';

class PurchaseOrderController extends GetxController {
  final searchQuery = ''.obs;
  final selectedFilter = POStatus.all.obs;

  final allOrders = <PurchaseOrderModel>[
    PurchaseOrderModel(
      poNumber: '#PO-90210',
      date: 'Feb 15, 2026',
      surgeon: 'Dr. Robert Smith',
      facility: 'City Hospital',
      totalAmount: 4200.00,
      status: POStatus.complete,
    ),
    PurchaseOrderModel(
      poNumber: '#PO-90210',
      date: 'Feb 15, 2026',
      surgeon: 'Dr. Robert Smith',
      facility: 'City Hospital',
      totalAmount: 4200.00,
      status: POStatus.sent,
    ),
    PurchaseOrderModel(
      poNumber: '#PO-90210',
      date: 'Feb 15, 2026',
      surgeon: 'Dr. Robert Smith',
      facility: 'City Hospital',
      totalAmount: 4200.00,
      status: POStatus.open,
    ),
    PurchaseOrderModel(
      poNumber: '#PO-90210',
      date: 'Feb 15, 2026',
      surgeon: 'Dr. Robert Smith',
      facility: 'City Hospital',
      totalAmount: 4200.00,
      status: POStatus.complete,
    ),
  ].obs;

  List<PurchaseOrderModel> get filteredOrders {
    List<PurchaseOrderModel> result = allOrders;

    if (selectedFilter.value != POStatus.all) {
      result = result.where((o) => o.status == selectedFilter.value).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      result = result.where((o) =>
      o.poNumber.toLowerCase().contains(q) ||
          o.surgeon.toLowerCase().contains(q) ||
          o.facility.toLowerCase().contains(q)).toList();
    }

    return result;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void onFilterSelected(POStatus status) {
    selectedFilter.value = status;
  }

  void createPO() {

  }
}