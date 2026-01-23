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
    const baseBackground = Color(0xFF352029);
    const activeBackground = Color(0xFFACB8A0);
    return SizedBox(
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / tabs.length;
          return Stack(
            children: [
              Container(
                height: double.infinity,
                color: baseBackground,
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOutCubic,
                left: tabWidth * selectedIndex,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: Container(
                  decoration: const BoxDecoration(
                    color: activeBackground,
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 3),
                    ),
                  ),
                ),
              ),
              Row(
                children: List.generate(tabs.length, (index) {
                  final isActive = selectedIndex == index;
                  final foreground = isActive
                      ? Colors.black
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
