import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../domain/providers/first_aid_providers.dart';
import 'first_aid_detail_screen.dart';

class FirstAidListScreen extends ConsumerWidget {
  const FirstAidListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guidesAsync = ref.watch(firstAidGuidesProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Kỹ Năng Sơ Cứu',
      ),
      body: guidesAsync.when(
        data: (guides) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: guides.length,
            itemBuilder: (context, index) {
              final guide = guides[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FirstAidDetailScreen(guide: guide),
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
                            color: AppColors.emergencyRed.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(guide.icon, style: const TextStyle(fontSize: 26)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                guide.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                guide.summary,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textLightSecondary,
                                  height: 1.3,
                                ),
                              ),
                              if (guide.goldenTime.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  '⏱️ ${guide.goldenTime}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.warningAmber,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
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
            },
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
