import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../features/ representative/activity/presentation/activity-log_screen.dart';
import '../../../features/ representative/activity/presentation/activity_log_detail_screen.dart';
import '../../../features/ representative/activity/model/activity_log_model.dart';
import '../../../features/ representative/notification/presentation/notification_screen.dart';
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
import '../../../features/ representative/physicions/domain/model/physician_model.dart';
import '../../../features/ representative/physicions/presentation/physicions_profile_screen.dart';
import '../../../features/ representative/physicions/presentation/physicions_screen.dart';
import '../../../features/ representative/purchaseorder/presentation/purchase_order_detail_screen.dart';
import '../../../features/ representative/purchaseorder/presentation/purchase_order_screen.dart';
import '../../../features/ representative/rep_bottomnavbar/presentation/rep_bottomNavbar_screen.dart';
import '../../../features/ representative/rep_home/create_purchase_order_screen.dart';
import '../../../features/ representative/rep_home/presentation/bulk_purchase_screen.dart';
import '../../../features/ representative/rep_home/presentation/new_po_screen.dart';
import '../../../features/ representative/rep_home/presentation/update_purchase_screen.dart';
import '../../../features/ representative/rep_home/presentation/review_send_po_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/add_bio_inventory_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/edit_bio_inventory_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/add_implant_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/create_implant_sale_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/create_shipment_implant_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/details_bio_inventory_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/implants_details_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/implants_details_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/missing_instrument_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/missing_instruments_details_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/missing_instruments_history_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/receive_tray_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/receiving_session_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/report_success_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/send_tray_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/new_tray_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/edit_tray_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/rep_inventory_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/serialized_implants_screen.dart';
import '../../../features/ representative/rep_inventory/model/implant_model.dart';
import '../../../features/ representative/rep_inventory/presentation/receiving_complete_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/transfer_implant_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/update_implant_screen.dart';
import '../../../features/ representative/rep_inventory/presentation/tray_details_screen.dart';
import '../../../features/ representative/rep_qrscan/rep_qr_scan_screen.dart';
import '../../../features/ representative/sales/add_representative_screen.dart';
import '../../../features/ representative/sales/create_sales_screen.dart';
import '../../../features/ representative/sales/packing_slip_screen.dart';
import '../../../features/ representative/sales/sales_details_screen.dart';
import '../../../features/ representative/sales/sales_screen.dart';
import '../../../features/ representative/sales/select_implants_screen.dart';
import '../../../features/ representative/settingsprofile/presentation/about_hole_screen.dart';
import '../../../features/ representative/settingsprofile/presentation/contact_support_screen.dart';
import '../../../features/ representative/settingsprofile/presentation/terms_conditions_screen.dart';
import '../../../features/ representative/settingsprofile/presentation/others_screen.dart';
import '../../../features/ representative/settingsprofile/presentation/privacy_policy_screen.dart';
import '../../../features/ representative/settingsprofile/presentation/profile_screen.dart';
import '../../../features/ representative/settingsprofile/presentation/settings_profile_screen.dart';
import '../../../features/ representative/shipment/presentation/create_shipment_job_screen.dart';
import '../../../features/ representative/shipment/presentation/job_details_screen.dart' as rep_job_details;
import '../../../features/ representative/shipment/presentation/shipment_select_implants_screen.dart';
import '../../../features/ representative/shipment/presentation/track_shipment_screen.dart';
import '../../../features/driver/driver_home/presentation/job_details_screen.dart';
import '../../../features/ representative/shipment/presentation/shipment_screen.dart';
import '../../../features/auth/forget/forget_screen.dart';
import '../../../features/auth/presentation/screens/oauth_loading_screen.dart';
import '../../../features/auth/presentation/screens/signin_screen.dart';
import '../../../features/auth/presentation/signup_screen.dart';
import '../../../features/auth/reset/reset_password_screen.dart';
import '../../../features/auth/verify/verify_screen.dart';
import '../../../features/driver/driver_bottomnavbar/presentation/driver_bottomnavbar_screen.dart';
import '../../../features/driver/driver_home/presentation/driver_home_screen.dart';
import '../../../features/driver/chatbot/presentation/chatbot_screen.dart';
import '../../../features/driver/driver_map/presentation/complete_delivery_screen.dart';
import '../../../features/driver/driver_map/presentation/delivery_completed_screen.dart';
import '../../../features/driver/driver_map/presentation/driver_map_screen.dart';
import '../../../features/driver/driver_payment/presentation/add_card_screen.dart';
import '../../../features/driver/driver_payment/presentation/payments_methods_screen.dart';
import '../../../features/driver/driverjob/presentation/driver_job_details_screen.dart';
import '../../../features/driver/driverjob/presentation/driver_job_screen.dart';
import '../../../features/driver/driverjob/presentation/new_delivery_details_screen.dart';
import '../../../features/driver/driverprofile/presentation/car_picture_screen.dart';
import '../../../features/driver/driverprofile/presentation/documents_screen.dart';
import '../../../features/driver/driverprofile/presentation/driving_license_screen.dart';
import '../../../features/driver/driverprofile/presentation/nid_rax_id_screen.dart';
import '../../../features/driver/driverprofile/presentation/password_screen.dart';
import '../../../features/driver/driverprofile/presentation/personal_info_screen.dart';
import '../../../features/driver/driverprofile/presentation/driver_profile_screen.dart';
import '../../../features/driver/earning/presentation/all_earning_screen.dart';
import '../../../features/driver/earning/presentation/earning_screen.dart';
import '../../../features/manager/commission/commission_dashboard_screen.dart';
import '../../../features/manager/commission/presentation/commission_details_screen.dart';
import '../../../features/manager/commission/presentation/commission_list_screen.dart';
import '../../../features/manager/commission/presentation/commission_management_screen.dart';
import '../../../features/manager/commission/presentation/transaction_details_screen.dart';
import '../../../features/manager/manager_bottomnavbar/presentation/manager_bottomnavbar_screen.dart';
import '../../../features/manager/manager_home/presentation/manager_home_screen.dart';
import '../../../features/manager/manager_home/presentation/manager_purchase_order_screen.dart';
import '../../../features/manager/manager_home/presentation/po_details_screen.dart';
import '../../../features/manager/manager_home/presentation/po_review_screen.dart';
import '../../../features/manager/managerexpense/presentation/manager_expense_detail_screen.dart';
import '../../../features/manager/managerexpense/presentation/manager_expense_screen.dart';
import '../../../features/manager/managerinventory/presentation/manager_inventory_screen.dart';
import '../../../features/manager/managerinventory/presentation/manager_missing_report_screen.dart';
import '../../../features/manager/managerinventory/presentation/manager_report_details_screen.dart';
import '../../../features/manager/managerinventory/controller/manager_missing_report_controller.dart';
import '../../../features/manager/managerinventory/presentation/manager_transfer_requests_screen.dart';
import '../../../features/manager/managersales/presentation/manager_details_sales_screen.dart';
import '../../../features/manager/managersales/presentation/manager_sales_screen.dart';
import '../../../features/manager/managershipment/presentation/job_review_screen.dart';
import '../../../features/manager/managershipment/presentation/shipments_screen.dart';
import '../../../features/onboarding/presentation/onboarding_screen.dart';
import '../../../features/role_selection/presentation/role_selection_screen.dart';
import '../../../features/splash/presentation/splash_screen.dart';
import '../../../features/ representative/rep_home/presentation/all_activities_screen.dart';
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
  static const String oauthLoadingScreen = "/oauthLoadingScreen";
  static const String repBottomNavBar = "/repBottomNavBar";
  static const String qrScanScreen = "/qrScanScreen";
  static const String newPoScreen = "/newPoScreen";
  static const String createPurchaseScreen = "/createPurchaseScreen";
  static const String bulkPurchaseScreen = "/bulkPurchaseScreen";
  static const String addProductScreen = "/addProductScreen";
  static const String purchaseOrderScreen = "/purchaseOrderScreen";
  static const String inventoryScreen = "/inventoryScreen";
  static const String newTrayScreen = "/newTrayScreen";
  static const String editTrayScreen = "/editTrayScreen";
  static const String trayDetailsScreen = "/trayDetailsScreen";
  static const String sendTrayScreen = "/sendTrayScreen";
  static const String receiveTrayScreen = "/receiveTrayScreen";
  static const String missingInstrumentScreen = "/missingInstrumentScreen";
  static const String reportSuccessScreen = "/reportSuccessScreen";
  static const String addBioInventoryScreen = "/addBioInventoryScreen";
  static const String detailsBioInventoryScreen = "/detailsBioInventoryScreen";
  static const String editBioInventoryScreen = "/editBioInventoryScreen";
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
static const notificationScreen = '/notificationScreen';
static const activityLogScreen = '/activityLogScreen';
static const activityLogDetailScreen = '/activityLogDetailScreen';
static const allActivitiesScreen = '/all-activities';

  static const settingProfileScreen = '/setting-profile';
  static const profileScreen = '/profile';
  static const contactSupportScreen = '/contact-support';
  static const othersScreen = '/others';
  static const privacyPolicyScreen = '/privacy-policy';
  static const aboutHoleScreen = '/about-hole';
  static const termsConditionsScreen = '/terms-conditions';

  static const String serializedImplantsScreen = '/serialized-implants';
  static const String implantDetailsScreen = '/implant-details';
  static const String addImplantScreen = '/add-implant';
  static const String transferImplantScreen = '/transfer-implant';
  static const String createShipmentFromImplantScreen = '/create-shipment-implant';
  static const String createImplantSaleScreen = '/create-implant-sale';

  static const String receivingSessionScreen = '/receiving-session';
  static const String receivingSessionCompleteScreen = '/receiving-complete';
  static const String purchaseOrderDetailScreen = '/purchase-order-detail';


  /// ================================================> Manager ==========================================>



  static const managerHomeScreen = '/manager-home';
  static const managerPurchaseOrderScreen = '/manager-po';
  static const poReviewScreen = '/po-review';
  static const poDetailsScreen = '/po-details';
  static const managerBottomNavBar = '/managerBottomNavBar';
  static const managerInventoryScreen = '/managerInventoryScreen';
  static const managerMissingReportScreen = '/managerMissingReportScreen';
  static const managerTransferRequestsScreen = '/managerTransferRequestsScreen';
  static const managerReportDetailsScreen = '/managerReportDetailsScreen';
  static const managerExpenseDetailScreen = '/managerExpenseDetailScreen';
  static const managerExpenseScreen = '/managerExpenseScreen';
  static const managerSalesScreen = '/managerSalesScreen';
  static const managerSaleDetailScreen = '/managerSaleDetailScreen';

  static const commissionDashboardScreen = '/commission-dashboard';
  static const commissionListScreen = '/commission-list';
  static const managerCommissionDetailScreen = '/managerCommissionDetailScreen';
  static const commissionManagementScreen = '/commission-management';
  static const transactionDetailScreen = '/transaction-detail';

  static const managerShipmentsScreen = '/managerShipmentsScreen';
  static const jobReviewScreen = '/job-review';

  /// -------------------------------------------------- Driver -----------------------------------------------------------------
  static const String driverBottomNavBar = "/driverBottomNavBar";
  static const driverHomeScreen = '/driver-home';
  static const jobDetailsScreen = '/job-details';
  static const driverJobsScreen = '/driver-jobs';
  static const driverJobDetailsScreen = '/driver-job-details';
  static const newDeliveryDetailsScreen = '/newDeliveryDetailsScreen';
  static const driverMapScreen = '/driverMapScreen';
  static const completeDeliveryScreen = '/completeDeliveryScreen';
  static const deliveryCompletedScreen = '/deliveryCompletedScreen';
  static const earningsScreen = '/earningsScreen';
  static const allEarningScreen = '/allEarningScreen';
  static const chatbotScreen = '/chatbotScreen';
  static const driverProfileScreen = '/driverProfileScreen';
  static const personalInfoScreen = '/personalInfoScreen';
  static const changePasswordScreen = '/changePasswordScreen';
  static const nidTaxIdScreen = '/nidTaxIdScreen';
  static const drivingLicenseScreen = '/drivingLicenseScreen';
  static const documentsScreen = '/documentsScreen';
  static const carPicturesScreen = '/carPicturesScreen';
  static const addCardScreen = '/addCardScreen';
  static const paymentMethodsScreen = '/paymentMethodsScreen';
  static const reviewSendPoScreen = '/reviewSendPoScreen';
  static const String updatePurchaseOrderScreen = '/updatePurchaseOrderScreen';
  static const String missingInstrumentDetailScreen = '/missingInstrumentDetailScreen';
  static const String missingInstrumentHistoryScreen = '/missingInstrumentHistoryScreen';
  static const String updateImplantScreen = '/update-implant';
  static const String shipmentSelectImplantsScreen = '/shipmentSelectImplantsScreen';
  static const String createShipmentJobScreen = '/createShipmentJobScreen';
  static const String trackShipmentScreen = '/trackShipmentScreen';



  static final GoRouter goRouter = GoRouter(
    initialLocation: splashScreen,
    redirect: (context, state) async {
      return null;
    },
    // When GoRouter receives nron://oauth-callback (no matching route),
    // show loading instead of falling back to splash → Home tab flash.
    errorBuilder: (context, state) => const OAuthLoadingScreen(),
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
        path: oauthLoadingScreen,
        name: oauthLoadingScreen,
        builder: (context, state) => const OAuthLoadingScreen(),
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
        path: editTrayScreen,
        name: editTrayScreen,
        builder: (context, state) => EditTrayScreen(
          trayId: state.extra as String? ?? '',
        ),
      ),
      GoRoute(
        path: trayDetailsScreen,
        name: trayDetailsScreen,
        builder: (context, state) => TrayDetailsScreen(
          id: state.extra as String? ?? '',
        ),
      ),
      GoRoute(
        path: sendTrayScreen,
        name: sendTrayScreen,
        builder: (context, state) => SendTrayScreen(
          trayId: state.extra as String? ?? '',
        ),
      ),
      GoRoute(
        path: receiveTrayScreen,
        name: receiveTrayScreen,
        builder: (context, state) => ReceiveTrayScreen(
          trayId: state.extra as String? ?? '',
        ),
      ),
      GoRoute(
        path: missingInstrumentScreen,
        name: missingInstrumentScreen,
        builder: (context, state) => MissingInstrumentScreen(
          trayId: state.extra as String? ?? '',
        ),
      ),
      GoRoute(
        path: addBioInventoryScreen,
        name: addBioInventoryScreen,
        builder: (context, state) => const AddBioInventoryScreen(),
      ),
      GoRoute(
        path: detailsBioInventoryScreen,
        name: detailsBioInventoryScreen,
        builder: (context, state) => DetailsBioInventoryScreen(
          id: state.extra as String? ?? '',
        ),
      ),
      GoRoute(
        path: editBioInventoryScreen,
        name: editBioInventoryScreen,
        builder: (context, state) => EditBioInventoryScreen(
          bioId: state.extra as String? ?? '',
        ),
      ),
      GoRoute(
        path: reportSuccessScreen,
        name: reportSuccessScreen,
        builder: (context, state) => const ReportSuccessScreen(),
      ),
      GoRoute(
        path: allActivitiesScreen,
        name: allActivitiesScreen,
        builder: (context, state) => const AllActivitiesScreen(),
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
        builder: (context, state) =>
            SaleDetailScreen(saleId: state.extra as String? ?? ''),
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
        path: physicianProfileScreen,
        name: physicianProfileScreen,
        builder: (context, state) => PhysicianProfileScreen(
          physician: state.extra as PhysicianModel,
        ),
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
        path: notificationScreen,
        name: notificationScreen,
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: activityLogScreen,
        name: activityLogScreen,
        builder: (context, state) => const ActivityLogScreen(),
      ),
      GoRoute(
        path: activityLogDetailScreen,
        name: activityLogDetailScreen,
        builder: (context, state) => ActivityLogDetailScreen(
          log: state.extra as ActivityLogModel,
        ),
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
      GoRoute(
        path: aboutHoleScreen,
        name: aboutHoleScreen,
        builder: (context, state) => const AboutHoleScreen(),
      ),
      GoRoute(
        path: termsConditionsScreen,
        name: termsConditionsScreen,
        builder: (context, state) => const TermsConditionsScreen(),
      ),
      GoRoute(
        path: serializedImplantsScreen,
        name: serializedImplantsScreen,
        builder: (context, state) => const SerializedImplantsScreen(),
      ),
      GoRoute(
        path: implantDetailsScreen,
        name: implantDetailsScreen,
        builder: (context, state) => ImplantDetailsScreen(
          id: state.extra as String? ?? '',
        ),
      ),
      GoRoute(
        path: addImplantScreen,
        name: addImplantScreen,
        builder: (context, state) => AddImplantScreen(
          implant: state.extra is ImplantModel ? state.extra as ImplantModel : null,
        ),
      ),
      GoRoute(
        path: transferImplantScreen,
        name: transferImplantScreen,
        builder: (context, state) => TransferImplantScreen(
          implant: state.extra as ImplantModel,
        ),
      ),
      GoRoute(
        path: createImplantSaleScreen,
        name: createImplantSaleScreen,
        builder: (context, state) => CreateImplantSaleScreen(
          implant: state.extra as ImplantModel,
        ),
      ),
      GoRoute(
        path: createShipmentFromImplantScreen,
        name: createShipmentFromImplantScreen,
        builder: (context, state) => CreateShipmentFromImplantScreen(
          implant: state.extra as ImplantModel,
        ),
      ),
      GoRoute(
        path: receivingSessionScreen,
        name: receivingSessionScreen,
        builder: (context, state) => const ReceivingSessionScreen(),
      ),
      GoRoute(
        path: receivingSessionCompleteScreen,
        name: receivingSessionCompleteScreen,
        builder: (context, state) => const ReceivingSessionCompleteScreen(),
      ),
      GoRoute(
        path: purchaseOrderDetailScreen,
        name: purchaseOrderDetailScreen,
        builder: (context, state) => PurchaseOrderDetailScreen(
          orderId: state.extra as String? ?? '',
        ),
      ),



     /// ========================================> Manager ========================================>


      GoRoute(
        path: managerHomeScreen,
        name: managerHomeScreen,
        builder: (context, state) => const ManagerHomeScreen(),
      ),
      GoRoute(
        path: managerPurchaseOrderScreen,
        name: managerPurchaseOrderScreen,
        builder: (context, state) => const ManagerPurchaseOrderScreen(),
      ),
      GoRoute(
        path: poReviewScreen,
        name: poReviewScreen,
        builder: (context, state) => const POReviewScreen(),
      ),

      GoRoute(
        path: poDetailsScreen,
        name: poDetailsScreen,
        builder: (context, state) => const PODetailsScreen(),
      ),

      GoRoute(
        path: managerBottomNavBar,
        name: managerBottomNavBar,
        builder: (context, state) => const ManagerBottomNavBar(),
      ),
      GoRoute(
        path: managerInventoryScreen,
        name: managerInventoryScreen,
        builder: (context, state) => const ManagerInventoryScreen(),
      ),
      GoRoute(
        path: managerMissingReportScreen,
        name: managerMissingReportScreen,
        builder: (context, state) => const ManagerMissingReportScreen(),
      ),
      GoRoute(
        path: managerTransferRequestsScreen,
        name: managerTransferRequestsScreen,
        builder: (context, state) => const ManagerTransferRequestsScreen(),
      ),
      GoRoute(
        path: managerReportDetailsScreen,
        name: managerReportDetailsScreen,
        builder: (context, state) => ManagerReportDetailsScreen(
          item: state.extra as MissingReportItem,
        ),
      ),

      GoRoute(
        path: managerExpenseDetailScreen,
        name: managerExpenseDetailScreen,
        builder: (context, state) => const ManagerExpenseDetailScreen(),
      ),
      GoRoute(
        path: managerExpenseScreen,
        name: managerExpenseScreen,
        builder: (context, state) => const ManagerExpenseScreen(),
      ),
      GoRoute(
        path: managerSalesScreen,
        name: managerSalesScreen,
        builder: (context, state) => const ManagerSalesScreen(),
      ),
      GoRoute(
        path: managerSaleDetailScreen,
        name: managerSaleDetailScreen,
        builder: (context, state) => const ManagerSaleDetailScreen(),
      ),
      GoRoute(
        path: commissionDashboardScreen,
        name: commissionDashboardScreen,
        builder: (context, state) => const CommissionDashboardScreen(),
      ),
      GoRoute(
        path: commissionListScreen,
        name: commissionListScreen,
        builder: (context, state) => const CommissionListScreen(),
      ),
      GoRoute(
        path: managerCommissionDetailScreen,
        name: managerCommissionDetailScreen,
        builder: (context, state) => const ManagerCommissionDetailScreen(),
      ),
      GoRoute(
        path: commissionManagementScreen,
        name: commissionManagementScreen,
        builder: (context, state) => const CommissionManagementScreen(),
      ),
      GoRoute(
        path: transactionDetailScreen,
        name: transactionDetailScreen,
        builder: (context, state) => const TransactionDetailScreen(),
      ),
      GoRoute(
        path: managerShipmentsScreen,
        name: managerShipmentsScreen,
        builder: (context, state) => const ManagerShipmentsScreen(),
      ),
      GoRoute(
        path: jobReviewScreen,
        name: jobReviewScreen,
        builder: (context, state) => const JobReviewScreen(),
      ),
      GoRoute(
        path: driverBottomNavBar,
        name: driverBottomNavBar,
        builder: (context, state) => const DriverBottomNavBar(),
      ),
      GoRoute(
        path: driverHomeScreen,
        name: driverHomeScreen,
        builder: (context, state) => const DriverHomeScreen(),
      ),
      GoRoute(
        path: jobDetailsScreen,
        name: jobDetailsScreen,
        builder: (context, state) => const JobDetailsScreen(),
      ),
      GoRoute(
        path: driverJobsScreen,
        name: driverJobsScreen,
        builder: (context, state) => const DriverJobsScreen(),
      ),
      GoRoute(
        path: driverJobDetailsScreen,
        name: driverJobDetailsScreen,
        builder: (context, state) => const DriverJobDetailsScreen(),
      ),
      GoRoute(
        path: newDeliveryDetailsScreen,
        name: newDeliveryDetailsScreen,
        builder: (context, state) => const NewDeliveryDetailsScreen(),
      ),
      GoRoute(
        path: driverMapScreen,
        name: driverMapScreen,
        builder: (context, state) => DriverMapScreen(
          jobId: state.extra as String?,
        ),
      ),
      GoRoute(
        path: completeDeliveryScreen,
        name: completeDeliveryScreen,
        builder: (context, state) => const CompleteDeliveryScreen(),
      ),
      GoRoute(
        path: deliveryCompletedScreen,
        name: deliveryCompletedScreen,
        builder: (context, state) => const DeliveryCompletedScreen(),
      ),
      GoRoute(
        path: earningsScreen,
        name: earningsScreen,
        builder: (context, state) => const EarningsScreen(),
      ),
      GoRoute(
        path: allEarningScreen,
        name: allEarningScreen,
        builder: (context, state) => const AllEarningScreen(),
      ),
      GoRoute(
        path: chatbotScreen,
        name: chatbotScreen,
        builder: (context, state) => const ChatbotScreen(),
      ),
      GoRoute(
        path: driverProfileScreen,
        name: driverProfileScreen,
        builder: (context, state) => const DriverProfileScreen(),
      ),
      GoRoute(
        path: personalInfoScreen,
        name: personalInfoScreen,
        builder: (context, state) => PersonalInfoScreen(
          isSetupMode: state.extra as bool? ?? false,
        ),
      ),
      GoRoute(
        path: changePasswordScreen,
        name: changePasswordScreen,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: nidTaxIdScreen,
        name: nidTaxIdScreen,
        builder: (context, state) => const NidTaxIdScreen(),
      ),
      GoRoute(
        path: drivingLicenseScreen,
        name: drivingLicenseScreen,
        builder: (context, state) => const DrivingLicenseScreen(),
      ),
      GoRoute(
        path: documentsScreen,
        name: documentsScreen,
        builder: (context, state) => DocumentsScreen(
          isSetupMode: state.extra as bool? ?? false,
        ),
      ),
      GoRoute(
        path: carPicturesScreen,
        name: carPicturesScreen,
        builder: (context, state) => const CarPicturesScreen(),
      ),
      GoRoute(
        path: addCardScreen,
        name: addCardScreen,
        builder: (context, state) => const AddCardScreen(),
      ),
      GoRoute(
        path: paymentMethodsScreen,
        name: paymentMethodsScreen,
        builder: (context, state) => const PaymentMethodsScreen(),
      ),
      GoRoute(
        path: reviewSendPoScreen,
        name: reviewSendPoScreen,
        builder: (context, state) => const ReviewSendPoScreen(),
      ),
      GoRoute(
        path: missingInstrumentDetailScreen,
        name: missingInstrumentDetailScreen,
        builder: (context, state) => MissingInstrumentDetailScreen(
          id: state.extra as String? ?? '',
        ),
      ),
      GoRoute(
        path: missingInstrumentHistoryScreen,
        name: missingInstrumentHistoryScreen,
        builder: (context, state) => const MissingInstrumentHistoryScreen(),
      ),
      GoRoute(
        path: updateImplantScreen,
        name: updateImplantScreen,
        builder: (context, state) => UpdateImplantScreen(
          implant: state.extra as ImplantModel,
        ),
      ),
      GoRoute(
        path: updatePurchaseOrderScreen,
        name: updatePurchaseOrderScreen,
        builder: (context, state) => UpdatePurchaseScreen(
          orderId: state.extra as String? ?? '',
        ),
      ),


      GoRoute(
        path: shipmentSelectImplantsScreen,
        name: shipmentSelectImplantsScreen,
        builder: (context, state) => ShipmentSelectImplantsScreen(),
      ),
      GoRoute(
        path: createShipmentJobScreen,
        name: createShipmentJobScreen,
        builder: (context, state) => CreateShipmentJobScreen(),
      ),
      GoRoute(
        path: trackShipmentScreen,
        name: trackShipmentScreen,
        builder: (context, state) => TrackShipmentScreen(),
      ),










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
