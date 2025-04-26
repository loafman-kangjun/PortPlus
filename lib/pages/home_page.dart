import 'package:flutter/material.dart';
import 'connection_page.dart';
import 'settings_page.dart';

/// 主页面，负责显示调试器页面和设置页面
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// HomePage的状态类，包含页面切换逻辑
class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // 当前选中的页面索引
  late PageController _pageController; // 用于PageView控制页面切换

  // 可供显示的页面列表：调试器和设置页面
  static const List<Widget> _pages = <Widget>[
    ConnectionPage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    // 初始化PageController，默认显示第0个页面
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    // 释放页面控制器资源
    _pageController.dispose();
    super.dispose();
  }

  // 点击导航按钮时切换到指定页面（无动画）
  void _onTap(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    // 判断当前是否为大屏幕设备（宽度大于600）
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    // 构造PageView，用于页面切换
    final pageView = PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(), // 禁用手势滑动
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      children: _pages,
    );

    // 大屏幕下显示侧边导航栏
    if (isLargeScreen) {
      return Scaffold(
        body: Row(
          children: [
            // 侧边导航栏
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: _onTap,
              labelType: NavigationRailLabelType.all,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(
                    Icons.computer_outlined,
                    // 根据当前索引设置图标颜色
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
            // 分隔线
            const VerticalDivider(thickness: 1, width: 1),
            // 扩展区域使用PageView展示对应的页面内容
            Expanded(child: pageView),
          ],
        ),
      );
    }

    // 小屏幕下使用底部导航栏，PageView作为主体展示内容
    return Scaffold(
      body: pageView,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          // 设置底部栏背景颜色及圆角
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