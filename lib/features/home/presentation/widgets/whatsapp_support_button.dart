import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

/// بطاقة الاقتراحات والدعم، تفتح محادثة واتساب على الرقم المحدد.
class WhatsappSupportButton extends StatelessWidget {
  const WhatsappSupportButton({super.key});

  static const String _localNumber = AppStrings.whatsappNumber;
  static const String _internationalNumber = '966555748375';

  static final Uri _chatUri = Uri.https(
    'wa.me',
    '/$_internationalNumber',
    const {
      'text':
          'السلام عليكم، لدي اقتراح أو أحتاج دعمًا في تطبيق ختمة القرآن الكريم',
    },
  );

  Future<void> _openWhatsapp(BuildContext context) async {
    var opened = false;
    try {
      opened = await launchUrl(
        _chatUri,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      opened = false;
    }
    if (opened || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.whatsappOpenFailed)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryGreen,
      borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
      child: InkWell(
        onTap: () => _openWhatsapp(context),
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _WhatsappGlyph(),
              SizedBox(width: 12.w),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.suggestionsAndSupport,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15.sp,
                        color: AppColors.white,
                      ),
                    ),
                    Text(
                      '${AppStrings.whatsappSupportSubtitle} • $_localNumber',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.white.withValues(alpha: 0.82),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WhatsappGlyph extends StatelessWidget {
  const _WhatsappGlyph();

  @override
  Widget build(BuildContext context) {
    final size = 32.sp;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _WhatsappIconPainter()),
    );
  }
}

class _WhatsappIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final green = Paint()..color = const Color(0xFF25D366);
    canvas.drawCircle(Offset(s / 2, s / 2), s / 2, green);

    final white = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final bubble = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(s * 0.52, s * 0.46), radius: s * 0.28),
      );
    bubble.moveTo(s * 0.28, s * 0.68);
    bubble.quadraticBezierTo(s * 0.18, s * 0.90, s * 0.10, s * 0.86);
    bubble.quadraticBezierTo(s * 0.30, s * 0.80, s * 0.38, s * 0.66);
    bubble.close();
    canvas.drawPath(bubble, white);

    final handset = Paint()
      ..color = const Color(0xFF25D366)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.08
      ..strokeCap = StrokeCap.round;
    final phone = Path()
      ..moveTo(s * 0.38, s * 0.40)
      ..quadraticBezierTo(s * 0.34, s * 0.52, s * 0.44, s * 0.58)
      ..quadraticBezierTo(s * 0.54, s * 0.64, s * 0.62, s * 0.52);
    canvas.drawPath(phone, handset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
