import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../features/splash/presentation/splash_screen.dart';


class AppRoutes {
  static const String splashScreen = "/splashScreen";



  static final GoRouter goRouter = GoRouter(
    initialLocation: splashScreen,
    redirect: (context, state) async {
      return null;
    },
    routes: [

      GoRoute(
        path: splashScreen,
        name: splashScreen,
        builder: (context, state) => SplashScreen(),
      )








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