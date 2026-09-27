import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../domain/providers/emergency_providers.dart';
import 'emergency_detail_screen.dart';

class EmergencyTriageScreen extends ConsumerWidget {
  const EmergencyTriageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final situationsAsync = ref.watch(emergencySituationsProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: '🚨 Tôi Đang Gặp Nguy Hiểm',
      ),
      body: situationsAsync.when(
        data: (situations) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.emergencyRed.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.emergencyRed, width: 1.2),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_outlined, color: AppColors.emergencyRedLight, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Chọn nhanh tình huống bạn đang đối mặt để nhận hướng dẫn sống còn ngay lập tức!',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...situations.map((situation) {
                final isCritical = situation.severity == 'CRITICAL';
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmergencyDetailScreen(situation: situation),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isCritical
                                  ? AppColors.emergencyRed.withOpacity(0.2)
                                  : AppColors.warningOrange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              situation.icon,
                              style: const TextStyle(fontSize: 26),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  situation.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  situation.quickSummary,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textLightSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.textLightSecondary,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Lỗi tải dữ liệu: $err', style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
