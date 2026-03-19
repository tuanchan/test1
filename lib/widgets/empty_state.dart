import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const EmptyState({super.key, required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                  color: AppColors.accentDim, shape: BoxShape.circle),
              child: Icon(icon, size: 26, color: AppColors.accent),
            ),
            const SizedBox(height: 16),
            Text(title, style: AppTextStyles.title2, textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(subtitle,
                style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
