import 'package:flutter/material.dart';
import 'package:nron_app/core/utils/app_colors.dart';

class OAuthLoadingScreen extends StatelessWidget {
  const OAuthLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      ),
    );
  }
}
