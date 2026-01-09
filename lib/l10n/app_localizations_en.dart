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
  String get addCustomer => 'Add Customer';

  @override
  String get saveCustomer => 'Save Customer';

  @override
  String get searchCustomer => 'Search Customer...';

  @override
  String get basicInfo => 'Basic Information';

  @override
  String get customerName => 'Customer Name';

  @override
  String get customerCode => 'Customer Code';

  @override
  String get phone => 'Phone';

  @override
  String get email => 'Email';

  @override
  String get taxNumber => 'Tax Number';

  @override
  String get financial => 'Financial';

  @override
  String get creditLimit => 'Credit Limit';

  @override
  String get active => 'Active';

  @override
  String get address => 'Address';

  @override
  String get addressStreet => 'Street';

  @override
  String get city => 'City';

  @override
  String get country => 'Country';

  @override
  String get contactName => 'Contact Name';

  @override
  String get contactPerson => 'Contact Person';

  @override
  String get noCustomersFound => 'No Customers Found';

  @override
  String get custSavedMsg => 'Customer Saved Successfully';

  @override
  String get qoutation => 'Qoutation';

  @override
  String get casheir => 'Starting Cash';

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

  @override
  String get settingsTitle => 'Settings';

  @override
  String get langSettings => 'Language Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get changeLanguage => 'Change Language:';

  @override
  String get searchLanguage => 'Search Language...';

  @override
  String get themeSettings => 'Theme Settings';

  @override
  String get changeTheme => 'Change Theme:';

  @override
  String get searchTheme => 'Search Theme...';

  @override
  String get appDatabase => 'Database Settings';

  @override
  String get appTables => 'Database Tables:';

  @override
  String get appLocation => 'Database Location:';

  @override
  String get myBlue => 'Blue';

  @override
  String get myGreen => 'Green';

  @override
  String get myYellow => 'Yellow';

  @override
  String get myPink => 'Pink';

  @override
  String get myNavy => 'Navy';

  @override
  String get loading => 'Loading...';

  @override
  String get selectTable => 'Select a Table';
}
