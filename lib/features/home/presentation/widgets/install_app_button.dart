import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/pwa/pwa_install.dart';

/// زر تثبيت التطبيق على الجهاز (PWA) يظهر على الويب فقط.
class InstallAppButton extends StatefulWidget {
  const InstallAppButton({super.key});

  @override
  State<InstallAppButton> createState() => _InstallAppButtonState();
}

class _InstallAppButtonState extends State<InstallAppButton> {
  Timer? _timer;
  bool _installed = false;
  bool _canInstall = false;
  bool _iosGuide = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;
    _refresh();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _refresh());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _refresh() {
    final installed = PwaInstall.isInstalled;
    final canInstall = PwaInstall.canInstall;
    final iosGuide = PwaInstall.showIosGuide;
    if (!mounted) return;
    if (installed == _installed &&
        canInstall == _canInstall &&
        iosGuide == _iosGuide) {
      return;
    }
    setState(() {
      _installed = installed;
      _canInstall = canInstall;
      _iosGuide = iosGuide;
    });
  }

  Future<void> _onTap() async {
    if (_canInstall) {
      final accepted = await PwaInstall.promptInstall();
      if (!mounted) return;
      _refresh();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            accepted ? AppStrings.installAccepted : AppStrings.installDismissed,
          ),
        ),
      );
      return;
    }
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 28.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.installApp,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryGreen,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                _iosGuide
                    ? AppStrings.installIosHint
                    : AppStrings.installBrowserHint,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, height: 1.7),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb || _installed) return const SizedBox.shrink();

    return Material(
      color: AppColors.card(context),
      borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
      child: InkWell(
        onTap: _onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.45)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.install_mobile_rounded,
                color: AppColors.goldAccent,
                size: 28.sp,
              ),
              SizedBox(width: 12.w),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.installApp,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15.sp,
                        color: AppColors.heading(context),
                      ),
                    ),
                    Text(
                      AppStrings.installAppSubtitle,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.subtle(context),
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
