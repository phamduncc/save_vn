import 'package:flutter/material.dart';
import '../../../disaster/presentation/screens/disaster_list_screen.dart';
import '../../../first_aid/presentation/screens/first_aid_list_screen.dart';
import '../../../hotlines/presentation/screens/hotlines_screen.dart';
import '../../../survival_kit/presentation/screens/survival_kit_screen.dart';
import 'home_dashboard_screen.dart';

class HomeNavigationShell extends StatefulWidget {
  const HomeNavigationShell({super.key});

  @override
  State<HomeNavigationShell> createState() => _HomeNavigationShellState();
}

class _HomeNavigationShellState extends State<HomeNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeDashboardScreen(),
    DisasterListScreen(),
    FirstAidListScreen(),
    SurvivalKitScreen(),
    HotlinesScreen(),
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
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_filled),
            label: 'Tổng quan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thunderstorm_outlined),
            activeIcon: Icon(Icons.thunderstorm_rounded),
            label: 'Thiên tai',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined),
            activeIcon: Icon(Icons.medical_services_rounded),
            label: 'Sơ cứu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.backpack_outlined),
            activeIcon: Icon(Icons.backpack_rounded),
            label: 'Túi 72h',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone_in_talk_outlined),
            activeIcon: Icon(Icons.phone_in_talk_rounded),
            label: 'Hotline',
          ),
        ],
      ),
    );
  }
}
