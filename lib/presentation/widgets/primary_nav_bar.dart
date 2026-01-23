import 'package:flutter/material.dart';

class PrimaryNavBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final bool isDark;

  const PrimaryNavBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.isDark,
  }) : assert(tabs.length >= 2, 'Navigation bar requires at least two tabs');

  @override
  Widget build(BuildContext context) {
    final baseBackground =
        isDark ? Colors.black : const Color(0xFF352029);
    final activeBackground =
        isDark ? Colors.black : const Color(0xFFACB8A0);
    final activeBorder = BorderSide(
      color: isDark ? Colors.white : Colors.black,
      width: isDark ? 2 : 3,
    );
    return SizedBox(
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / tabs.length;
          return Stack(
            children: [
              Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: baseBackground,
                  border: isDark
                      ? const Border(
                          top: BorderSide(color: Colors.white, width: 1),
                        )
                      : null,
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOutCubic,
                left: tabWidth * selectedIndex,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: activeBackground,
                    border: Border(bottom: activeBorder),
                  ),
                ),
              ),
              Row(
                children: List.generate(tabs.length, (index) {
                  final isActive = selectedIndex == index;
                  final foreground = isActive
                      ? (isDark ? Colors.white : Colors.black)
                      : Colors.white.withValues(alpha: 0.8);
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTabSelected(index),
                      child: Container(
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          tabs[index],
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: foreground,
                                fontWeight: isActive
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
