import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../features/ representative/activity/presentation/activity-log_screen.dart';
import '../../../features/ representative/all_surgeries/presentation/add_surgery_screen.dart';
import '../../../features/ representative/all_surgeries/presentation/allsurgeries_screen.dart';
import '../../../features/ representative/all_surgeries/presentation/surgery_details_screen.dart';
import '../../../features/ representative/commissions/presentation/commissions__screen.dart';
import '../../../features/ representative/commissions/presentation/commissions_history_screen.dart';
import '../../../features/ representative/commissions/presentation/commission_detail_screen.dart';
import '../../../features/ representative/expenses/presentation/create_expense_screen.dart';
import '../../../features/ representative/expenses/presentation/expense_details_screen.dart';
import '../../../features/ representative/expenses/presentation/expense_success_screen.dart';
import '../../../features/ representative/expenses/presentation/expenses_screen.dart';
import '../../../features/ representative/physicions/presentation/physicions_profile_screen.dart';
import '../../../features/ representative/physicions/presentation/physicions_screen.dart';
import '../../../features/ representative/purchaseorder/presentation/purchase_order_screen.dart';
import '../../../features/ representative/rep_bottomnavbar/rep_bottomNavbar_screen.dart';
import '../../../features/ representative/rep_home/create_purchase_order_screen.dart';
import '../../../features/ representative/rep_home/presentation/add_products_screen.dart';
import '../../../features/ representative/rep_home/presentation/bulk_purchase_screen.dart';
import '../../../features/ representative/rep_home/presentation/new_po_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/add_bio_inventory_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/details_bio_inventory_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/missing_instrument_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/receive_tray_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/report_success_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/send_tray_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/new_tray_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/rep_inventory_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/tray_details_screen.dart';
import '../../../features/ representative/rep_qrscan/rep_qr_scan_screen.dart';
import '../../../features/ representative/sales/add_representative_screen.dart';
import '../../../features/ representative/sales/create_sales_screen.dart';
import '../../../features/ representative/sales/packing_slip_screen.dart';
import '../../../features/ representative/sales/sales_details_screen.dart';
import '../../../features/ representative/sales/sales_screen.dart';
import '../../../features/ representative/sales/select_implants_screen.dart';
import '../../../features/ representative/settingsprofile/presentation/contact_support_screen.dart';
import '../../../features/ representative/settingsprofile/presentation/others_screen.dart';
import '../../../features/ representative/settingsprofile/presentation/privacy_policy_screen.dart';
import '../../../features/ representative/settingsprofile/presentation/profile_screen.dart';
import '../../../features/ representative/settingsprofile/presentation/settings_profile_screen.dart';
import '../../../features/ representative/shipment/presentation/shipment_screen.dart';
import '../../../features/auth/forget/forget_screen.dart';
import '../../../features/auth/presentation/screens/signin_screen.dart';
import '../../../features/auth/presentation/signup_screen.dart';
import '../../../features/auth/reset/reset_password_screen.dart';
import '../../../features/auth/verify/verify_screen.dart';
import '../../../features/onboarding/presentation/onboarding_screen.dart';
import '../../../features/role_selection/presentation/role_selection_screen.dart';
import '../../../features/splash/presentation/splash_screen.dart';
import '../../../features/ representative/rep_home/presentation/representative_home_screen.dart';

class AppRoutes {
  static const String splashScreen = "/splashScreen";
  static const String onboardingScreen = "/onboardingScreen";
  static const String roleSelection = "/roleSelection";
  static const String representativeHome = "/representativeHome";
  static const String signUpScreen = "/signUpScreen";
  static const String signInScreen = "/signInScreen";
  static const String forgetPasswordScreen = "/forgetPasswordScreen";
  static const String verifyScreen = "/verifyScreen";
  static const String resetPasswordScreen = "/resetPasswordScreen";
  static const String repBottomNavBar = "/repBottomNavBar";
  static const String qrScanScreen = "/qrScanScreen";
  static const String newPoScreen = "/newPoScreen";
  static const String createPurchaseScreen = "/createPurchaseScreen";
  static const String bulkPurchaseScreen = "/bulkPurchaseScreen";
  static const String addProductScreen = "/addProductScreen";
  static const String purchaseOrderScreen = "/purchaseOrderScreen";
  static const String inventoryScreen = "/inventoryScreen";
  static const String newTrayScreen = "/newTrayScreen";
  static const String trayDetailsScreen = "/trayDetailsScreen";
  static const String sendTrayScreen = "/sendTrayScreen";
  static const String receiveTrayScreen = "/receiveTrayScreen";
  static const String missingInstrumentScreen = "/missingInstrumentScreen";
  static const String reportSuccessScreen = "/reportSuccessScreen";
  static const String addBioInventoryScreen = "/addBioInventoryScreen";
  static const String detailsBioInventoryScreen = "/detailsBioInventoryScreen";
  static const String createExpenseScreen = "/createExpenseScreen";
  static const String expenseSuccessScreen = "/expenseSuccessScreen";
  static const String expensesScreen = "/expensesScreen";
  static const String expenseDetailScreen = "/expenseDetailScreen";

