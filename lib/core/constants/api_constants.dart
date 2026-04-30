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


  static String getExpenseMyAll = '/expense/my-all';
  static String getExpenseDetails = '/expense/find/69f2f4a29af5307fc7b86edc'; // id
  static String createExpense = '/expense/create';
  static String updateExpense = '/expense/update/69d0d1da3c027fd6339e1724'; // id
  static String deleteExpense = '/expense/delete/69cceac58f443179210b324f'; // id
  static String getCommonAllRepresentative = '/common/all-representatives?search=r';














}





