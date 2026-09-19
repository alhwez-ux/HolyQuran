import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'core/database/hive_setup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint(details.exceptionAsString());
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Uncaught: $error\n$stack');
    return true;
  };

  await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  await HiveSetup.init();
  runApp(const QuranKhatmaApp());
}
