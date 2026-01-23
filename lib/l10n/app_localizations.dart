import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'MySys'**
  String get appName;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'MySystem'**
  String get appTitle;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello {name}'**
  String helloUser(Object name);

  /// No description provided for @newOrder.
  ///
  /// In en, this message translates to:
  /// **'New Order'**
  String get newOrder;

  /// No description provided for @visits.
  ///
  /// In en, this message translates to:
  /// **'Visits'**
  String get visits;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @viewEditCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer Data & Update'**
  String get viewEditCustomer;

  /// No description provided for @addCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get addCustomer;

  /// No description provided for @saveCustomer.
  ///
  /// In en, this message translates to:
  /// **'Save Customer'**
  String get saveCustomer;

  /// No description provided for @updateCustomer.
  ///
  /// In en, this message translates to:
  /// **'Update Customer'**
  String get updateCustomer;

  /// No description provided for @searchCustomer.
  ///
  /// In en, this message translates to:
  /// **'Search Customer...'**
  String get searchCustomer;

  /// No description provided for @basicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInfo;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerName;

  /// No description provided for @customerName2.
  ///
  /// In en, this message translates to:
  /// **'Customer Foreign Name'**
  String get customerName2;

  /// No description provided for @customerCode.
  ///
  /// In en, this message translates to:
  /// **'Customer Code'**
  String get customerCode;

  /// No description provided for @customerLocation.
  ///
  /// In en, this message translates to:
  /// **'Customer Location'**
  String get customerLocation;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @taxNumber.
  ///
  /// In en, this message translates to:
  /// **'Tax Number'**
  String get taxNumber;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @financial.
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get financial;

  /// No description provided for @creditLimit.
  ///
  /// In en, this message translates to:
  /// **'Credit Limit'**
  String get creditLimit;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @addressStreet.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get addressStreet;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @contactName.
  ///
  /// In en, this message translates to:
  /// **'Contact Name'**
  String get contactName;

  /// No description provided for @contactPerson.
  ///
  /// In en, this message translates to:
  /// **'Contact Person'**
  String get contactPerson;

  /// No description provided for @noCustomersFound.
  ///
  /// In en, this message translates to:
  /// **'No Customers Found'**
  String get noCustomersFound;

  /// No description provided for @noCustomerAdded.
  ///
  /// In en, this message translates to:
  /// **'No Customer Added Yet'**
  String get noCustomerAdded;

  /// No description provided for @noPhoneFound.
  ///
  /// In en, this message translates to:
  /// **'No Phone Numbers Found'**
  String get noPhoneFound;

  /// No description provided for @custSavedMsg.
  ///
  /// In en, this message translates to:
  /// **'Customer Saved Successfully'**
  String get custSavedMsg;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @tapToEdit.
  ///
  /// In en, this message translates to:
  /// **'Tap here to Edit'**
  String get tapToEdit;

  /// No description provided for @mapAddress.
  ///
  /// In en, this message translates to:
  /// **'The address using free maps'**
  String get mapAddress;

  /// No description provided for @qoutation.
  ///
  /// In en, this message translates to:
  /// **'Qoutation'**
  String get qoutation;

  /// No description provided for @casheir.
  ///
  /// In en, this message translates to:
  /// **'Starting Cash'**
  String get casheir;

  /// No description provided for @returnInvoice.
  ///
  /// In en, this message translates to:
  /// **'Return Invoice'**
  String get returnInvoice;

  /// No description provided for @warehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get warehouse;

  /// No description provided for @invoices.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoices;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @synchronization.
  ///
  /// In en, this message translates to:
  /// **'Synchronization'**
  String get synchronization;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @nodbtables.
  ///
  /// In en, this message translates to:
  /// **'No Tables in Database'**
  String get nodbtables;

  /// No description provided for @qrReadingText.
  ///
  /// In en, this message translates to:
  /// **'Reading Product\'s QR'**
  String get qrReadingText;

  /// No description provided for @salesMan.
  ///
  /// In en, this message translates to:
  /// **'Sales Man'**
  String get salesMan;

  /// No description provided for @addDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount : Add Discount'**
  String get addDiscount;

  /// No description provided for @saudiCurrancy.
  ///
  /// In en, this message translates to:
  /// **'sar'**
  String get saudiCurrancy;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get payment;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @langSettings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get langSettings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language:'**
  String get changeLanguage;

  /// No description provided for @searchLanguage.
  ///
  /// In en, this message translates to:
  /// **'Search Language...'**
  String get searchLanguage;

  /// No description provided for @themeSettings.
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get themeSettings;

  /// No description provided for @changeTheme.
  ///
  /// In en, this message translates to:
  /// **'Change Theme:'**
  String get changeTheme;

  /// No description provided for @searchTheme.
  ///
  /// In en, this message translates to:
  /// **'Search Theme...'**
  String get searchTheme;

  /// No description provided for @appDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database Settings'**
  String get appDatabase;

  /// No description provided for @appTables.
  ///
  /// In en, this message translates to:
  /// **'Database Tables:'**
  String get appTables;

  /// No description provided for @appLocation.
  ///
  /// In en, this message translates to:
  /// **'Database Location:'**
  String get appLocation;

  /// No description provided for @myBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get myBlue;

  /// No description provided for @myGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get myGreen;

  /// No description provided for @myYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get myYellow;

  /// No description provided for @myPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get myPink;

  /// No description provided for @myNavy.
  ///
  /// In en, this message translates to:
  /// **'Navy'**
  String get myNavy;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @selectTable.
  ///
  /// In en, this message translates to:
  /// **'Select a Table'**
  String get selectTable;

  /// No description provided for @mainwarehouse.
  ///
  /// In en, this message translates to:
  /// **'Main Warehouse'**
  String get mainwarehouse;

  /// No description provided for @mainwarehouselocation.
  ///
  /// In en, this message translates to:
  /// **'Main Location'**
  String get mainwarehouselocation;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// No description provided for @viewEditProduct.
  ///
  /// In en, this message translates to:
  /// **'View & Edit Product'**
  String get viewEditProduct;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @productName2.
  ///
  /// In en, this message translates to:
  /// **'Product Foreign Name'**
  String get productName2;

  /// No description provided for @sku.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get sku;

  /// No description provided for @costPrice.
  ///
  /// In en, this message translates to:
  /// **'Cost Price (0.00)'**
  String get costPrice;

  /// No description provided for @sellingPrice.
  ///
  /// In en, this message translates to:
  /// **'Selling Price (0.00)'**
  String get sellingPrice;

  /// No description provided for @productVat.
  ///
  /// In en, this message translates to:
  /// **'Product VAT (%)'**
  String get productVat;

  /// No description provided for @totalWithTaxPrice.
  ///
  /// In en, this message translates to:
  /// **'Total with Tax (%)'**
  String get totalWithTaxPrice;

  /// No description provided for @warehouses.
  ///
  /// In en, this message translates to:
  /// **'Warehouses'**
  String get warehouses;

  /// No description provided for @selectWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Select Warehouse'**
  String get selectWarehouse;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @hasVariants.
  ///
  /// In en, this message translates to:
  /// **'Has Variants'**
  String get hasVariants;

  /// No description provided for @variants.
  ///
  /// In en, this message translates to:
  /// **'Variants'**
  String get variants;

  /// No description provided for @addVariant.
  ///
  /// In en, this message translates to:
  /// **'Add Variant'**
  String get addVariant;

  /// No description provided for @variantName.
  ///
  /// In en, this message translates to:
  /// **'Variant Name'**
  String get variantName;

  /// No description provided for @variantValue.
  ///
  /// In en, this message translates to:
  /// **'Variant Value'**
  String get variantValue;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @productSavedMsg.
  ///
  /// In en, this message translates to:
  /// **'Product Saved Successfully'**
  String get productSavedMsg;

  /// No description provided for @saveProduct.
  ///
  /// In en, this message translates to:
  /// **'Save Product'**
  String get saveProduct;

  /// No description provided for @updateProduct.
  ///
  /// In en, this message translates to:
  /// **'Update Product'**
  String get updateProduct;

  /// No description provided for @warehouseSavedMsg.
  ///
  /// In en, this message translates to:
  /// **'Warehouse Saved Successfully'**
  String get warehouseSavedMsg;

  /// No description provided for @addWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Add Warehouse'**
  String get addWarehouse;

  /// No description provided for @saveWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Save Warehouse'**
  String get saveWarehouse;

  /// No description provided for @warehouseName.
  ///
  /// In en, this message translates to:
  /// **'Warehouse Name'**
  String get warehouseName;

  /// No description provided for @warehouseLocation.
  ///
  /// In en, this message translates to:
  /// **'Warehouse Location'**
  String get warehouseLocation;

  /// No description provided for @warehouseInfo.
  ///
  /// In en, this message translates to:
  /// **'Warehouse Information'**
  String get warehouseInfo;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @openingStock.
  ///
  /// In en, this message translates to:
  /// **'Opening Stock (>=0)'**
  String get openingStock;

  /// No description provided for @searchProduct.
  ///
  /// In en, this message translates to:
  /// **'Search Product...'**
  String get searchProduct;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No Products Found'**
  String get noProductsFound;

  /// No description provided for @noProductAdded.
  ///
  /// In en, this message translates to:
  /// **'No Product Added Yet'**
  String get noProductAdded;

  /// No description provided for @noCostPriceFound.
  ///
  /// In en, this message translates to:
  /// **'No Cost Price Found'**
  String get noCostPriceFound;

  /// No description provided for @barcodeText.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcodeText;

  /// No description provided for @barcodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Product Barcode'**
  String get barcodeTitle;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
