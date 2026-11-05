import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  static const _items = [
    (
      icon: PhosphorIcons.houseSimple,
      activeIcon: PhosphorIcons.houseSimpleFill,
      label: 'Home',
    ),
    (
      icon: PhosphorIcons.puzzlePiece,
      activeIcon: PhosphorIcons.puzzlePieceFill,
      label: 'Games',
    ),
    (
      icon: PhosphorIcons.trophy,
      activeIcon: PhosphorIcons.trophyFill,
      label: 'Rankings',
    ),
    (
      icon: PhosphorIcons.user,
      activeIcon: PhosphorIcons.userFill,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedColor = isDark
        ? const Color(0xFFB8E6D1)
        : const Color(0xFF103B32);

    final unselectedColor = theme.colorScheme.onSurface.withValues(alpha: 0.55);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.07),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = selectedIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onDestinationSelected(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: Icon(
                            isSelected ? item.activeIcon : item.icon,
                            key: ValueKey(isSelected),
                            size: 24,
                            color: isSelected ? selectedColor : unselectedColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 180),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected ? selectedColor : unselectedColor,
                          ),
                          child: Text(item.label),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
