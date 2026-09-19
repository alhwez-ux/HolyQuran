import 'package:flutter/material.dart';

class Achievement {
  const Achievement({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.unlocked,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool unlocked;

  static List<Achievement> fromProgress({
    required int streakDays,
    required int longestStreak,
    required int completedJuz,
    required bool started,
  }) {
    return [
      Achievement(
        title: 'أول خطوة',
        subtitle: 'بدأت رحلة الختمة',
        icon: Icons.menu_book_rounded,
        unlocked: started,
      ),
      Achievement(
        title: 'مواظب',
        subtitle: '3 أيام متتالية',
        icon: Icons.local_fire_department_rounded,
        unlocked: streakDays >= 3 || longestStreak >= 3,
      ),
      Achievement(
        title: 'أسبوع نور',
        subtitle: '7 أيام متتالية',
        icon: Icons.wb_sunny_rounded,
        unlocked: streakDays >= 7 || longestStreak >= 7,
      ),
      Achievement(
        title: 'همة شهر',
        subtitle: '30 يوماً متتالياً',
        icon: Icons.emoji_events_rounded,
        unlocked: streakDays >= 30 || longestStreak >= 30,
      ),
      Achievement(
        title: 'جزء مبارك',
        subtitle: 'أتممت الجزء الأول',
        icon: Icons.looks_one_rounded,
        unlocked: completedJuz >= 1,
      ),
      Achievement(
        title: 'ربع القرآن',
        subtitle: '8 أجزاء مكتملة',
        icon: Icons.brightness_low_rounded,
        unlocked: completedJuz >= 8,
      ),
      Achievement(
        title: 'نصف الختمة',
        subtitle: '15 جزءاً مكتملاً',
        icon: Icons.brightness_medium_rounded,
        unlocked: completedJuz >= 15,
      ),
      Achievement(
        title: 'الختمة',
        subtitle: '30 جزءاً.. أتممت المصحف',
        icon: Icons.workspace_premium_rounded,
        unlocked: completedJuz >= 30,
      ),
    ];
  }
}
