import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../domain/providers/survival_kit_providers.dart';

class SurvivalKitScreen extends ConsumerStatefulWidget {
  const SurvivalKitScreen({super.key});

  @override
  ConsumerState<SurvivalKitScreen> createState() => _SurvivalKitScreenState();
}

class _SurvivalKitScreenState extends ConsumerState<SurvivalKitScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final kitState = ref.watch(survivalKitNotifierProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: '72-Hour Survival Kit',
        actions: [
          IconButton(
            tooltip: 'Reset checklist',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => _confirmReset(context),
          ),
        ],
      ),
      body: kitState.when(
        data: (items) {
          final totalCount = items.length;
          final checkedCount = items.where((i) => i.isChecked).length;
          final progressPercent = totalCount > 0 ? (checkedCount / totalCount) : 0.0;

          final List<String> categories = ['All', ...items.map((i) => i.category).toSet()];
          final filteredItems = _selectedCategory == 'All'
              ? items
              : items.where((i) => i.category == _selectedCategory).toList();

          return Column(
            children: [
              // Progress header
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.surfaceDark, AppColors.cardDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.dividerDark),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Text('🎒', style: TextStyle(fontSize: 24)),
                            SizedBox(width: 8),
                            Text(
                              'Kit readiness',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${(progressPercent * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: progressPercent >= 0.8
                                ? AppColors.safeGreenLight
                                : AppColors.warningAmber,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progressPercent,
                        minHeight: 10,
                        backgroundColor: AppColors.dividerDark,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progressPercent >= 0.8
                              ? AppColors.safeGreenLight
                              : AppColors.warningOrange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '$checkedCount / $totalCount items ready',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textLightSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Category filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: categories.map((category) {
                    final isSelected = category == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        selectedColor: AppColors.emergencyRed,
                        backgroundColor: AppColors.cardDark,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textLightSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                        onSelected: (val) {
                          if (val) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          }
                        },
                      ),
                    );
                  }).toList(),
              ),
            ),
            const SizedBox(height: 8),

              // Items list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      color: item.isChecked
                          ? AppColors.safeGreen.withOpacity(0.08)
                          : AppColors.cardDark,
                      child: CheckboxListTile(
                        activeColor: AppColors.safeGreen,
                        checkColor: Colors.white,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: item.isChecked,
                        onChanged: (_) {
                          ref
                              .read(survivalKitNotifierProvider.notifier)
                              .toggleItem(item.id);
                        },
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  decoration: item.isChecked
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: item.isChecked
                                      ? AppColors.textLightSecondary
                                      : Colors.white,
                                ),
                              ),
                            ),
                            if (item.isEssential)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.emergencyRed.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Essential',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.emergencyRedLight,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        subtitle: item.description.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  item.description,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textLightSecondary,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Reset checklist?'),
        content: const Text(
          'Clear every completed mark on the survival kit and start the checklist over?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textLightSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emergencyRed,
              minimumSize: const Size(80, 36),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(survivalKitNotifierProvider.notifier).resetAll();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
