class AuthTempData {
  static String email = '';
  static String verifyToken = '';   // from register response
  static String forgotToken = '';   // from forgot-password response
  static String verifyFlow = '';    // 'register' | 'forgot'
  static String selectedRole = 'representative'; // set from RoleSelectionScreen

  static void clear() {
    email = '';
    verifyToken = '';
    forgotToken = '';
    verifyFlow = '';
    // selectedRole intentionally not cleared — persists for re-login
  }
}
