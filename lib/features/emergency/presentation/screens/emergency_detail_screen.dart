import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/launcher_utils.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../data/models/emergency_situation_model.dart';

class EmergencyDetailScreen extends StatefulWidget {
  final EmergencySituationModel situation;

  const EmergencyDetailScreen({super.key, required this.situation});

  @override
  State<EmergencyDetailScreen> createState() => _EmergencyDetailScreenState();
}

class _EmergencyDetailScreenState extends State<EmergencyDetailScreen> {
  final Set<int> _completedSteps = {};

  @override
  Widget build(BuildContext context) {
    final situation = widget.situation;
    final isCritical = situation.severity == 'CRITICAL';
    final themeColor = isCritical ? AppColors.emergencyRed : AppColors.warningOrange;

    return Scaffold(
      appBar: CustomAppBar(
        title: situation.title,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.surfaceDark,
          border: Border(
            top: BorderSide(color: AppColors.dividerDark, width: 0.8),
          ),
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emergencyRed,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            icon: const Icon(Icons.phone_in_talk, size: 24),
            label: Text(
              'CALL RESCUE ${situation.callNumber}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: () => LauncherUtils.makePhoneCall(situation.callNumber),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: themeColor, width: 1.5),
              ),
              child: Row(
                children: [
                  Text(situation.icon, style: const TextStyle(fontSize: 44)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: themeColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isCritical ? '🚨 CRITICAL EMERGENCY' : '⚠️ HIGH RISK',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          situation.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick summary
            if (situation.quickSummary.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.dividerDark),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.bolt, color: AppColors.warningAmber, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        situation.quickSummary,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textLightPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Section title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'STEP-BY-STEP ACTIONS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${_completedSteps.length}/${situation.steps.length} done',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textLightSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Steps
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: situation.steps.length,
              itemBuilder: (context, index) {
                final isDone = _completedSteps.contains(index);
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (isDone) {
                        _completedSteps.remove(index);
                      } else {
                        _completedSteps.add(index);
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDone
                          ? AppColors.safeGreen.withOpacity(0.12)
                          : AppColors.cardDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDone ? AppColors.safeGreen : AppColors.dividerDark,
                        width: isDone ? 1.2 : 0.8,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Icon(
                            isDone ? Icons.check_circle : Icons.circle_outlined,
                            color: isDone ? AppColors.safeGreenLight : AppColors.textLightSecondary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            situation.steps[index],
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.4,
                              fontWeight: isDone ? FontWeight.w400 : FontWeight.w600,
                              decoration: isDone ? TextDecoration.lineThrough : null,
                              color: isDone
                                  ? AppColors.textLightSecondary
                                  : AppColors.textLightPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
