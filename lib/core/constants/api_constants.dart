class ApiConstants {
  static const String baseUrl = 'https://wn85j8p6-9001.asse.devtunnels.ms/api/v1';
  static const String socketUrl = "https://wn85j8p6-9001.asse.devtunnels.ms";



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














}





