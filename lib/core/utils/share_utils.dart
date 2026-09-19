import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

/// التقاط بطاقة الحديث ومشاركتها كصورة مع النص دون الاعتماد على dart:io.
class ShareUtils {
  ShareUtils._();

  static Future<void> shareWidgetCard({
    required GlobalKey key,
    required String text,
  }) async {
    try {
      final context = key.currentContext;
      if (context == null) {
        await SharePlus.instance.share(ShareParams(text: text));
        return;
      }

      final boundary = context.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        await SharePlus.instance.share(ShareParams(text: text));
        return;
      }

      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        await SharePlus.instance.share(ShareParams(text: text));
        return;
      }

      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              byteData.buffer.asUint8List(),
              mimeType: 'image/png',
              name: 'hadith.png',
            ),
          ],
          text: text,
        ),
      );
    } catch (_) {
      await SharePlus.instance.share(ShareParams(text: text));
    }
  }
}
