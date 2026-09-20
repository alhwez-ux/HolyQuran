import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/reading_options.dart';
import '../../../../core/theme/theme_provider.dart';

class ReadingSettingsSheet extends StatelessWidget {
  const ReadingSettingsSheet({
    super.key,
    required this.fullscreen,
    required this.onToggleFullscreen,
  });

  final bool fullscreen;
  final VoidCallback onToggleFullscreen;

  static Future<void> show({
    required BuildContext context,
    required bool fullscreen,
    required VoidCallback onToggleFullscreen,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReadingSettingsSheet(
        fullscreen: fullscreen,
        onToggleFullscreen: onToggleFullscreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<ThemeProvider>();
    final backdrop = settings.backdrop;

    return AnimatedContainer(
      duration: kReadingBackdropAnim,
      curve: Curves.easeInOut,
      color: backdrop.panel,
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.readingSettings,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: backdrop.heading,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            AppStrings.readingBackgrounds,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: backdrop.muted,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final option in ReadingBackdrop.values)
                _BackdropSwatch(
                  option: option,
                  selected: settings.backdrop == option,
                  onTap: () => settings.setBackdrop(option),
                ),
            ],
          ),
          SizedBox(height: 10.h),
          AnimatedSwitcher(
            duration: kReadingBackdropAnim,
            child: Text(
              backdrop.label,
              key: ValueKey(backdrop.name),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: backdrop.body),
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            AppStrings.pageTurnStyle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: backdrop.muted,
            ),
          ),
          SizedBox(height: 10.h),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: Text(AppStrings.pageTurnHorizontal),
                selected: settings.pageTurn == PageTurnStyle.horizontal,
                onSelected: (_) =>
                    settings.setPageTurn(PageTurnStyle.horizontal),
                selectedColor: AppColors.gold.withValues(alpha: 0.35),
                labelStyle: TextStyle(color: backdrop.heading),
              ),
              ChoiceChip(
                label: Text(AppStrings.pageTurnVertical),
                selected: settings.pageTurn == PageTurnStyle.vertical,
                onSelected: (_) =>
                    settings.setPageTurn(PageTurnStyle.vertical),
                selectedColor: AppColors.gold.withValues(alpha: 0.35),
                labelStyle: TextStyle(color: backdrop.heading),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              onToggleFullscreen();
            },
            icon: Icon(
              fullscreen
                  ? Icons.fullscreen_exit_rounded
                  : Icons.fullscreen_rounded,
            ),
            label: Text(
              fullscreen
                  ? AppStrings.exitFullscreen
                  : AppStrings.enterFullscreen,
            ),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: AppColors.white,
              minimumSize: Size(double.infinity, 46.h),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackdropSwatch extends StatelessWidget {
  const _BackdropSwatch({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final ReadingBackdrop option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: option.label,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: AnimatedContainer(
          duration: kReadingBackdropAnim,
          curve: Curves.easeInOut,
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: option.canvas,
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? AppColors.gold : option.panel,
              width: selected ? 3 : 1.2,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.35),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
          child: option.isNight
              ? Icon(
                  Icons.dark_mode_rounded,
                  size: 16,
                  color: selected ? AppColors.goldSoft : const Color(0xFFE6DCC8),
                )
              : null,
        ),
      ),
    );
  }
}
