import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../features/ representative/rep_bottomnavbar/rep_bottomNavbar_screen.dart';
import '../../../features/ representative/rep_home/create_purchase_order_screen.dart';
import '../../../features/ representative/rep_home/presentation/bulk_purchase_screen.dart';
import '../../../features/ representative/rep_home/presentation/new_po_screen.dart';
import '../../../features/ representative/rep_qrscan/rep_qr_scan_screen.dart';
import '../../../features/auth/forget/forget_screen.dart';
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
  static const String forgetPasswordScreen = "/forgetPasswordScreen";
  static const String verifyScreen = "/verifyScreen";
  static const String resetPasswordScreen = "/resetPasswordScreen";
  static const String repBottomNavBar = "/repBottomNavBar";
  static const String qrScanScreen = "/qrScanScreen";
  static const String newPoScreen = "/newPoScreen";
  static const String createPurchaseScreen = "/createPurchaseScreen";
  static const String bulkPurchaseScreen = "/bulkPurchaseScreen";

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
