import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// تثبيت تطبيق الويب التقدمي من المتصفح.
class PwaInstall {
  PwaInstall._();

  static JSObject? get _api {
    if (!globalContext.has('ahlQuranPwa')) return null;
    final value = globalContext.getProperty('ahlQuranPwa'.toJS);
    if (value.isUndefinedOrNull) return null;
    return value as JSObject;
  }

  static bool get supported => _api != null;

  static bool _boolMethod(String name) {
    final api = _api;
    if (api == null) return false;
    final result = api.callMethod(name.toJS);
    return (result as JSBoolean).toDart;
  }

  static bool get isInstalled => _boolMethod('isInstalled');

  static bool get canInstall => _boolMethod('canInstall');

  static bool get showIosGuide => _boolMethod('isIos');

  static bool get shouldOfferInstall =>
      supported && !isInstalled && (canInstall || showIosGuide);

  static Future<bool> promptInstall() async {
    final api = _api;
    if (api == null) return false;
    final result = api.callMethod('install'.toJS);
    final settled = await (result as JSPromise<JSBoolean>).toDart;
    return settled.toDart;
  }
}
