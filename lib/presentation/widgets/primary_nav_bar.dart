import 'package:flutter/material.dart';

class PrimaryNavBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const PrimaryNavBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : assert(tabs.length >= 2, 'Navigation bar requires at least two tabs');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isActive = selectedIndex == index;
          const baseBackground = Color(0xFF352029);
          const activeBackground = Color(0xFFACB8A0);
          final background = isActive ? activeBackground : baseBackground;
          final foreground =
              isActive ? Colors.black : Colors.white.withValues(alpha: 0.8);

          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(index),
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: background,
                  border: Border(
                    bottom: BorderSide(
                      color: isActive ? Colors.black : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  tabs[index],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: foreground,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                      ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
