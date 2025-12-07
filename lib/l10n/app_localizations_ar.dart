// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'مايسيس';

  @override
  String get appTitle => 'مايسيس';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String helloUser(Object name) {
    return 'مرحباً $name';
  }

  @override
  String get newOrder => 'طلب جديد';

  @override
  String get visits => 'الزيارات';

  @override
  String get customers => 'العملاء';

  @override
  String get qoutation => 'عرض سعر';

  @override
  String get casheir => 'الصندوق';

  @override
  String get returnInvoice => 'الأرجاع';

  @override
  String get warehouse => 'المخزون';

  @override
  String get invoices => 'الفواتير';

  @override
  String get settings => 'الأعدادات';

  @override
  String get synchronization => 'المزامنة';
}
