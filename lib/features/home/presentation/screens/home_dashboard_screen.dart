import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/launcher_utils.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/danger_card.dart';
import '../../../disaster/domain/providers/disaster_providers.dart';
import '../../../disaster/presentation/screens/disaster_detail_screen.dart';
import '../../../emergency/presentation/screens/emergency_triage_screen.dart';
import '../../../family/presentation/screens/family_screen.dart';
import '../../../first_aid/domain/providers/first_aid_providers.dart';
import '../../../first_aid/presentation/screens/first_aid_detail_screen.dart';
import '../../../tools/presentation/screens/sos_tool_screen.dart';

class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disastersAsync = ref.watch(disastersProvider);
    final firstAidAsync = ref.watch(firstAidGuidesProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'SafeVN Survival',
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on_rounded, color: AppColors.warningAmber),
            tooltip: 'Light & S.O.S signal',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SosToolScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.family_restroom_rounded, color: AppColors.infoBlueLight),
            tooltip: 'Family profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FamilyScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // High Urgency SOS Banner
          DangerCard(
            title: 'I AM IN DANGER',
            subtitle: 'Tap now for escape guidance in the first 5 minutes!',
            icon: Icons.emergency,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EmergencyTriageScreen()),
              );
            },
          ),

          // Direct Emergency Call Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                _buildQuickCallButton('112', 'RESCUE', AppColors.emergencyRed),
                const SizedBox(width: 8),
                _buildQuickCallButton('114', 'FIRE', AppColors.warningOrange),
                const SizedBox(width: 8),
                _buildQuickCallButton('115', 'MEDICAL', AppColors.safeGreen),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Common Disasters Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'KEY DISASTER GUIDES',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Switch tab or handled via bottom navigation
                  },
                  child: const Text('See all', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),

          disastersAsync.when(
            data: (disasters) {
              final topDisasters = disasters.take(4).toList();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.25,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: topDisasters.length,
                  itemBuilder: (context, index) {
                    final item = topDisasters[index];
                    return Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DisasterDetailScreen(disaster: item),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(item.icon, style: const TextStyle(fontSize: 32)),
                              const SizedBox(height: 8),
                              Text(
                                item.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Error: $err'),
            ),
          ),

          const SizedBox(height: 16),

          // First Aid Quick Access Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'CRITICAL FIRST AID',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(height: 8),

          firstAidAsync.when(
            data: (guides) {
              final topGuides = guides.take(3).toList();
              return Column(
                children: topGuides.map((guide) {
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: Text(guide.icon, style: const TextStyle(fontSize: 28)),
                      title: Text(
                        guide.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Text(
                        'Golden hour: ${guide.goldenTime}',
                        style: const TextStyle(fontSize: 12, color: AppColors.warningAmber),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FirstAidDetailScreen(guide: guide),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 16),

          // Offline Guarantee Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.dividerDark),
            ),
            child: const Row(
              children: [
                Icon(Icons.offline_pin_rounded, color: AppColors.safeGreenLight, size: 36),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '100% OFFLINE GUARANTEE',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'This app needs no Wi-Fi or mobile data. If the network goes down, every survival guide is still ready to protect you and your family.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textLightSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCallButton(String number, String label, Color color) {
    return Expanded(
      child: Material(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => LauncherUtils.makePhoneCall(number),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color, width: 1.2),
            ),
            child: Column(
              children: [
                Text(
                  number,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
