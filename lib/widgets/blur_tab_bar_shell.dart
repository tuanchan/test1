import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/home_screen.dart';
import '../screens/tasks_screen.dart';

class BlurTabBarShell extends StatefulWidget {
  const BlurTabBarShell({super.key});
  @override
  State<BlurTabBarShell> createState() => _BlurTabBarShellState();
}

class _BlurTabBarShellState extends State<BlurTabBarShell> {
  int _idx = 0;

  static const _screens = [HomeScreen(), TasksScreen()];
  static const _items = [
    (icon: CupertinoIcons.house_fill, label: 'Home'),
    (icon: CupertinoIcons.square_list_fill, label: 'Tasks'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Stack(
      children: [
        _screens[_idx],
        Positioned(
          left: 50, right: 50,
          bottom: (bottom > 0 ? bottom : 16),
          child: _TabBar(
            selected: _idx,
            items: _items,
            onTap: (i) => setState(() => _idx = i),
          ),
        ),
      ],
    );
  }
}

class _TabBar extends StatelessWidget {
  final int selected;
  final List<({IconData icon, String label})> items;
  final ValueChanged<int> onTap;
  const _TabBar({required this.selected, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            color: AppColors.elevated.withOpacity(0.90),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20, offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: items.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              final active = i == selected;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 6),
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.accent.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(item.icon,
                            size: 20,
                            color: active
                                ? AppColors.accent
                                : AppColors.textSecondary.withOpacity(0.5)),
                      ),
                      const SizedBox(height: 2),
                      Text(item.label,
                          style: AppTextStyles.label.copyWith(
                            fontSize: 9,
                            color: active
                                ? AppColors.accent
                                : AppColors.textSecondary.withOpacity(0.45),
                            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                          )),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
