import 'package:flutter/material.dart';
import 'connection_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static const List<Widget> _pages = <Widget>[
    ConnectionPage(),
    SettingsPage(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    if (isLargeScreen) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: _onTap,
              labelType: NavigationRailLabelType.all,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(
                    Icons.computer_outlined,
                    color: _currentIndex == 0
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[600],
                  ),
                  selectedIcon: Icon(
                    Icons.computer,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: const Text('调试器'),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.settings_outlined,
                    color: _currentIndex == 1
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[600],
                  ),
                  selectedIcon: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: const Text('设置'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: _pages[_currentIndex]),
          ],
        ),
      );
    }

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.04),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTap,
          backgroundColor: Colors.transparent,
          elevation: 0,
          height: 60,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          animationDuration: const Duration(milliseconds: 600),
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.computer_outlined,
                color: _currentIndex == 0
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[600],
              ),
              selectedIcon: Icon(
                Icons.computer,
                color: Theme.of(context).colorScheme.primary,
              ),
              label: '调试器',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.settings_outlined,
                color: _currentIndex == 1
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[600],
              ),
              selectedIcon: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.primary,
              ),
              label: '设置',
            ),
          ],
        ),
      ),
    );
  }
}