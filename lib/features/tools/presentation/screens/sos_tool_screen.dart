import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class SosToolScreen extends StatefulWidget {
  const SosToolScreen({super.key});

  @override
  State<SosToolScreen> createState() => _SosToolScreenState();
}

class _SosToolScreenState extends State<SosToolScreen> {
  bool _isFlashing = false;
  bool _flashColorState = false;
  Timer? _flashTimer;

  bool _isWhiteTorch = false;

  @override
  void dispose() {
    _flashTimer?.cancel();
    super.dispose();
  }

  void _toggleSosFlash() {
    if (_isFlashing) {
      _flashTimer?.cancel();
      setState(() {
        _isFlashing = false;
        _flashColorState = false;
      });
    } else {
      setState(() {
        _isFlashing = true;
        _isWhiteTorch = false;
      });
      // Flash every 200ms
      _flashTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
        if (!mounted) return;
        setState(() {
          _flashColorState = !_flashColorState;
        });
      });
    }
  }

  void _toggleWhiteTorch() {
    if (_isFlashing) {
      _flashTimer?.cancel();
      _isFlashing = false;
    }
    setState(() {
      _isWhiteTorch = !_isWhiteTorch;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isWhiteTorch) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: InkWell(
          onTap: _toggleWhiteTorch,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lightbulb, size: 80, color: Colors.black54),
                SizedBox(height: 16),
                Text(
                  'ĐÈN PIN MÀN HÌNH TỐI ĐA',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Chạm vào bất cứ đâu để tắt',
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final strobeBg = _isFlashing
        ? (_flashColorState ? AppColors.emergencyRed : Colors.white)
        : AppColors.backgroundDark;

    return Scaffold(
      backgroundColor: strobeBg,
      appBar: const CustomAppBar(
        title: 'Công Cụ Cứu Nạn S.O.S',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Notice
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardDark.withOpacity(_isFlashing ? 0.9 : 1.0),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.dividerDark),
              ),
              child: const Row(
                children: [
                  Icon(Icons.light_mode_outlined, color: AppColors.warningAmber, size: 28),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Sử dụng tín hiệu ánh sáng chớp nháy cường độ cao để thu hút sự chú ý của trực thăng hoặc đội cứu hộ vào ban đêm.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Big SOS Strobe Button
            GestureDetector(
              onTap: _toggleSosFlash,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: _isFlashing
                        ? [Colors.yellowAccent, Colors.orange]
                        : [AppColors.emergencyRed, AppColors.emergencyRedDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isFlashing
                          ? Colors.white.withOpacity(0.8)
                          : AppColors.emergencyRed.withOpacity(0.4),
                      blurRadius: _isFlashing ? 30 : 15,
                      spreadRadius: _isFlashing ? 8 : 2,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isFlashing ? Icons.flash_on : Icons.warning_rounded,
                      size: 48,
                      color: _isFlashing ? Colors.black : Colors.white,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _isFlashing ? 'TẮT CHỚP' : 'CHỚP S.O.S',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        color: _isFlashing ? Colors.black : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 36),

            // Full white screen torch button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cardDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.white24),
                ),
                icon: const Icon(Icons.highlight_rounded, size: 24, color: Colors.white),
                label: const Text(
                  'BẬT ĐÈN TRẮNG TOÀN MÀN HÌNH',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onPressed: _toggleWhiteTorch,
              ),
            ),
            const SizedBox(height: 20),

            // Morse Code SOS Guide
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardDark.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.dividerDark),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.graphic_eq, color: AppColors.emergencyRedLight, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'QUY TẮC PHÁT TÍN HIỆU CỨU HỘ QUỐC TẾ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    '• Tín hiệu còi / gõ: 3 tiếng ngắn - 3 tiếng dài - 3 tiếng ngắn (··· ─── ···)\n'
                    '• Ban ngày: Vẫy mảnh vải sáng màu (đỏ/cam/vàng) theo hình số 8.\n'
                    '• Ban đêm: Bật chớp sáng ngắt quãng 3 lần rồi dừng 1 phút lặp lại.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textLightSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
