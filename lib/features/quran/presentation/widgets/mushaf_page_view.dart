import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/mushaf_assets.dart';
import '../../../../core/theme/reading_options.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../domain/entities/ayah.dart';
import '../providers/quran_provider.dart';
import 'mushaf_text_page.dart';

/// صفحة مصحف مجمع الملك فهد من الأصول المحلية، مع لمس لحفظ آية التوقف.
class MushafPageView extends StatefulWidget {
  const MushafPageView({
    super.key,
    required this.pageNumber,
    this.fullscreen = false,
    this.onAyahTap,
  });

  final int pageNumber;
  final bool fullscreen;
  final ValueChanged<Ayah>? onAyahTap;

  @override
  State<MushafPageView> createState() => _MushafPageViewState();
}

class _MushafPageViewState extends State<MushafPageView> {
  Offset? _marker;

  void _saveAyahAt(Offset local, Size size) {
    if (size.height <= 0 || widget.onAyahTap == null) return;
    final ayah = context.read<QuranProvider>().ayahAtPageFraction(
          widget.pageNumber,
          local.dy / size.height,
        );
    if (ayah == null) return;
    setState(() => _marker = local);
    widget.onAyahTap!(ayah);
    final captured = local;
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (mounted && _marker == captured) {
        setState(() => _marker = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final backdrop = context.watch<ThemeProvider>().backdrop;
    final centered = MushafAssets.usesCenteredLayout(widget.pageNumber);
    final page = Image.asset(
      MushafAssets.pagePath(widget.pageNumber),
      fit: BoxFit.contain,
      alignment: centered ? Alignment.center : Alignment.topCenter,
      filterQuality: FilterQuality.high,
      gaplessPlayback: true,
      errorBuilder: (_, __, ___) => MushafTextPage(
        pageNumber: widget.pageNumber,
        fullscreen: widget.fullscreen,
        onAyahTap: widget.onAyahTap,
      ),
    );

    Widget content = page;
    if (backdrop.isNight) {
      content = ColorFiltered(
        colorFilter: AppColors.nightPageFilter,
        child: page,
      );
    }

    return ColoredBox(
      color: backdrop.canvas,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.fullscreen ? 4 : 8,
          vertical: widget.fullscreen ? 4 : 6,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) => _saveAyahAt(details.localPosition, size),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  content,
                  if (_marker != null)
                    Positioned(
                      left: _marker!.dx - 16,
                      top: _marker!.dy - 16,
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.92),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gold.withValues(alpha: 0.45),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const SizedBox(
                            width: 32,
                            height: 32,
                            child: Icon(
                              Icons.bookmark_added_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
