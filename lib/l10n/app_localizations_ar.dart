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
  String get customer => 'العميل';

  @override
  String get viewEditCustomer => 'بيانات العميل أو التعديل';

  @override
  String get addCustomer => 'إضافة عميل';

  @override
  String get saveCustomer => 'حفظ العميل';

  @override
  String get updateCustomer => 'تحديث العميل';

  @override
  String get searchCustomer => 'ابحث عن عميل...';

  @override
  String get basicInfo => 'المعلومات الأساسية';

  @override
  String get customerName => 'اسم العميل';

  @override
  String get customerName2 => 'اسم العميل بالأجنبي';

  @override
  String get customerCode => 'كود العميل';

  @override
  String get customerLocation => 'موقع العميل';

  @override
  String get phone => 'الهاتف';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get taxNumber => 'الرقم الضريبي';

  @override
  String get notes => 'ملاحظات';

  @override
  String get financial => 'المالية';

  @override
  String get creditLimit => 'الحد الائتماني';

  @override
  String get active => 'نشط';

  @override
  String get inactive => 'غير نشط';

  @override
  String get address => 'العنوان';

  @override
  String get addressStreet => 'الشارع';

  @override
  String get city => 'المدينة';

  @override
  String get state => '/الأمارة/المنطقة/الولاية';

  @override
  String get country => 'البلد';

  @override
  String get contactName => 'اسم جهة الاتصال';

  @override
  String get contactPerson => 'أسم الموظف';

  @override
  String get noCustomersFound => 'لم يتم العثور على عملاء';

  @override
  String get noCustomerAdded => 'لم يتم إضافة أي عميل بعد';

  @override
  String get noPhoneFound => 'لم يتم العثور على أرقام هواتف';

  @override
  String get custSavedMsg => 'تم حفظ العميل بنجاح';

  @override
  String get copy => 'نسخ';

  @override
  String get edit => 'تعديل';

  @override
  String get tapToEdit => 'انقر هنا للتعديل';

  @override
  String get mapAddress => 'العنوان بأستخدام الخرائط المجانية';

  @override
  String get qoutation => 'عرض سعر';

  @override
  String get casheir => 'رصيد الدرج';

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

  @override
  String get products => 'المنتجات';

  @override
  String get nodbtables => 'لا يوجد جداول في قاعدة البيانات';

  @override
  String get qrReadingText => 'قراءة باركود المنتج';

  @override
  String get salesMan => 'البائع';

  @override
  String get addDiscount => 'الخصم : إضافة خصم';

  @override
  String get saudiCurrancy => 'رس';

  @override
  String get total => 'الإجمالي';

  @override
  String get payment => 'الدفع';

  @override
  String get note => 'الملاحظة';

  @override
  String get settingsTitle => 'الأعدادات';

  @override
  String get langSettings => 'إعدادات اللغة';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get changeLanguage => 'تغيير اللغة:';

  @override
  String get searchLanguage => 'ابحث عن لغة...';

  @override
  String get themeSettings => 'إعدادات المظهر';

  @override
  String get changeTheme => 'تغيير المظهر:';

  @override
  String get searchTheme => 'ابحث عن مظهر...';

  @override
  String get appDatabase => 'إعدادات قاعدة البيانات';

  @override
  String get appTables => 'جداول قاعدة البيانات:';

  @override
  String get appLocation => 'مسار قاعدة البيانات:';

  @override
  String get myBlue => 'أزرق';

  @override
  String get myGreen => 'أخضر';

  @override
  String get myYellow => 'أصفر';

  @override
  String get myPink => 'وردي';

  @override
  String get myNavy => 'كحلي';

  @override
  String get loading => 'جار التحميل...';

  @override
  String get selectTable => 'اختر جدولاً';

  @override
  String get mainwarehouse => 'المخزن الرئيسي';

  @override
  String get mainwarehouselocation => 'الموقع الرئيسي';

  @override
  String get addProduct => 'إضافة منتج';

  @override
  String get viewEditProduct => 'عرض وتعديل المنتج';

  @override
  String get productName => 'اسم المنتج';

  @override
  String get productName2 => 'اسم المنتج بالأجنبي';

  @override
  String get sku => 'كود المنتج';

  @override
  String get costPrice => 'سعر التكلفة (0.00)';

  @override
  String get sellingPrice => 'سعر البيع (0.00)';

  @override
  String get productVat => 'ضريبة المنتج (%)';

  @override
  String get totalWithTaxPrice => 'الإجمالي مع الضريبة (%)';

  @override
  String get warehouses => 'المخازن';

  @override
  String get selectWarehouse => 'اختر مخزناً';

  @override
  String get options => 'الخيارات';

  @override
  String get hasVariants => 'يحتوي على متغيرات';

  @override
  String get variants => 'المتغيرات';

  @override
  String get addVariant => 'إضافة متغير';

  @override
  String get variantName => 'اسم المتغير';

  @override
  String get variantValue => 'قيمة المتغير';

  @override
  String get remove => 'إزالة';

  @override
  String get productSavedMsg => 'تم حفظ المنتج بنجاح';

  @override
  String get saveProduct => 'حفظ المنتج';

  @override
  String get updateProduct => 'تحديث المنتج';

  @override
  String get warehouseSavedMsg => 'تم حفظ المخزن بنجاح';

  @override
  String get addWarehouse => 'أضافة مخزن';

  @override
  String get saveWarehouse => 'حفظ المخزن';

  @override
  String get warehouseName => 'اسم المخزن';

  @override
  String get warehouseLocation => 'موقع المخزن';

  @override
  String get warehouseInfo => 'معلومات المخزن';

  @override
  String get inventory => 'المخزون';

  @override
  String get openingStock => 'الرصيد الافتتاحي (>=0)';

  @override
  String get searchProduct => 'ابحث عن منتج...';

  @override
  String get noProductsFound => 'لم يتم العثور على أي منتجات';

  @override
  String get noProductAdded => 'لم يتم إضافة أي منتج';

  @override
  String get noCostPriceFound => 'لم يتم العثور على سعر التكلفة';

  @override
  String get barcodeText => 'الباركود';

  @override
  String get barcodeTitle => 'مسح باركود المنتج';
}
