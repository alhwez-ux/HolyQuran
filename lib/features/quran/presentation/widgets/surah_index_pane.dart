import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/surah.dart';
import '../providers/quran_provider.dart';
import 'surah_tile.dart';

/// فهرس السور للهاتف (درج) وللشاشات العريضة (عمود جانبي).
class SurahIndexPane extends StatelessWidget {
  const SurahIndexPane({
    super.key,
    required this.onSelect,
    this.selectedSurahNumber,
    this.compact = false,
  });

  final ValueChanged<Surah> onSelect;
  final int? selectedSurahNumber;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final quran = context.watch<QuranProvider>();

    return ColoredBox(
      color: AppColors.panel(context),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, compact ? 8.h : 12.h, 12.w, 8.h),
            child: TextField(
              onChanged: quran.search,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: AppStrings.searchSurah,
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
          ),
          Expanded(
            child: quran.surahs.isEmpty
                ? Center(
                    child: Text(
                      AppStrings.noResults,
                      style: TextStyle(color: AppColors.subtle(context), fontSize: 14.sp),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 16.h),
                    itemCount: quran.surahs.length,
                    separatorBuilder: (_, __) => SizedBox(height: 8.h),
                    itemBuilder: (context, index) {
                      final surah = quran.surahs[index];
                      return SurahTile(
                        surah: surah,
                        selected: surah.number == selectedSurahNumber,
                        compact: compact,
                        onTap: () => onSelect(surah),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
