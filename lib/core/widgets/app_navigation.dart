import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../features/plants/screens/plant_list_screen.dart';
import '../../features/plants/screens/my_plants_screen.dart';
import '../../features/reminders/screens/upcoming_care_screen.dart';
import '../../features/auth/screens/profile_screen.dart';

/// Bottom navigation bar for main app screens
/// INTEGRATION: Navigation System ✅
class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const PlantListScreen(),
    const MyPlantsScreen(),
    const UpcomingCareScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist),
            label: 'Plants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.eco),
            label: 'My Garden',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Care',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
