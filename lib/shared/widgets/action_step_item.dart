import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ActionStepItem extends StatelessWidget {
  final int index;
  final String text;
  final Color? accentColor;

  const ActionStepItem({
    super.key,
    required this.index,
    required this.text,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = accentColor ?? AppColors.emergencyRed;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: effectiveColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: effectiveColor, width: 1.2),
            ),
            child: Text(
              '$index',
              style: TextStyle(
                color: effectiveColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textLightPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
