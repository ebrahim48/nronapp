import 'package:get/get.dart';

import '../model/commission_model.dart';


class CommissionController extends GetxController {
  final totalSales = 100.0.obs;
  final thisMonth = 160.0.obs;
  final pendingPayment = 20.0.obs;
  final paid = 60.0.obs;

  final selectedFilter = CommissionStatus.pending.obs;
  final Rx<CommissionStatus?> historyFilter = Rx<CommissionStatus?>(null);

  final trendPoints = const <TrendPoint>[
    TrendPoint(month: 'Jan', value: 0),
    TrendPoint(month: 'Feb', value: 20),
    TrendPoint(month: 'Mar', value: 10),
    TrendPoint(month: 'Apr', value: 40),
    TrendPoint(month: 'May', value: 15),
    TrendPoint(month: 'Jun', value: 5),
  ];

  final recentCommissions = <CommissionModel>[
    CommissionModel(
      id: '1',
      saleId: '#S1024',
      facility: 'City Hospital',
      amount: 420.00,
      status: CommissionStatus.pending,
      dateLabel: 'Due Oct 12',
    ),
    CommissionModel(
      id: '2',
      saleId: '#S1024',
      facility: 'Northside Medical',
      amount: 1250.00,
      status: CommissionStatus.paid,
      dateLabel: 'Sep 28',
    ),
    CommissionModel(
      id: '3',
      saleId: '#S1025',
      facility: 'Greenwood Clinic',
      amount: 800.00,
      status: CommissionStatus.overdue,
      dateLabel: 'Due Sep 15',
    ),
    CommissionModel(
      id: '4',
      saleId: '#S1026',
      facility: 'Lakeside Hospital',
      amount: 620.00,
      status: CommissionStatus.pending,
      dateLabel: 'Due Oct 5',
    ),
  ].obs;

  final allHistoryGroups = <CommissionHistoryGroup>[
    CommissionHistoryGroup(
      dateLabel: 'Today',
      items: [
        CommissionModel(
          id: 'h1',
          saleId: '#S1024',
          facility: 'City Hospital',
          amount: 420.00,
          status: CommissionStatus.pending,
          dateLabel: 'Due Oct 12',
        ),
        CommissionModel(
          id: 'h2',
          saleId: '#S1024',
          facility: 'Northside Medical',
          amount: 1250.00,
          status: CommissionStatus.paid,
          dateLabel: 'Sep 28',
        ),
        CommissionModel(
          id: 'h3',
          saleId: '#S1025',
          facility: 'Greenwood Clinic',
          amount: 800.00,
          status: CommissionStatus.approved,
          dateLabel: 'Due Sep 15',
        ),
      ],
    ),
    CommissionHistoryGroup(
      dateLabel: '26 February 2026',
      items: [
        CommissionModel(
          id: 'h4',
          saleId: '#S1024',
          facility: 'City Hospital',
          amount: 420.00,
          status: CommissionStatus.pending,
          dateLabel: 'Due Oct 12',
        ),
        CommissionModel(
          id: 'h5',
          saleId: '#S1024',
          facility: 'Northside Medical',
          amount: 1250.00,
          status: CommissionStatus.paid,
          dateLabel: 'Sep 28',
        ),
        CommissionModel(
          id: 'h6',
          saleId: '#S1025',
          facility: 'Greenwood Clinic',
          amount: 800.00,
          status: CommissionStatus.overdue,
          dateLabel: 'Due Sep 15',
        ),
      ],
    ),
  ].obs;


  final commissionDetail = const CommissionDetailModel(
    saleId: '#S1024',
    status: CommissionStatus.pending,
    loggedDate: 'Oct 24, 2023',
    imageAsset: 'assets/images/knee_prosthesis.png',
    productName: 'Knee Prosthesis',
    surgeon: 'Dr. Lee',
    facility: 'City Hospital',
    procedureDate: 'Oct 24, 2023',
    saleAmount: 4200.00,
    commissionRate: 10,
    yourCommission: 420.00,
    quickBooksRef: 'QB-992834',
    quickBooksSyncTime: '10 mins ago',
  );


  List<CommissionHistoryGroup> get filteredGroups {
    if (historyFilter.value == null) return allHistoryGroups;
    return allHistoryGroups
        .map((g) => CommissionHistoryGroup(
      dateLabel: g.dateLabel,
      items: g.items
          .where((i) => i.status == historyFilter.value)
          .toList(),
    ))
        .where((g) => g.items.isNotEmpty)
        .toList();
  }

  void setHistoryFilter(CommissionStatus? status) {
    historyFilter.value = status;
  }
}