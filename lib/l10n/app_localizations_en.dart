// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'MySys';

  @override
  String get appTitle => 'MySystem';

  @override
  String get signup => 'Sign Up';

  @override
  String get login => 'Login';

  @override
  String helloUser(Object name) {
    return 'Hello $name';
  }

  @override
  String get newOrder => 'New Order';

  @override
  String get visits => 'Visits';

  @override
  String get customers => 'Customers';

  @override
  String get customer => 'Customer';

  @override
  String get qoutation => 'Qoutation';

  @override
  String get casheir => 'Casheir';

  @override
  String get returnInvoice => 'Return Invoice';

  @override
  String get warehouse => 'Warehouse';

  @override
  String get invoices => 'Invoice';

  @override
  String get settings => 'Settings';

  @override
  String get synchronization => 'Synchronization';

  @override
  String get qrReadingText => 'Reading Product\'s QR';

  @override
  String get salesMan => 'Sales Man';

  @override
  String get addDiscount => 'Discount : Add Discount';

  @override
  String get saudiCurrancy => 'sar';

  @override
  String get total => 'Total';

  @override
  String get payment => 'Pay';

  @override
  String get note => 'Note';
}
