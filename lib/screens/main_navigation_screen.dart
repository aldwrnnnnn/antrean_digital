import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import 'counter_admin_screen.dart';
import 'history_screen.dart';
import 'visitor_home_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _navigateToIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      VisitorHomeScreen(
        onSwitchToOfficerMode: () => _navigateToIndex(1),
      ),
      CounterAdminScreen(
        onSwitchToVisitorMode: () => _navigateToIndex(0),
      ),
      const HistoryScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _navigateToIndex,
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.primarySoft,
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(AppIcons.ticket, size: 20, color: AppColors.textSecondary),
              selectedIcon: Icon(AppIcons.ticket, size: 20, color: AppColors.primary),
              label: 'Pengunjung',
            ),
            NavigationDestination(
              icon: Icon(AppIcons.userCheck, size: 20, color: AppColors.textSecondary),
              selectedIcon: Icon(AppIcons.userCheck, size: 20, color: AppColors.primary),
              label: 'Petugas',
            ),
            NavigationDestination(
              icon: Icon(AppIcons.history, size: 20, color: AppColors.textSecondary),
              selectedIcon: Icon(AppIcons.history, size: 20, color: AppColors.primary),
              label: 'Riwayat',
            ),
          ],
        ),
      ),
    );
  }
}
