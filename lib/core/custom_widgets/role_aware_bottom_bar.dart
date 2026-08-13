import 'package:flutter/material.dart';

import '../helpers/prefs_helper.dart';
import '../../features/ representative/rep_bottomnavbar/presentation/widgets/rep_main_bottom_bar.dart';
import '../../features/manager/manager_bottomnavbar/presentation/widgets/manager_main_bottom_bar.dart';

/// Bottom navigation bar for standalone (drawer-pushed) screens that are shared
/// between roles (e.g. Activity Log, Setting & Profile).
///
/// It reads the cached `user_role` and shows the matching main-shell navbar so
/// tapping a tab jumps back to the correct shell for that role.
class RoleAwareBottomBar extends StatelessWidget {
  const RoleAwareBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final role = PrefsHelper.getStringSync('user_role');
    if (role == 'manager') {
      return const ManagerMainBottomBar(currentIndex: -1, standalone: true);
    }
    return const RepMainBottomBar(currentIndex: -1, standalone: true);
  }
}
