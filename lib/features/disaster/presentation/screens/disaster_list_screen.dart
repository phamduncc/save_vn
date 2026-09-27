import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../domain/providers/disaster_providers.dart';
import 'disaster_detail_screen.dart';

class DisasterListScreen extends ConsumerWidget {
  const DisasterListScreen({super.key});

  Color _parseHexColor(String hex) {
    try {
      final buffer = StringBuffer();
      if (hex.length == 6 || hex.length == 7) buffer.write('ff');
      buffer.write(hex.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return AppColors.emergencyRed;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disastersAsync = ref.watch(disastersProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Disaster Guide',
      ),
      body: disastersAsync.when(
        data: (disasters) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: disasters.length,
            itemBuilder: (context, index) {
              final item = disasters[index];
              final itemColor = _parseHexColor(item.color);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
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
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: itemColor.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: itemColor.withOpacity(0.4)),
                          ),
                          child: Text(item.icon, style: const TextStyle(fontSize: 26)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.summary,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textLightSecondary,
                                  height: 1.3,
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
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Failed to load data: $err', style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
