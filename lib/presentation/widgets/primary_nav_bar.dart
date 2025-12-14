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
          final colorScheme = Theme.of(context).colorScheme;
          final background = isActive
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest;
          final foreground = isActive
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurface;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(index),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: background,
                  border: Border(
                    bottom: BorderSide(
                      color: isActive
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
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
