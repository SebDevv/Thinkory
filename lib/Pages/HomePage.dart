import 'dart:ui';

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

              // Daily challenge
              Text(
                "Your Streak!",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 32),
              // Daily challenge
              Text(
                "Today's Challenge",
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 16),

              // We'll build the challenge card here.
              const SizedBox(height: 32),

              // Your progress
              IconButton(
                onPressed: () {
                  setState(() {
                    availablePoints += 100;
                  });
                },
                icon: Icon(PhosphorIcons.basketBold),
              ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final mint = const Color(0xFFB8E6D1);
    final forestGreen = const Color(0xFF103B32);

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            color: isDark
                ? mint.withValues(alpha: 0.10)
                : Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isDark
                  ? mint.withValues(alpha: 0.25)
                  : forestGreen.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,

            children: [
              GestureDetector(
                onTap: showHowToEarnPoints,
                child: Icon(
                  PhosphorIcons.starBold,
                  color: isDark ? mint : forestGreen,
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                availablePoints.toString() + ' pts',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : forestGreen,
                ),
              ),

              SizedBox(width: 20),

              GestureDetector(
                onTap: showHintPurchaseSheet,
                child: Icon(
                  PhosphorIcons.lightbulbBold,
                  color: isDark ? mint : forestGreen,
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                hints.toString(),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : forestGreen,
                ),
              ),

              SizedBox(width: 20),

              GestureDetector(
                onTap: showSkipPurchaseSheet,
                child: Icon(
                  PhosphorIcons.fastForwardBold,
                  color: isDark ? mint : forestGreen,
                  size: 24,
                ),
              ),
              SizedBox(width: 10),
              Text(
                skips.toString(),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : forestGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
