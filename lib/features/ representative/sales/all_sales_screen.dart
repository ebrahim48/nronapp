import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import 'controller/sales_controller.dart';
import 'presentation/widgets/sales_list_card.dart';
import 'sales_details_screen.dart';

class AllSalesScreen extends StatefulWidget {
  const AllSalesScreen({super.key});

  @override
  State<AllSalesScreen> createState() => _AllSalesScreenState();
}

class _AllSalesScreenState extends State<AllSalesScreen>
    with SingleTickerProviderStateMixin {
  late final SaleController c;
  late final TabController _tabController;
  int _lastTabIndex = 0;

  final List<String> _tabLabels = ['All', 'Pending', 'Approved', 'Rejected'];
  final List<String> _tabFilters = ['', 'pending', 'approved', 'rejected'];

  @override
  void initState() {
    super.initState();
    c = Get.find<SaleController>();
    _tabController = TabController(length: _tabLabels.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    c.fetchAllSales(reset: true, filter: '');
  }

  void _onTabChanged() {
    final i = _tabController.index;
    if (i == _lastTabIndex) return; // listener fires twice per change
    _lastTabIndex = i;
    c.fetchAllSales(reset: true, filter: _tabFilters[i]);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        title: CustomText(
          text: 'All Sales',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(44.h),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: AppColors.primaryColor,
            indicatorWeight: 2.5,
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: AppColors.secondaryTextColor,
            labelStyle: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
            tabs: _tabLabels.map((label) => Tab(text: label)).toList(),
          ),
        ),
      ),
      body: Obx(() {
        if (c.isLoadingAllSales.value) {
          return const _ShimmerList();
        }
        if (c.allSalesList.isEmpty) {
          return Center(
            child: CustomText(
              text: 'No sales found.',
              fontsize: 14.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.center,
            ),
          );
        }
        return RefreshIndicator(
          color: AppColors.primaryColor,
          backgroundColor: const Color(0xFF1E2427),
          onRefresh: () => c.fetchAllSales(
              reset: true, filter: _tabFilters[_tabController.index]),
          child: ListView.builder(
            controller: c.allSalesScrollController,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            itemCount: c.allSalesList.length +
                (c.isLoadingMoreAllSales.value ? 1 : 0),
            itemBuilder: (ctx, i) {
              if (i == c.allSalesList.length) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                      strokeWidth: 2,
                    ),
                  ),
                );
              }
              final sale = c.allSalesList[i];
              return SaleListCard(
                sale: sale,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SaleDetailScreen(saleId: sale.id),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class _ShimmerList extends StatelessWidget {
  const _ShimmerList();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          height: 90.h,
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}
