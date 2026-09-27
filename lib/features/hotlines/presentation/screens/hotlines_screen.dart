import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/launcher_utils.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../domain/providers/hotline_providers.dart';

class HotlinesScreen extends ConsumerWidget {
  const HotlinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotlinesAsync = ref.watch(hotlinesProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Đường Dây Nóng Cứu Hộ',
      ),
      body: hotlinesAsync.when(
        data: (hotlines) {
          final primaryHotlines = hotlines.where((h) => h.isPrimary).toList();
          final otherHotlines = hotlines.where((h) => !h.isPrimary).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Notice banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.infoBlue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.infoBlue, width: 1),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: AppColors.infoBlueLight, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Các đầu số 112, 113, 114, 115 là miễn phí cuộc gọi và hoạt động 24/7 trên toàn quốc.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Primary 4 hotlines grid
              const Text(
                'TỔNG ĐÀI KHẨN CẤP QUỐC GIA',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 10),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: primaryHotlines.map((hotline) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: hotline.number == '112'
                            ? [AppColors.emergencyRed, AppColors.emergencyRedDark]
                            : [AppColors.surfaceDark, AppColors.cardDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: hotline.number == '112'
                            ? AppColors.emergencyRedLight
                            : AppColors.dividerDark,
                      ),
                      boxShadow: [
                        if (hotline.number == '112')
                          BoxShadow(
                            color: AppColors.emergencyRed.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => LauncherUtils.makePhoneCall(hotline.number),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                hotline.number,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                hotline.name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: hotline.number == '112'
                                      ? Colors.white
                                      : AppColors.textLightSecondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.phone_forwarded,
                                    size: 13,
                                    color: hotline.number == '112'
                                        ? Colors.white
                                        : AppColors.safeGreenLight,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Bấm để gọi',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: hotline.number == '112'
                                          ? Colors.white
                                          : AppColors.safeGreenLight,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Other Hotlines
              const Text(
                'CƠ QUAN PHÒNG CHỐNG & CỨU TRỢ',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 10),

              ...otherHotlines.map((hotline) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.infoBlue.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.phone_in_talk, color: AppColors.infoBlueLight),
                    ),
                    title: Text(
                      hotline.name,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          hotline.display ?? hotline.number,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.warningAmber,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          hotline.description,
                          style: const TextStyle(fontSize: 12, color: AppColors.textLightSecondary),
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.safeGreen,
                        minimumSize: const Size(60, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      onPressed: () => LauncherUtils.makePhoneCall(hotline.number),
                      child: const Text('Gọi', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                );
              }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Lỗi: $err', style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
