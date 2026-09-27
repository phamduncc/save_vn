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
                  'FULL-SCREEN FLASHLIGHT',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tap anywhere to turn off',
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
        title: 'S.O.S Rescue Tools',
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
                      'Use a high-intensity flashing light to attract helicopters or rescue teams at night.',
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
                      _isFlashing ? 'STOP FLASH' : 'S.O.S FLASH',
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
                  'TURN ON FULL-SCREEN WHITE LIGHT',
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
                        'INTERNATIONAL DISTRESS SIGNALS',
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
                    '• Whistle or knock: 3 short, 3 long, 3 short (··· ─── ···)\n'
                    '• By day: wave a bright cloth (red, orange, or yellow) in a figure-eight.\n'
                    '• At night: flash the light 3 times, pause for 1 minute, then repeat.',
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
