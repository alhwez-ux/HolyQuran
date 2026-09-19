import 'dart:js_interop';

@JS('ahlQuranPwa')
extension type _AhlQuranPwa(JSObject _) implements JSObject {
  external JSBoolean canInstall();
  external JSBoolean isInstalled();
  external JSBoolean isIos();
  external JSPromise<JSBoolean> install();
}

@JS('ahlQuranPwa')
external _AhlQuranPwa? get _pwa;

/// تثبيت تطبيق الويب التقدمي من المتصفح.
class PwaInstall {
  PwaInstall._();

  static bool get supported => _pwa != null;

  static bool get isInstalled => _pwa?.isInstalled().toDart ?? false;

  static bool get canInstall => _pwa?.canInstall().toDart ?? false;

  static bool get showIosGuide => _pwa?.isIos().toDart ?? false;

  static bool get shouldOfferInstall =>
      supported && !isInstalled && (canInstall || showIosGuide);

  static Future<bool> promptInstall() async {
    final api = _pwa;
    if (api == null) return false;
    final result = await api.install().toDart;
    return result.toDart;
  }
}
