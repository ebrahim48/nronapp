class ApiConstants {


  static const String baseUrl = 'https://wn85j8p6-9002.asse.devtunnels.ms/api/v1';
  static const String socketUrl = "https://wn85j8p6-9002.asse.devtunnels.ms";



  // static const String baseUrl = 'https://wn85j8p6-9001.asse.devtunnels.ms/api/v1';
  // static const String socketUrl = "https://wn85j8p6-9001.asse.devtunnels.ms";



  static const String apiVersion = '/api/v1';

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  static const String register = '/auth/register';
  static const String verify = '/auth/verify-otp';
  static const String login = '/auth/login';
  static const String forgetPassword = '/auth/forgot-password';
  static const String forgetOtpVerifyPassword = '/auth/forgot-otp-verify';
  static const String resetPassword = '/auth/reset-password';
  static const String resend = '/auth/resend-otp';
  static const String refreshToken = '/auth/refresh-token';

  static const String getMyProfile = '/user/get-my-profile';
  static const String updateMyProfile = '/user/update-my-profile';
  static const String changePassword = '/auth/change-password';
  static const String sendSupportMessage = '/support/send-message';

  static const String aboutUs = '/common/about';
  static const String terms = '/common/terms';
  static const String privacyPolicy = '/common/privacy-policy';

  static const String getPhysicianAll = '/physician/get-all';
  static String getSinglePhysician(String id) => '/physician/find/$id';
  static const String createPhysician = '/physician/create';
  static String updatePhysician(String id) => '/physician/update/$id';
  static String deletePhysician(String id) => '/physician/delete/$id';


  static const String getCommonPhysiciansAll = '/common/all-physicians';
  static const String getSurgeryAll = '/surgery/get-all';
  static String getSingleSurgery(String id) => '/surgery/find/$id';
  static const String createSurgery = '/surgery/create';
  static String updateSurgery(String id) => '/surgery/update/$id';
  static String deleteSurgery(String id) => '/surgery/delete/$id';
  static String getCommonAllFacilities = '/common/all-facilities';

  static const String getCommissionOverview = '/commission/my-overview';
  static const String getCommissionHistory = '/commission/get-my';
  static String getCommissionDetails(String id) => '/commission/find/$id';


  static const String getExpenseMyAll = '/expense/my-all';
  static String getExpenseDetails(String id) => '/expense/find/$id';
  static const String createExpense = '/expense/create';
  static String updateExpense(String id) => '/expense/update/$id';
  static String deleteExpense(String id) => '/expense/delete/$id';
  static const String getCommonAllRepresentative = '/common/all-representatives';


  static const String getSalesOverview = '/sales/get-overview';
  static const String getSales = '/sales/get-my';
  static String getSalesDetails(String id) => '/sales/find/$id';
  static const String createSales = '/sales/create';
  static String updateSales(String id) => '/sales/update/$id';
  static String convertSalesType(String id) => '/sales/convert-sales-type/$id';
  static String deleteSales(String id) => '/sales/delete/$id';
  static const String commonAllVendors = '/common/all-vendors';
  static const String commonAllInventory = '/common/all-inventory';


  static const String home = '/purchase-order/my-overview';
  static const String getPurchaseMyOrder = '/purchase-order/get-my';
  static String getPurchaseDetailsOrder(String id) => '/purchase-order/find/$id';
  static const String createPurchaseOrder = '/purchase-order/create';
  static String updatePurchaseOrder(String id) => '/purchase-order/update/$id';
  static String deletePurchaseOrder(String id) => '/purchase-order/delete/$id';
  static const String commonAllSurgeries = '/common/all-surgeries';



  static const String getInventory = '/meta/inventory/my-overview';
  static const String getInventoryAll = '/meta/inventory/get-all'; // Category: Tray,Implant,Bio
  static const String getImplant = '/implant/get-all';
  static String getSingleImplant(String id) => '/implant/find/$id';
  static const String createImplant = '/implant/create';
  static String updateImplantById(String id) => '/implant/update/$id';
  static String deleteImplantById(String id) => '/implant/delete/$id';
  static String sendTransferRequest(String id) => '/implant/send-transfer-request/$id';

  static const String approveCommission = '/sales/status-update/69d0d1da3c027fd6339e1724'; // id  patch
  static const String getBio = '/bio/get-all';
  static String getSingleBio(String id) => '/bio/find/$id';
  static const String createBio = '/bio/create';
  static String updateBioById(String id) => '/bio/update/$id';
  static String deleteBioById(String id) => '/bio/delete/$id';

  static const String getTray = '/tray/get-all';
  static String getTrayById(String id) => '/tray/find/$id';
  static const String createTray = '/tray/create';
  static String updateTrayById(String id) => '/tray/update/$id';
  static String deleteTrayById(String id) => '/tray/delete/$id';
  static String sendTrayById(String id) => '/tray/send/$id';
  static String receiveTrayById(String id) => '/tray/receive/$id';
  static const String getSummaryCount = '/missing-instrument/my-overview';
  static const String getMissingHistory = '/missing-instrument/history';
  static const String createMissingInstrument = '/missing-instrument/create';
  static String findMissingInstrument(String id) => '/missing-instrument/find/$id';
  static String sendMissingVendorMail(String id) => '/missing-instrument/send-vendor/$id';
  static const String getShipment = '/shipment/get-my/home';
  static const String getMyShipment = '/shipment/get-my';
  static String getShipmentDetails(String id) => '/shipment/find/$id';
  static const String createShipment = '/shipment/create';

  /// ==============================> Manager ===============================>
  static const String getManagerInventory = '/meta/inventory/overview';
  static const String getManagerSummaryCountInstrument = '/missing-instrument/overview';
  static const String getMissingInstrumentReport = '/missing-instrument/report';
  static String getManagerMissingInstrumentDetail(String id) => '/missing-instrument/find/$id';
  static String sendManagerVendorMail(String id) => '/missing-instrument/send-vendor/$id';
  static const String getAllTransferRequest = '/meta/inventory/transfer-requests';

  static const String getExpenseAll = '/expense/get-all';
  static String getManagerSingleExpense(String id) => '/expense/find/$id';

  // Commission
  static const String getCommissionOverviewManager = '/commission/overview';
  static const String getCommissionAllManager = '/commission/get-all';
  static String approveCommissionById(String id) => '/sales/status-update/$id';
  static String getCommissionDetail(String id) => '/commission/find/$id';

  // Commission Manage
  static const String getCommissionManageOverview = '/commission-manage/overview';
  static const String getCommissionManageAll = '/commission-manage/get-all';
  static String getCommissionManageSingle(String id) => '/commission-manage/find/$id';
  static String updateCommissionRate(String id) => '/commission-manage/update-commission/$id';

  static const String getManagerSales = '/sales/get-all';
  static String getManagerSaleDetail(String id) => '/sales/find/$id';








}





