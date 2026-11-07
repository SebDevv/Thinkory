import 'dart:ui';

import 'package:thinkory/Core/Theme/app_colors.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int seasonPoints = 1240;
  int availablePoints = 500;
  int hints = 3;
  int skips = 1;

  static const int hintCost = 100;
  static const int maxHints = 10;

  static const int skipCost = 5000;
  static const int maxSkips = 5;

  int get maxHintsPurchasable {
    final remainingCapacity = maxHints - hints;
    final affordableHints = availablePoints ~/ hintCost;

    return affordableHints < remainingCapacity
        ? affordableHints
        : remainingCapacity;
  }

  int get maxSkipsPurchasable {
    final remainingCapacity = maxSkips - skips;
    final affordableSkips = availablePoints ~/ skipCost;

    return affordableSkips < remainingCapacity
        ? affordableSkips
        : remainingCapacity;
  }

  final List<int> streakMilestones = [7, 14, 30, 100];

  int get nextStreakMilestone {
    return streakMilestones.firstWhere(
      (milestone) => milestone > currentStreak,
      orElse: () => currentStreak,
    );
  }

  double get streakProgress {
    final previousMilestone =
        streakMilestones
            .where((milestone) => milestone <= currentStreak)
            .lastOrNull ??
        0;

    final nextMilestone = nextStreakMilestone;

    if (nextMilestone == previousMilestone) return 1;

    return (currentStreak - previousMilestone) /
        (nextMilestone - previousMilestone);
  }

  int currentStreak = 5;

  String dateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  // Temporary activity data for testing.
  // These dates move with the current date.
  Set<String> get completedGameDates {
    final today = DateTime.now();

    return {
      dateKey(today.subtract(const Duration(days: 6))),
      dateKey(today.subtract(const Duration(days: 5))),
      dateKey(today.subtract(const Duration(days: 4))),
      dateKey(today.subtract(const Duration(days: 3))),
      dateKey(today.subtract(const Duration(days: 2))),
    };
  }

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  String selectedDifficulty = 'Medium';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(child: _pointsCard()),
                  //Center(child: _HintsCard()),
                ],
              ),

              const SizedBox(height: 48),
              Text(
                "Your Streak",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 12),
              // Player Streak
              Card(
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildStreakDays(),
                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Next milestone',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              '$nextStreakMilestone days',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: streakProgress,
                            minHeight: 8,
                            backgroundColor: isDark
                                ? Colors.white.withOpacity(0.12)
                                : Colors.black.withOpacity(0.08),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isDark
                                  ? AppColors.softMint
                                  : AppColors.forestGreen,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          '${(streakProgress * 100).round()}% towards your next milestone',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
              // Daily challenge
              Text(
                "Today's Challenge",
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 16),
              _buildTodaysChallengeCard(),
              // Your progress
            ],
          ),
        ),
      ),
    );
  }

  void showHintPurchaseSheet() {
    int howManyPoints = hintCost - availablePoints;
    if (maxHintsPurchasable == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            hints >= maxHints
                ? 'Your hint wallet is full!'
                : 'You need $howManyPoints points to buy a hint.',
          ),
        ),
      );
      return;
    }

    int selectedHints = 1;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final totalCost = selectedHints * hintCost;
            final remainingPoints = availablePoints - totalCost;

            return Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Available points'),
                        Text(
                          '$availablePoints pts',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Hints to purchase (maximum of 10)'),
                        Text(
                          '$selectedHints',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),

                    Slider(
                      value: selectedHints.toDouble(),
                      min: 1,
                      max: maxHintsPurchasable.toDouble(),
                      divisions: maxHintsPurchasable > 1
                          ? maxHintsPurchasable - 1
                          : null,
                      onChanged: (value) {
                        setSheetState(() {
                          selectedHints = value.round();
                        });
                      },
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '1 hint',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '$maxHintsPurchasable hints',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total cost'),
                        Text(
                          '$totalCost pts',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Remaining balance'),
                        Text('$remainingPoints pts'),
                      ],
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          setState(() {
                            availablePoints -= totalCost;
                            hints += selectedHints;
                          });

                          Navigator.pop(sheetContext);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '$selectedHints hint(s) purchased!',
                              ),
                            ),
                          );
                        },
                        child: const Text('Purchase hints'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void purchaseHint() {
    if (availablePoints < hintCost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough points to purchase a hint!')),
      );
      return;
    }

    setState(() {
      availablePoints -= hintCost;
      hints += 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hint purchased successfully!')),
    );
  }

  void showSkipPurchaseSheet() {
    int howManyPoints = skipCost - availablePoints;
    if (maxSkipsPurchasable == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            skips >= maxSkips
                ? 'You have reach the maximum amount of skips!'
                : 'You need $howManyPoints points to buy a skip.',
          ),
        ),
      );
      return;
    }

    int selectedSkips = 1;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final totalCost = selectedSkips * skipCost;
            final remainingPoints = availablePoints - totalCost;

            return Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Available points'),
                        Text(
                          '$availablePoints pts',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Skips to purchase (maximum of 5)'),
                        Text(
                          '$selectedSkips',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),

                    Slider(
                      value: selectedSkips.toDouble(),
                      min: 1,
                      max: maxSkipsPurchasable.toDouble(),
                      divisions: maxSkipsPurchasable > 1
                          ? maxSkipsPurchasable - 1
                          : null,
                      onChanged: (value) {
                        setSheetState(() {
                          selectedSkips = value.round();
                        });
                      },
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '1 skips',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '$maxSkipsPurchasable hints',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total cost'),
                        Text(
                          '$totalCost pts',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Remaining balance'),
                        Text('$remainingPoints pts'),
                      ],
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          setState(() {
                            availablePoints -= totalCost;
                            skips += selectedSkips;
                          });

                          Navigator.pop(sheetContext);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '$selectedSkips hint(s) purchased!',
                              ),
                            ),
                          );
                        },
                        child: const Text('Purchase skips'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void purchaseSkip() {
    if (availablePoints < skipCost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough points to purchase a skip!')),
      );
      return;
    }

    setState(() {
      availablePoints -= skipCost;
      skips += 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('skip purchased successfully!')),
    );
  }

  void showHowToEarnPoints() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'You can earn more points by playing games, the harder the difficulty, the more points you will earn! Get Playing',
        ),
      ),
    );
  }

  Widget _pointsCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.softMint.withValues(alpha: 0.10)
                : Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isDark
                  ? AppColors.softMint.withValues(alpha: 0.25)
                  : AppColors.forestGreen.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,

            children: [
              GestureDetector(
                onTap: showHowToEarnPoints,
                child: Icon(
                  PhosphorIcons.starBold,
                  color: isDark ? AppColors.softMint : AppColors.forestGreen,
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                availablePoints.toString() + ' pts',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.forestGreen,
                ),
              ),

              SizedBox(width: 20),

              GestureDetector(
                onTap: showHintPurchaseSheet,
                child: Icon(
                  PhosphorIcons.lightbulbBold,
                  color: isDark ? AppColors.softMint : AppColors.forestGreen,
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                hints.toString(),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.forestGreen,
                ),
              ),

              SizedBox(width: 20),

              GestureDetector(
                onTap: showSkipPurchaseSheet,
                child: Icon(
                  PhosphorIcons.fastForwardBold,
                  color: isDark ? AppColors.softMint : AppColors.forestGreen,
                  size: 24,
                ),
              ),
              SizedBox(width: 10),
              Text(
                skips.toString(),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.forestGreen,
                ),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    availablePoints += 100;
                  });
                },
                child: Icon(
                  PhosphorIcons.plusCircleBold,
                  color: isDark ? AppColors.softMint : AppColors.forestGreen,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreakDays() {
    final today = DateTime.now();

    const dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Row(
      children: List.generate(7, (index) {
        final date = today.subtract(Duration(days: 6 - index));
        final completed = completedGameDates.contains(dateKey(date));
        final isToday = dateKey(date) == dateKey(today);

        return Expanded(
          child: Column(
            children: [
              Text(
                dayLabels[date.weekday - 1],
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Icon(
                completed ? PhosphorIcons.medalFill : PhosphorIcons.medal,
                size: 28,
                color: completed
                    ? isDark
                          ? AppColors.softMint
                          : AppColors.forestGreen
                    : Theme.of(context).disabledColor,
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 24,
                child: isToday
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.softMint.withOpacity(0.15)
                              : AppColors.forestGreen.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Today',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: isDark
                                    ? AppColors.softMint
                                    : AppColors.forestGreen,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTodaysChallengeCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Challenge label
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'DAILY CHALLENGE',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Icon(PhosphorIcons.calendarBlank, size: 18),
              ],
            ),

            const SizedBox(height: 20),

            // Game information
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.deepSage : AppColors.paleMint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    PhosphorIcons.puzzlePiece,
                    size: 32,
                    color: isDark ? AppColors.softMint : AppColors.forestGreen,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Maze',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Find your way through today's maze.",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Difficulty selection
            Text(
              'Choose your difficulty',
              style: Theme.of(context).textTheme.titleSmall,
            ),

            const SizedBox(height: 12),

            Row(
              children: ['Easy', 'Medium', 'Hard', 'Expert'].map((difficulty) {
                final isSelected = selectedDifficulty == difficulty;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: ChoiceChip(
                      label: Text(difficulty),
                      selected: isSelected,
                      showCheckmark: false,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            selectedDifficulty = difficulty;
                          });
                        }
                      },
                      backgroundColor: isDark
                          ? AppColors.charcoal
                          : AppColors.warmCream,
                      selectedColor: isDark
                          ? AppColors.deepSage
                          : AppColors.paleMint,
                      side: BorderSide(
                        color: isSelected
                            ? (isDark
                                  ? AppColors.softMint
                                  : AppColors.forestGreen)
                            : Theme.of(context).dividerColor,
                      ),
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected
                            ? (isDark
                                  ? AppColors.softMint
                                  : AppColors.forestGreen)
                            : Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Starting Daily Maze - $selectedDifficulty',
                      ),
                    ),
                  );
                },
                icon: const Icon(PhosphorIcons.play),
                label: const Text('Play Challenge'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? AppColors.softMint
                      : AppColors.forestGreen,
                  foregroundColor: isDark
                      ? AppColors.forestGreen
                      : Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
