import 'package:get/get.dart';

class TransferRequestItem {
  final String id;
  final String itemName;
  final String date;
  final String from;
  final String to;
  final String requestedBy;
  final String batch;
  final String status;

  const TransferRequestItem({
    required this.id,
    required this.itemName,
    required this.date,
    required this.from,
    required this.to,
    required this.requestedBy,
    required this.batch,
    required this.status,
  });
}

class ManagerTransferRequestsController extends GetxController {
  final filters = ['All', 'Pending', 'Approved', 'Rejected'];
  final selectedFilter = 'All'.obs;

  final requests = <TransferRequestItem>[
    TransferRequestItem(id: '1', itemName: 'Knee Prosthesis\n(Titanium)', date: 'Feb 18, 2024', from: 'Warehouse A', to: 'City Hospital (Central)', requestedBy: 'Sarah J. (Head Nurse)', batch: '#KP-2024-0012', status: 'Pending'),
    TransferRequestItem(id: '2', itemName: 'Knee Prosthesis\n(Titanium)', date: 'Feb 18, 2024', from: 'Warehouse A', to: 'City Hospital (Central)', requestedBy: 'Sarah J. (Head Nurse)', batch: '#KP-2024-0012', status: 'Pending'),
    TransferRequestItem(id: '3', itemName: 'Knee Prosthesis\n(Titanium)', date: 'Feb 18, 2024', from: 'Warehouse A', to: 'City Hospital (Central)', requestedBy: 'Sarah J. (Head Nurse)', batch: '#KP-2024-0012', status: 'Pending'),
  ].obs;

  List<TransferRequestItem> get filtered {
    if (selectedFilter.value == 'All') return requests;
    return requests.where((r) => r.status == selectedFilter.value).toList();
  }

  void selectFilter(String f) => selectedFilter.value = f;
  void approve(String id) {}
  void reject(String id) {}
}