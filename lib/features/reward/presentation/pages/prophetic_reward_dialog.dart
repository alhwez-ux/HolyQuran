import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/database/hive_boxes.dart';
import '../../../streak/presentation/providers/streak_provider.dart';
import '../../data/prophetic_rewards.dart';

class PropheticRewardDialog extends StatelessWidget {
  const PropheticRewardDialog({super.key});

  static Future<void> show(BuildContext context) async {
    await _updateUserStreak(context);
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PropheticRewardDialog(),
    );
  }

  static Future<void> _updateUserStreak(BuildContext context) async {
    final streak = context.read<StreakProvider>();
    await streak.recordToday();
    final progressBox = Hive.box<dynamic>(HiveBoxes.progress);
    final streakBox = Hive.box<dynamic>(HiveBoxes.streak);
    await progressBox.put('streak_count', streak.streak.current);
    await streakBox.put('current', streak.streak.current);
    await streakBox.put('longest', streak.streak.longest);
  }

  Future<void> _shareReward(
    BuildContext context,
    Map<String, String> reward,
  ) async {
    final text = [
      reward['title'] ?? '',
      reward['hadith'] ?? '',
      reward['reference'] ?? '',
    ].where((line) => line.isNotEmpty).join('\n\n');

    await SharePlus.instance.share(ShareParams(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نسخ البطاقة لمشاركتها')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reward = PropheticRewardModel.getRandomReward();
    final maxHeight = MediaQuery.sizeOf(context).height * 0.86;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      backgroundColor: AppColors.cardBg,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 440, maxHeight: maxHeight),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.goldAccent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome,
                  size: 40.sp,
                  color: AppColors.goldAccent,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                reward['title'] ?? 'هنيئاً لك الإنجاز',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.goldAccent.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  reward['hadith'] ?? '',
                  style: TextStyle(
                    fontSize: 16.sp,
                    height: 1.6,
                    color: AppColors.textDark,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                reward['reference'] ?? '',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              _DialogActions(
                onShare: () => _shareReward(context, reward),
                onClose: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogActions extends StatelessWidget {
  const _DialogActions({required this.onShare, required this.onClose});

  final VoidCallback onShare;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final shareButton = OutlinedButton.icon(
      onPressed: onShare,
      icon: const Icon(Icons.share_rounded, size: 18),
      label: const Text('مشاركة الأجر'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryGreen,
        side: const BorderSide(color: AppColors.primaryGreen),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
    final closeButton = ElevatedButton(
      onPressed: onClose,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      child: const Text('الحمد لله'),
    );

    if (MediaQuery.sizeOf(context).width < 360) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          shareButton,
          SizedBox(height: 10.h),
          closeButton,
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: shareButton),
        SizedBox(width: 12.w),
        Expanded(child: closeButton),
      ],
    );
  }
}
