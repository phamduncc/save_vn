import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/launcher_utils.dart';
import '../../../../shared/widgets/action_step_item.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../data/models/first_aid_model.dart';

class FirstAidDetailScreen extends StatefulWidget {
  final FirstAidModel guide;

  const FirstAidDetailScreen({super.key, required this.guide});

  @override
  State<FirstAidDetailScreen> createState() => _FirstAidDetailScreenState();
}

class _FirstAidDetailScreenState extends State<FirstAidDetailScreen> {
  // CPR Metronome state (110 BPM = ~545ms per beat)
  Timer? _cprTimer;
  bool _isMetronomeActive = false;
  bool _beatFlash = false;

  @override
  void dispose() {
    _cprTimer?.cancel();
    super.dispose();
  }

  void _toggleCprMetronome() {
    if (_isMetronomeActive) {
      _cprTimer?.cancel();
      setState(() {
        _isMetronomeActive = false;
        _beatFlash = false;
      });
    } else {
      setState(() {
        _isMetronomeActive = true;
      });
      // 110 beats per minute -> 60000 / 110 = ~545ms
      _cprTimer = Timer.periodic(const Duration(milliseconds: 545), (timer) {
        if (!mounted) return;
        setState(() {
          _beatFlash = true;
        });
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) {
            setState(() {
              _beatFlash = false;
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final guide = widget.guide;
    final isCpr = guide.id == 'cpr_tim_phoi';

    return Scaffold(
      appBar: CustomAppBar(
        title: guide.title,
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
            icon: const Icon(Icons.local_hospital, size: 24),
            label: const Text(
              'GỌI CẤP CỨU 115 NGAY',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: () => LauncherUtils.makePhoneCall('115'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.dividerDark),
              ),
              child: Row(
                children: [
                  Text(guide.icon, style: const TextStyle(fontSize: 42)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          guide.category,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.emergencyRedLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          guide.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (guide.goldenTime.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.warningOrange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.warningOrange, width: 0.8),
                            ),
                            child: Text(
                              '⏱️ Thời gian vàng: ${guide.goldenTime}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.warningAmber,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // CPR Visual Metronome Feature
            if (isCpr) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _beatFlash
                      ? AppColors.emergencyRed.withOpacity(0.4)
                      : AppColors.cardDark,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _isMetronomeActive ? AppColors.emergencyRed : AppColors.dividerDark,
                    width: _isMetronomeActive ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: _beatFlash ? AppColors.emergencyRedLight : Colors.white54,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Máy đếm nhịp ép tim (110 nhịp/phút)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Ấn lồng ngực theo nhịp chớp sáng',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textLightSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isMetronomeActive ? Colors.red : AppColors.safeGreen,
                            minimumSize: const Size(90, 38),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          onPressed: _toggleCprMetronome,
                          child: Text(
                            _isMetronomeActive ? 'DỪNG' : 'BẬT NHỊP',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Summary
            Text(
              guide.summary,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textLightSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),

            // Step by step
            const Text(
              'QUY TRÌNH SƠ CỨU CHUẨN',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            ...guide.steps.asMap().entries.map(
                  (entry) => ActionStepItem(
                    index: entry.key + 1,
                    text: entry.value,
                    accentColor: AppColors.safeGreenLight,
                  ),
                ),

            const SizedBox(height: 16),

            // Cautions
            if (guide.cautions.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.warningOrange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.warningOrange, width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: AppColors.warningAmber, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'CẢNH BÁO & SAI LẦM NGUY HIỂM',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.warningAmber,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...guide.cautions.map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('⚠️ ', style: TextStyle(fontSize: 12)),
                            Expanded(
                              child: Text(
                                c,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