  static const salesScreen = '/sales';
  static const createSaleScreen = '/create-sale';
  static const selectImplantsScreen = '/select-implants';
  static const saleDetailScreen = '/sale-detail';
  static const addRepresentativeScreen = '/add-representative';
  static const packingSlipScreen = '/packing-slip';
static const commissionScreen = '/commission';
static const commissionHistoryScreen = '/commission-history';
static const commissionDetailScreen = '/commission-detail';
static const shipmentsScreen = '/shipmentsScreen';
static const physiciansScreen = '/physiciansScreen';
static const physicianProfileScreen = '/physicianProfileScreen';

static const allSurgeriesScreen = '/all-surgeries';
static const addSurgeryScreen = '/add-surgery';
static const surgeryDetailScreen = '/surgery-detail';
static const activityLogScreen = '/activityLogScreen';

  static const settingProfileScreen = '/setting-profile';
  static const profileScreen = '/profile';
  static const contactSupportScreen = '/contact-support';
  static const othersScreen = '/others';
  static const privacyPolicyScreen = '/privacy-policy';




  static final GoRouter goRouter = GoRouter(
    initialLocation: splashScreen,
    redirect: (context, state) async {
      return null;
    },
    routes: [
      GoRoute(
        path: splashScreen,
        name: splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: onboardingScreen,
        name: onboardingScreen,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: roleSelection,
        name: roleSelection,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: signUpScreen,
        name: signUpScreen,
        builder: (context, state) =>  SignUpScreen(),
      ),
      GoRoute(
        path: signInScreen,
        name: signInScreen,
        builder: (context, state) =>  const SignInScreen(),
      ),
      GoRoute(
        path: forgetPasswordScreen,
        name: forgetPasswordScreen,
        builder: (context, state) =>  ForgetPasswordScreen(),
      ),
      GoRoute(
        path: verifyScreen,
        name: verifyScreen,
        builder: (context, state) =>  VerifyScreen(),
      ),
      GoRoute(
        path: resetPasswordScreen,
        name: resetPasswordScreen,
        builder: (context, state) =>  ResetPasswordScreen(),
      ),
      GoRoute(
        path: representativeHome,
        name: representativeHome,
        builder: (context, state) => const RepresentativeHomeScreen(),
      ),
      GoRoute(
        path: repBottomNavBar,
        name: repBottomNavBar,
        builder: (context, state) => const RepBottomNavBar(),
      ),
      GoRoute(
        path: qrScanScreen,
        name: qrScanScreen,
        builder: (context, state) => const QrScanScreen(),
      ),
      GoRoute(
        path: newPoScreen,
        name: newPoScreen,
        builder: (context, state) => const NewPoScreen(),
      ),
      GoRoute(
        path: createPurchaseScreen,
        name: createPurchaseScreen,
        builder: (context, state) => const CreatePurchaseScreen(),
      ),
      GoRoute(
        path: bulkPurchaseScreen,
        name: bulkPurchaseScreen,
        builder: (context, state) => const BulkPurchaseScreen(),
      ),
      GoRoute(
        path: addProductScreen,
        name: addProductScreen,
        builder: (context, state) => const AddProductScreen(),
      ),
      GoRoute(
        path: purchaseOrderScreen,
        name: purchaseOrderScreen,
        builder: (context, state) => const PurchaseOrderScreen(),
      ),
      GoRoute(
        path: inventoryScreen,
        name: inventoryScreen,
        builder: (context, state) => const InventoryScreen(),
      ),
      GoRoute(
        path: newTrayScreen,
        name: newTrayScreen,
        builder: (context, state) => const NewTrayScreen(),
      ),
      GoRoute(
        path: trayDetailsScreen,
        name: trayDetailsScreen,
        builder: (context, state) => const TrayDetailsScreen(),
      ),
      GoRoute(
        path: sendTrayScreen,
        name: sendTrayScreen,
        builder: (context, state) => const SendTrayScreen(),
      ),
      GoRoute(
        path: receiveTrayScreen,
        name: receiveTrayScreen,
        builder: (context, state) => const ReceiveTrayScreen(),
      ),
      GoRoute(
        path: missingInstrumentScreen,
        name: missingInstrumentScreen,
        builder: (context, state) => const MissingInstrumentScreen(),
      ),
      GoRoute(
        path: addBioInventoryScreen,
        name: addBioInventoryScreen,
        builder: (context, state) => const AddBioInventoryScreen(),
      ),
      GoRoute(
        path: detailsBioInventoryScreen,
        name: detailsBioInventoryScreen,
        builder: (context, state) => const DetailsBioInventoryScreen(),
      ),
      GoRoute(
        path: reportSuccessScreen,
        name: reportSuccessScreen,
        builder: (context, state) => const ReportSuccessScreen(),
      ),
      GoRoute(
        path: createExpenseScreen,
        name: createExpenseScreen,
        builder: (context, state) => const CreateExpenseScreen(),
      ),
      GoRoute(
        path: expenseSuccessScreen,
        name: expenseSuccessScreen,
        builder: (context, state) => const ExpenseSuccessScreen(),
      ),
      GoRoute(
        path: expensesScreen,
        name: expensesScreen,
        builder: (context, state) => const ExpensesScreen(),
      ),
      GoRoute(
        path: salesScreen,
        name: salesScreen,
        builder: (context, state) => const SalesScreen(),
      ),
      GoRoute(
        path: createSaleScreen,
        name: createSaleScreen,
        builder: (context, state) => const CreateSaleScreen(),
      ),
      GoRoute(
        path: selectImplantsScreen,
        name: selectImplantsScreen,
        builder: (context, state) => const SelectImplantsScreen(),
      ),
      GoRoute(
        path: saleDetailScreen,
        name: saleDetailScreen,
        builder: (context, state) => const SaleDetailScreen(),
      ),
      GoRoute(
        path: addRepresentativeScreen,
        name: addRepresentativeScreen,
        builder: (context, state) => const AddRepresentativeScreen(),
      ),
      GoRoute(
        path: packingSlipScreen,
        name: packingSlipScreen,
        builder: (context, state) => const PackingSlipScreen(),
      ),
      GoRoute(
        path: commissionScreen,
        name: commissionScreen,
        builder: (context, state) => const CommissionScreen(),
      ),
      GoRoute(
        path: commissionHistoryScreen,
        name: commissionHistoryScreen,
        builder: (context, state) => const CommissionHistoryScreen(),
      ),
      GoRoute(
        path: commissionDetailScreen,
        name: commissionDetailScreen,
        builder: (context, state) => const CommissionDetailScreen(),
      ),
      GoRoute(
        path: shipmentsScreen,
        name: shipmentsScreen,
        builder: (context, state) => const ShipmentsScreen(),
      ),
      GoRoute(
        path: physiciansScreen,
        name: physiciansScreen,
        builder: (context, state) => const PhysiciansScreen(),
      ),
      GoRoute(
        path: allSurgeriesScreen,
        name: allSurgeriesScreen,
        builder: (context, state) => const AllSurgeriesScreen(),
      ),
      GoRoute(
        path: addSurgeryScreen,
        name: addSurgeryScreen,
        builder: (context, state) => const AddSurgeryScreen(),
      ),
      GoRoute(
        path: surgeryDetailScreen,
        name: surgeryDetailScreen,
        builder: (context, state) => const SurgeryDetailScreen(),
      ),
      GoRoute(
        path: activityLogScreen,
        name: activityLogScreen,
        builder: (context, state) => const ActivityLogScreen(),
      ),
      GoRoute(
        path: profileScreen ,
        name: profileScreen ,
        builder: (context, state) => const ProfileScreen (),
      ),
      GoRoute(
        path: settingProfileScreen ,
        name: settingProfileScreen ,
        builder: (context, state) => const SettingProfileScreen (),
      ),
      GoRoute(
        path: contactSupportScreen  ,
        name: contactSupportScreen ,
        builder: (context, state) => const ContactSupportScreen  (),
      ),
      GoRoute(
        path: othersScreen   ,
        name: othersScreen ,
        builder: (context, state) => const OthersScreen   (),
      ),
      GoRoute(
        path: privacyPolicyScreen    ,
        name: privacyPolicyScreen  ,
        builder: (context, state) => const PrivacyPolicyScreen    (),
      ),
      // GoRoute(
      //   path: physicianProfileScreen,
      //   name: physicianProfileScreen,
      //   builder: (context, state) => const PhysicianProfileScreen(),
      // ),
    ],
  );

  static Page<dynamic> _customTransitionPage(
    Widget child,
    GoRouterState state,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
