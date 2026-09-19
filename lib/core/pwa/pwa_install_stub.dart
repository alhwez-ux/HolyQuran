/// واجهة تثبيت التطبيق خارج الويب.
class PwaInstall {
  PwaInstall._();

  static bool get supported => false;

  static bool get isInstalled => false;

  static bool get canInstall => false;

  static bool get showIosGuide => false;

  static bool get shouldOfferInstall => false;

  static Future<bool> promptInstall() async => false;
}
