import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('fr'),
    Locale('en')
  ];

  /// No description provided for @settings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settings;

  /// No description provided for @security.
  ///
  /// In ar, this message translates to:
  /// **'الأمان'**
  String get security;

  /// No description provided for @securityMessage.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن تكون مسجلاً للدخول للوصول إلى إعدادات الأمان'**
  String get securityMessage;

  /// No description provided for @lightMode.
  ///
  /// In ar, this message translates to:
  /// **'الوضع المضيء'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In ar, this message translates to:
  /// **'الوضع المظلم'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notifications;

  /// No description provided for @contactUs.
  ///
  /// In ar, this message translates to:
  /// **'اتصل بنا'**
  String get contactUs;

  /// No description provided for @loginToContactSupport.
  ///
  /// In ar, this message translates to:
  /// **'يرجى تسجيل الدخول للتواصل مع الدعم'**
  String get loginToContactSupport;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @alertWarning.
  ///
  /// In ar, this message translates to:
  /// **' تحذير !'**
  String get alertWarning;

  /// No description provided for @confirmLogout.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد أنك تريد تسجيل الخروج؟'**
  String get confirmLogout;

  /// No description provided for @no.
  ///
  /// In ar, this message translates to:
  /// **'لا'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In ar, this message translates to:
  /// **'نعم'**
  String get yes;

  /// No description provided for @followers.
  ///
  /// In ar, this message translates to:
  /// **'المتابِعون'**
  String get followers;

  /// No description provided for @following.
  ///
  /// In ar, this message translates to:
  /// **'المتابَعون'**
  String get following;

  /// No description provided for @follow.
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get follow;

  /// No description provided for @unfollow.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء المتابعة'**
  String get unfollow;

  /// No description provided for @noItemsYet.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد عناصر بعد'**
  String get noItemsYet;

  /// No description provided for @noSavedItems.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد عناصر محفوظة حتى الآن'**
  String get noSavedItems;

  /// No description provided for @edit_profile.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الملف الشخصي'**
  String get edit_profile;

  /// No description provided for @chooseImageSource.
  ///
  /// In ar, this message translates to:
  /// **'اختر مصدر الصورة'**
  String get chooseImageSource;

  /// No description provided for @select_from_gallery.
  ///
  /// In ar, this message translates to:
  /// **'اختيار من المعرض'**
  String get select_from_gallery;

  /// No description provided for @capture_with_camera.
  ///
  /// In ar, this message translates to:
  /// **'التقاط باستخدام الكاميرا'**
  String get capture_with_camera;

  /// No description provided for @no_changes_detected.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تغييرات'**
  String get no_changes_detected;

  /// No description provided for @profile_updated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث الملف الشخصي بنجاح'**
  String get profile_updated;

  /// No description provided for @error.
  ///
  /// In ar, this message translates to:
  /// **'خطأ '**
  String get error;

  /// No description provided for @firstName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In ar, this message translates to:
  /// **'اللقب'**
  String get lastName;

  /// No description provided for @phoneNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get phoneNumber;

  /// No description provided for @selectWilaya.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار الولاية'**
  String get selectWilaya;

  /// No description provided for @selectDaira.
  ///
  /// In ar, this message translates to:
  /// **'اختر الدائرة'**
  String get selectDaira;

  /// No description provided for @submit.
  ///
  /// In ar, this message translates to:
  /// **'إرسال'**
  String get submit;

  /// No description provided for @firstNameError.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال الاسم'**
  String get firstNameError;

  /// No description provided for @lastNameError.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال اللقب'**
  String get lastNameError;

  /// No description provided for @phoneNumError.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال رقم الهاتف'**
  String get phoneNumError;

  /// No description provided for @phoneNumLengthError.
  ///
  /// In ar, this message translates to:
  /// **'يرجى ادخال 10 ارقام'**
  String get phoneNumLengthError;

  /// No description provided for @wilayaError.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار الولاية'**
  String get wilayaError;

  /// No description provided for @dairaError.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار الدائرة'**
  String get dairaError;

  /// No description provided for @updateEmail.
  ///
  /// In ar, this message translates to:
  /// **'تحديث البريد الإلكتروني'**
  String get updateEmail;

  /// No description provided for @updatePhoneNumber.
  ///
  /// In ar, this message translates to:
  /// **'تحديث رقم الهاتف'**
  String get updatePhoneNumber;

  /// No description provided for @enterNewEmail.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بريدًا إلكترونيًا جديدًا'**
  String get enterNewEmail;

  /// No description provided for @enterNewPhoneNumber.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم هاتف جديد'**
  String get enterNewPhoneNumber;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @emailOptions.
  ///
  /// In ar, this message translates to:
  /// **'خيارات البريد الإلكتروني'**
  String get emailOptions;

  /// No description provided for @phoneOptions.
  ///
  /// In ar, this message translates to:
  /// **'خيارات رقم الهاتف'**
  String get phoneOptions;

  /// No description provided for @changeEmail.
  ///
  /// In ar, this message translates to:
  /// **'تغيير البريد الإلكتروني'**
  String get changeEmail;

  /// No description provided for @changePhoneNumber.
  ///
  /// In ar, this message translates to:
  /// **'تغيير رقم الهاتف'**
  String get changePhoneNumber;

  /// No description provided for @deleteEmail.
  ///
  /// In ar, this message translates to:
  /// **'حذف البريد الإلكتروني'**
  String get deleteEmail;

  /// No description provided for @deletePhoneNumber.
  ///
  /// In ar, this message translates to:
  /// **'حذف رقم الهاتف'**
  String get deletePhoneNumber;

  /// No description provided for @changePassword.
  ///
  /// In ar, this message translates to:
  /// **'تغيير كلمة المرور'**
  String get changePassword;

  /// No description provided for @oldPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور القديمة'**
  String get oldPassword;

  /// No description provided for @newPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور الجديدة'**
  String get newPassword;

  /// No description provided for @attention.
  ///
  /// In ar, this message translates to:
  /// **' ⚠️ تنبيه '**
  String get attention;

  /// No description provided for @confirmDeleteAccount.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد أنك تريد حذف هذا الحساب؟'**
  String get confirmDeleteAccount;

  /// No description provided for @confirmDeleteItem.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد أنك تريد حذف '**
  String get confirmDeleteItem;

  /// No description provided for @privacySecurity.
  ///
  /// In ar, this message translates to:
  /// **'الخصوصية والأمان'**
  String get privacySecurity;

  /// No description provided for @securityMessage2.
  ///
  /// In ar, this message translates to:
  /// **'قم بتمكين خيارات مصادقة متعددة لتعزيز أمان حسابك'**
  String get securityMessage2;

  /// No description provided for @mediumSecurity.
  ///
  /// In ar, this message translates to:
  /// **'أمان متوسط'**
  String get mediumSecurity;

  /// No description provided for @contactInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات الاتصال'**
  String get contactInfo;

  /// No description provided for @email.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get email;

  /// No description provided for @securityCard.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة الأمان'**
  String get securityCard;

  /// No description provided for @accountManagement.
  ///
  /// In ar, this message translates to:
  /// **'إدارة الحساب'**
  String get accountManagement;

  /// No description provided for @deleteAccount.
  ///
  /// In ar, this message translates to:
  /// **'حذف الحساب'**
  String get deleteAccount;

  /// No description provided for @account.
  ///
  /// In ar, this message translates to:
  /// **'الحساب'**
  String get account;

  /// No description provided for @yourEmail.
  ///
  /// In ar, this message translates to:
  /// **'بريدك الإلكتروني'**
  String get yourEmail;

  /// No description provided for @yourName.
  ///
  /// In ar, this message translates to:
  /// **'اسمك'**
  String get yourName;

  /// No description provided for @subject.
  ///
  /// In ar, this message translates to:
  /// **'الموضوع'**
  String get subject;

  /// No description provided for @describeProblem.
  ///
  /// In ar, this message translates to:
  /// **'صف مشكلتك'**
  String get describeProblem;

  /// No description provided for @sendReport.
  ///
  /// In ar, this message translates to:
  /// **'إرسال التقرير'**
  String get sendReport;

  /// No description provided for @reportAProblem.
  ///
  /// In ar, this message translates to:
  /// **'الإبلاغ عن مشكلة'**
  String get reportAProblem;

  /// No description provided for @emailSentSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال البريد الإلكتروني بنجاح '**
  String get emailSentSuccess;

  /// No description provided for @emailSendError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء إرسال البريد الإلكتروني ❌'**
  String get emailSendError;

  /// No description provided for @rent.
  ///
  /// In ar, this message translates to:
  /// **'الإيجار'**
  String get rent;

  /// No description provided for @repairs.
  ///
  /// In ar, this message translates to:
  /// **'الإصلاحات'**
  String get repairs;

  /// No description provided for @consultation.
  ///
  /// In ar, this message translates to:
  /// **'الاستشارة'**
  String get consultation;

  /// No description provided for @hireWorker.
  ///
  /// In ar, this message translates to:
  /// **'توظيف عامل'**
  String get hireWorker;

  /// No description provided for @transportation.
  ///
  /// In ar, this message translates to:
  /// **'النقل'**
  String get transportation;

  /// No description provided for @expertise.
  ///
  /// In ar, this message translates to:
  /// **'الخبرة'**
  String get expertise;

  /// No description provided for @pageNotFound.
  ///
  /// In ar, this message translates to:
  /// **'الصفحة غير موجودة'**
  String get pageNotFound;

  /// No description provided for @all_wilayas.
  ///
  /// In ar, this message translates to:
  /// **'جميع الولايات'**
  String get all_wilayas;

  /// No description provided for @all_dairas.
  ///
  /// In ar, this message translates to:
  /// **'جميع الدوائر'**
  String get all_dairas;

  /// No description provided for @featured_transportations.
  ///
  /// In ar, this message translates to:
  /// **'خدمات النقل المميزة'**
  String get featured_transportations;

  /// No description provided for @no_transport_services_found.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد خدمات نقل'**
  String get no_transport_services_found;

  /// No description provided for @error_fetching_data.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء جلب البيانات'**
  String get error_fetching_data;

  /// No description provided for @transport_service.
  ///
  /// In ar, this message translates to:
  /// **'خدمة النقل'**
  String get transport_service;

  /// No description provided for @repairServices.
  ///
  /// In ar, this message translates to:
  /// **'خدمات التصليح'**
  String get repairServices;

  /// No description provided for @featuredRepairs.
  ///
  /// In ar, this message translates to:
  /// **'خدمات التصليح المميزة'**
  String get featuredRepairs;

  /// No description provided for @errorFetchingData.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء جلب البيانات'**
  String get errorFetchingData;

  /// No description provided for @noRepairServicesFound.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم العثور على خدمات تصليح'**
  String get noRepairServicesFound;

  /// No description provided for @rent_services.
  ///
  /// In ar, this message translates to:
  /// **'خدمات الإيجار'**
  String get rent_services;

  /// No description provided for @featured_rent.
  ///
  /// In ar, this message translates to:
  /// **'الإيجارات المميزة'**
  String get featured_rent;

  /// No description provided for @no_rent_services_found.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم العثور على خدمات للإيجار'**
  String get no_rent_services_found;

  /// No description provided for @expertise_services.
  ///
  /// In ar, this message translates to:
  /// **'خدمات الخبرة'**
  String get expertise_services;

  /// No description provided for @featured_expertise.
  ///
  /// In ar, this message translates to:
  /// **'أبرز الخبرات'**
  String get featured_expertise;

  /// No description provided for @no_expertise_found.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم العثور على خدمات الخبرة'**
  String get no_expertise_found;

  /// No description provided for @no_veterinarians_found.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد أطباء بيطريين'**
  String get no_veterinarians_found;

  /// No description provided for @messages.
  ///
  /// In ar, this message translates to:
  /// **'الرسائل'**
  String get messages;

  /// No description provided for @noMessages.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد رسائل بعد'**
  String get noMessages;

  /// No description provided for @messageHint.
  ///
  /// In ar, this message translates to:
  /// **'رسالة...'**
  String get messageHint;

  /// No description provided for @transporteur.
  ///
  /// In ar, this message translates to:
  /// **'ناقل'**
  String get transporteur;

  /// No description provided for @veterinaire.
  ///
  /// In ar, this message translates to:
  /// **'بيطري'**
  String get veterinaire;

  /// No description provided for @expertAgri.
  ///
  /// In ar, this message translates to:
  /// **'خبير زراعي'**
  String get expertAgri;

  /// No description provided for @reparateur.
  ///
  /// In ar, this message translates to:
  /// **'مصلح'**
  String get reparateur;

  /// No description provided for @entreprise.
  ///
  /// In ar, this message translates to:
  /// **'شركة'**
  String get entreprise;

  /// No description provided for @commercant.
  ///
  /// In ar, this message translates to:
  /// **'تاجر'**
  String get commercant;

  /// No description provided for @agriculteur.
  ///
  /// In ar, this message translates to:
  /// **'فلاح'**
  String get agriculteur;

  /// No description provided for @eleveur.
  ///
  /// In ar, this message translates to:
  /// **'مربي الماشية'**
  String get eleveur;

  /// No description provided for @client.
  ///
  /// In ar, this message translates to:
  /// **'عميل'**
  String get client;

  /// No description provided for @identityFront.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة التعريف الوطنية (الوجه)'**
  String get identityFront;

  /// No description provided for @identityBack.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة التعريف الوطنية (الظهر)'**
  String get identityBack;

  /// No description provided for @drivingLicense.
  ///
  /// In ar, this message translates to:
  /// **'رخصة السياقة'**
  String get drivingLicense;

  /// No description provided for @veterinaryCertificate.
  ///
  /// In ar, this message translates to:
  /// **'شهادة بيطرية'**
  String get veterinaryCertificate;

  /// No description provided for @certificate.
  ///
  /// In ar, this message translates to:
  /// **'شهادة'**
  String get certificate;

  /// No description provided for @commercialRegister.
  ///
  /// In ar, this message translates to:
  /// **'السجل التجاري'**
  String get commercialRegister;

  /// No description provided for @document_not_attached.
  ///
  /// In ar, this message translates to:
  /// **'غير مرفقة'**
  String get document_not_attached;

  /// No description provided for @documents_sent_successfully.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال الوثائق بنجاح '**
  String get documents_sent_successfully;

  /// No description provided for @document_title.
  ///
  /// In ar, this message translates to:
  /// **'توثيق '**
  String get document_title;

  /// No description provided for @submitDocuments.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الوثائق'**
  String get submitDocuments;

  /// No description provided for @aboutUs.
  ///
  /// In ar, this message translates to:
  /// **'من نحن'**
  String get aboutUs;

  /// No description provided for @welcomeMessage.
  ///
  /// In ar, this message translates to:
  /// **'مرحبًا 👋🏼'**
  String get welcomeMessage;

  /// No description provided for @guestSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'استمتع بتصفح التطبيق 🔍'**
  String get guestSubtitle;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'جار التحميل ...⏳'**
  String get loading;

  /// No description provided for @hi.
  ///
  /// In ar, this message translates to:
  /// **'مرحبًا'**
  String get hi;

  /// No description provided for @the.
  ///
  /// In ar, this message translates to:
  /// **'الـ'**
  String get the;

  /// No description provided for @become.
  ///
  /// In ar, this message translates to:
  /// **'أصبح'**
  String get become;

  /// No description provided for @guestAccessLimited.
  ///
  /// In ar, this message translates to:
  /// **'دخول الزائر محدود. يرجى تسجيل الدخول للمتابعة '**
  String get guestAccessLimited;

  /// No description provided for @accessRestricted.
  ///
  /// In ar, this message translates to:
  /// **'الوصول مقيد ⚠️'**
  String get accessRestricted;

  /// No description provided for @cannotAddProducts.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكنه إضافة المنتجات.'**
  String get cannotAddProducts;

  /// No description provided for @ok.
  ///
  /// In ar, this message translates to:
  /// **'حسناً'**
  String get ok;

  /// No description provided for @aiScanner.
  ///
  /// In ar, this message translates to:
  /// **'ماسح الذكاء الاصطناعي'**
  String get aiScanner;

  /// No description provided for @aiDescription.
  ///
  /// In ar, this message translates to:
  /// **'احصل على فحص مجاني من جهاز الكشف عن أمراض النباتات بالذكاء الاصطناعي'**
  String get aiDescription;

  /// No description provided for @checkItOut.
  ///
  /// In ar, this message translates to:
  /// **'جربه الآن'**
  String get checkItOut;

  /// No description provided for @aiScannerSignInMessage.
  ///
  /// In ar, this message translates to:
  /// **'لاستخدام ماسح الذكاء الاصطناعي، يرجى تسجيل الدخول إلى حسابك'**
  String get aiScannerSignInMessage;

  /// No description provided for @featuredProducts.
  ///
  /// In ar, this message translates to:
  /// **'المنتجات المميزة'**
  String get featuredProducts;

  /// No description provided for @seeAll.
  ///
  /// In ar, this message translates to:
  /// **'رؤية الكل'**
  String get seeAll;

  /// No description provided for @noProductWithName.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد منتج بهذا الاسم'**
  String get noProductWithName;

  /// No description provided for @searchHere.
  ///
  /// In ar, this message translates to:
  /// **'ابحث هنا'**
  String get searchHere;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get login;

  /// No description provided for @signIn.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get signIn;

  /// No description provided for @welcomeMessage2.
  ///
  /// In ar, this message translates to:
  /// **'مرحبًا بك في منصتنا'**
  String get welcomeMessage2;

  /// No description provided for @passwordHint.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In ar, this message translates to:
  /// **'هل نسيت كلمة المرور؟'**
  String get forgotPassword;

  /// No description provided for @signup.
  ///
  /// In ar, this message translates to:
  /// **'سجل الآن'**
  String get signup;

  /// No description provided for @noAccount.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب ؟'**
  String get noAccount;

  /// No description provided for @agriculturalProducts.
  ///
  /// In ar, this message translates to:
  /// **'منتوجات فلاحية'**
  String get agriculturalProducts;

  /// No description provided for @fruits.
  ///
  /// In ar, this message translates to:
  /// **'الفواكه'**
  String get fruits;

  /// No description provided for @vegetables.
  ///
  /// In ar, this message translates to:
  /// **'الخضروات'**
  String get vegetables;

  /// No description provided for @grains.
  ///
  /// In ar, this message translates to:
  /// **'الحبوب'**
  String get grains;

  /// No description provided for @oilCrops.
  ///
  /// In ar, this message translates to:
  /// **'المحاصيل الزيتية'**
  String get oilCrops;

  /// No description provided for @legumes.
  ///
  /// In ar, this message translates to:
  /// **'البقوليات'**
  String get legumes;

  /// No description provided for @medicinalPlants.
  ///
  /// In ar, this message translates to:
  /// **'النباتات العطرية و الطبية'**
  String get medicinalPlants;

  /// No description provided for @fodder.
  ///
  /// In ar, this message translates to:
  /// **'الأعلاف'**
  String get fodder;

  /// No description provided for @apple.
  ///
  /// In ar, this message translates to:
  /// **'تفاح'**
  String get apple;

  /// No description provided for @orange.
  ///
  /// In ar, this message translates to:
  /// **'برتقال'**
  String get orange;

  /// No description provided for @banana.
  ///
  /// In ar, this message translates to:
  /// **'موز'**
  String get banana;

  /// No description provided for @grape.
  ///
  /// In ar, this message translates to:
  /// **'عنب'**
  String get grape;

  /// No description provided for @strawberry.
  ///
  /// In ar, this message translates to:
  /// **'فراولة'**
  String get strawberry;

  /// No description provided for @mango.
  ///
  /// In ar, this message translates to:
  /// **'مانجو'**
  String get mango;

  /// No description provided for @pear.
  ///
  /// In ar, this message translates to:
  /// **'كمثرى'**
  String get pear;

  /// No description provided for @cherry.
  ///
  /// In ar, this message translates to:
  /// **'كرز'**
  String get cherry;

  /// No description provided for @watermelon.
  ///
  /// In ar, this message translates to:
  /// **'بطيخ'**
  String get watermelon;

  /// No description provided for @cantaloupe.
  ///
  /// In ar, this message translates to:
  /// **'شمام'**
  String get cantaloupe;

  /// No description provided for @kiwi.
  ///
  /// In ar, this message translates to:
  /// **'كيوي'**
  String get kiwi;

  /// No description provided for @pineapple.
  ///
  /// In ar, this message translates to:
  /// **'أناناس'**
  String get pineapple;

  /// No description provided for @pomegranate.
  ///
  /// In ar, this message translates to:
  /// **'رمان'**
  String get pomegranate;

  /// No description provided for @fig.
  ///
  /// In ar, this message translates to:
  /// **'تين'**
  String get fig;

  /// No description provided for @date.
  ///
  /// In ar, this message translates to:
  /// **'تمر'**
  String get date;

  /// No description provided for @tomato.
  ///
  /// In ar, this message translates to:
  /// **'طماطم'**
  String get tomato;

  /// No description provided for @carrot.
  ///
  /// In ar, this message translates to:
  /// **'جزر'**
  String get carrot;

  /// No description provided for @potato.
  ///
  /// In ar, this message translates to:
  /// **'بطاطا'**
  String get potato;

  /// No description provided for @pepper.
  ///
  /// In ar, this message translates to:
  /// **'فلفل'**
  String get pepper;

  /// No description provided for @onion.
  ///
  /// In ar, this message translates to:
  /// **'بصل'**
  String get onion;

  /// No description provided for @garlic.
  ///
  /// In ar, this message translates to:
  /// **'ثوم'**
  String get garlic;

  /// No description provided for @lettuce.
  ///
  /// In ar, this message translates to:
  /// **'خس'**
  String get lettuce;

  /// No description provided for @cucumber.
  ///
  /// In ar, this message translates to:
  /// **'خيار'**
  String get cucumber;

  /// No description provided for @eggplant.
  ///
  /// In ar, this message translates to:
  /// **'باذنجان'**
  String get eggplant;

  /// No description provided for @spinach.
  ///
  /// In ar, this message translates to:
  /// **'سبانخ'**
  String get spinach;

  /// No description provided for @cabbage.
  ///
  /// In ar, this message translates to:
  /// **'ملفوف'**
  String get cabbage;

  /// No description provided for @radish.
  ///
  /// In ar, this message translates to:
  /// **'فجل'**
  String get radish;

  /// No description provided for @beet.
  ///
  /// In ar, this message translates to:
  /// **'شمندر'**
  String get beet;

  /// No description provided for @greenBeans.
  ///
  /// In ar, this message translates to:
  /// **'فاصوليا خضراء'**
  String get greenBeans;

  /// No description provided for @celery.
  ///
  /// In ar, this message translates to:
  /// **'كرفس'**
  String get celery;

  /// No description provided for @wheat.
  ///
  /// In ar, this message translates to:
  /// **'قمح'**
  String get wheat;

  /// No description provided for @barley.
  ///
  /// In ar, this message translates to:
  /// **'شعير'**
  String get barley;

  /// No description provided for @corn.
  ///
  /// In ar, this message translates to:
  /// **'ذرة'**
  String get corn;

  /// No description provided for @rice.
  ///
  /// In ar, this message translates to:
  /// **'أرز'**
  String get rice;

  /// No description provided for @sorghum.
  ///
  /// In ar, this message translates to:
  /// **'سورغم'**
  String get sorghum;

  /// No description provided for @oats.
  ///
  /// In ar, this message translates to:
  /// **'شوفان'**
  String get oats;

  /// No description provided for @rye.
  ///
  /// In ar, this message translates to:
  /// **'جاودار'**
  String get rye;

  /// No description provided for @millet.
  ///
  /// In ar, this message translates to:
  /// **'دخن'**
  String get millet;

  /// No description provided for @quinoa.
  ///
  /// In ar, this message translates to:
  /// **'كينوا'**
  String get quinoa;

  /// No description provided for @olive.
  ///
  /// In ar, this message translates to:
  /// **'زيتون'**
  String get olive;

  /// No description provided for @almond.
  ///
  /// In ar, this message translates to:
  /// **'لوز'**
  String get almond;

  /// No description provided for @hazelnut.
  ///
  /// In ar, this message translates to:
  /// **'بندق'**
  String get hazelnut;

  /// No description provided for @walnut.
  ///
  /// In ar, this message translates to:
  /// **'جوز'**
  String get walnut;

  /// No description provided for @sunflowerSeeds.
  ///
  /// In ar, this message translates to:
  /// **'بذور عباد الشمس'**
  String get sunflowerSeeds;

  /// No description provided for @sesameSeeds.
  ///
  /// In ar, this message translates to:
  /// **'بذور السمسم'**
  String get sesameSeeds;

  /// No description provided for @flaxSeeds.
  ///
  /// In ar, this message translates to:
  /// **'بذور الكتان'**
  String get flaxSeeds;

  /// No description provided for @rapeseeds.
  ///
  /// In ar, this message translates to:
  /// **'بذور اللفت'**
  String get rapeseeds;

  /// No description provided for @peanut.
  ///
  /// In ar, this message translates to:
  /// **'فول سوداني'**
  String get peanut;

  /// No description provided for @lentil.
  ///
  /// In ar, this message translates to:
  /// **'عدس'**
  String get lentil;

  /// No description provided for @chickpea.
  ///
  /// In ar, this message translates to:
  /// **'حمص'**
  String get chickpea;

  /// No description provided for @whiteBeans.
  ///
  /// In ar, this message translates to:
  /// **'فاصوليا بيضاء'**
  String get whiteBeans;

  /// No description provided for @broadBeans.
  ///
  /// In ar, this message translates to:
  /// **'فول'**
  String get broadBeans;

  /// No description provided for @driedPeas.
  ///
  /// In ar, this message translates to:
  /// **'بازلاء مجففة'**
  String get driedPeas;

  /// No description provided for @redBeans.
  ///
  /// In ar, this message translates to:
  /// **'فاصوليا حمراء'**
  String get redBeans;

  /// No description provided for @soybean.
  ///
  /// In ar, this message translates to:
  /// **'فول الصويا'**
  String get soybean;

  /// No description provided for @mint.
  ///
  /// In ar, this message translates to:
  /// **'نعناع'**
  String get mint;

  /// No description provided for @basil.
  ///
  /// In ar, this message translates to:
  /// **'ريحان'**
  String get basil;

  /// No description provided for @thyme.
  ///
  /// In ar, this message translates to:
  /// **'زعتر'**
  String get thyme;

  /// No description provided for @rosemary.
  ///
  /// In ar, this message translates to:
  /// **'إكليل الجبل'**
  String get rosemary;

  /// No description provided for @chamomile.
  ///
  /// In ar, this message translates to:
  /// **'بابونج'**
  String get chamomile;

  /// No description provided for @lavender.
  ///
  /// In ar, this message translates to:
  /// **'لافندر'**
  String get lavender;

  /// No description provided for @sage.
  ///
  /// In ar, this message translates to:
  /// **'مريمية'**
  String get sage;

  /// No description provided for @parsley.
  ///
  /// In ar, this message translates to:
  /// **'بقدونس'**
  String get parsley;

  /// No description provided for @coriander.
  ///
  /// In ar, this message translates to:
  /// **'كزبرة'**
  String get coriander;

  /// No description provided for @alfalfa.
  ///
  /// In ar, this message translates to:
  /// **'برسيم'**
  String get alfalfa;

  /// No description provided for @straw.
  ///
  /// In ar, this message translates to:
  /// **'تبن'**
  String get straw;

  /// No description provided for @clover.
  ///
  /// In ar, this message translates to:
  /// **'نفل'**
  String get clover;

  /// No description provided for @cornSilage.
  ///
  /// In ar, this message translates to:
  /// **'سيلاج الذرة'**
  String get cornSilage;

  /// No description provided for @fodderSorghum.
  ///
  /// In ar, this message translates to:
  /// **'سورغم العلفي'**
  String get fodderSorghum;

  /// No description provided for @equipment.
  ///
  /// In ar, this message translates to:
  /// **'معدات'**
  String get equipment;

  /// No description provided for @agriculturalEquipment.
  ///
  /// In ar, this message translates to:
  /// **'المعدات الزراعية'**
  String get agriculturalEquipment;

  /// No description provided for @irrigationEquipment.
  ///
  /// In ar, this message translates to:
  /// **'معدات الري'**
  String get irrigationEquipment;

  /// No description provided for @lands.
  ///
  /// In ar, this message translates to:
  /// **'أراضي'**
  String get lands;

  /// No description provided for @tractor.
  ///
  /// In ar, this message translates to:
  /// **'جرار زراعي'**
  String get tractor;

  /// No description provided for @plowMachine.
  ///
  /// In ar, this message translates to:
  /// **'آلة الحرث'**
  String get plowMachine;

  /// No description provided for @harvester.
  ///
  /// In ar, this message translates to:
  /// **'آلة الحصاد'**
  String get harvester;

  /// No description provided for @seeder.
  ///
  /// In ar, this message translates to:
  /// **'آلة البذر'**
  String get seeder;

  /// No description provided for @pesticideSprayer.
  ///
  /// In ar, this message translates to:
  /// **'رشاش مبيدات'**
  String get pesticideSprayer;

  /// No description provided for @plow.
  ///
  /// In ar, this message translates to:
  /// **'محراث'**
  String get plow;

  /// No description provided for @forageHarvester.
  ///
  /// In ar, this message translates to:
  /// **'آلة جمع الأعلاف'**
  String get forageHarvester;

  /// No description provided for @mobileWaterTank.
  ///
  /// In ar, this message translates to:
  /// **'خزان ماء متنقل'**
  String get mobileWaterTank;

  /// No description provided for @waterPump.
  ///
  /// In ar, this message translates to:
  /// **'مضخة مياه'**
  String get waterPump;

  /// No description provided for @fertilizerSpreader.
  ///
  /// In ar, this message translates to:
  /// **'آلة التسميد'**
  String get fertilizerSpreader;

  /// No description provided for @grainSieve.
  ///
  /// In ar, this message translates to:
  /// **'غربال حبوب'**
  String get grainSieve;

  /// No description provided for @agriculturalTrailer.
  ///
  /// In ar, this message translates to:
  /// **'مقطورة زراعية'**
  String get agriculturalTrailer;

  /// No description provided for @irrigationPipes.
  ///
  /// In ar, this message translates to:
  /// **'أنابيب الري'**
  String get irrigationPipes;

  /// No description provided for @waterSprinklers.
  ///
  /// In ar, this message translates to:
  /// **'رشاشات مياه'**
  String get waterSprinklers;

  /// No description provided for @liveAnimals.
  ///
  /// In ar, this message translates to:
  /// **'الحيوانات الحية'**
  String get liveAnimals;

  /// No description provided for @dairyCows.
  ///
  /// In ar, this message translates to:
  /// **'أبقار حلوب'**
  String get dairyCows;

  /// No description provided for @beefCattle.
  ///
  /// In ar, this message translates to:
  /// **'أبقار للتسمين'**
  String get beefCattle;

  /// No description provided for @calves.
  ///
  /// In ar, this message translates to:
  /// **'عجول'**
  String get calves;

  /// No description provided for @sheepGoats.
  ///
  /// In ar, this message translates to:
  /// **'أغنام (خراف، نعاج)'**
  String get sheepGoats;

  /// No description provided for @goats.
  ///
  /// In ar, this message translates to:
  /// **'ماعز (جديان، إناث ماعز)'**
  String get goats;

  /// No description provided for @camels.
  ///
  /// In ar, this message translates to:
  /// **'جمال'**
  String get camels;

  /// No description provided for @horses.
  ///
  /// In ar, this message translates to:
  /// **'خيول'**
  String get horses;

  /// No description provided for @poultry.
  ///
  /// In ar, this message translates to:
  /// **'دواجن (دجاج، بط، ديك رومي)'**
  String get poultry;

  /// No description provided for @rabbits.
  ///
  /// In ar, this message translates to:
  /// **'أرانب'**
  String get rabbits;

  /// No description provided for @dairyProducts.
  ///
  /// In ar, this message translates to:
  /// **'منتجات الألبان ومشتقاتها'**
  String get dairyProducts;

  /// No description provided for @freshMilk.
  ///
  /// In ar, this message translates to:
  /// **'الحليب الطازج (بقري، ماعز، غنم)'**
  String get freshMilk;

  /// No description provided for @cheese.
  ///
  /// In ar, this message translates to:
  /// **'الجبن (بلدي، موزاريلا، شيدر)'**
  String get cheese;

  /// No description provided for @butter.
  ///
  /// In ar, this message translates to:
  /// **'الزبدة الطبيعية'**
  String get butter;

  /// No description provided for @yogurt.
  ///
  /// In ar, this message translates to:
  /// **'الياغورت الطبيعي'**
  String get yogurt;

  /// No description provided for @cream.
  ///
  /// In ar, this message translates to:
  /// **'القشطة'**
  String get cream;

  /// No description provided for @labanRaiib.
  ///
  /// In ar, this message translates to:
  /// **'اللبن الرائب'**
  String get labanRaiib;

  /// No description provided for @animalByproducts.
  ///
  /// In ar, this message translates to:
  /// **'المنتجات المشتقة من الحيوانات'**
  String get animalByproducts;

  /// No description provided for @rawWool.
  ///
  /// In ar, this message translates to:
  /// **'الصوف الخام'**
  String get rawWool;

  /// No description provided for @naturalLeather.
  ///
  /// In ar, this message translates to:
  /// **'الجلود الطبيعية (بقر، غنم، ماعز)'**
  String get naturalLeather;

  /// No description provided for @honey.
  ///
  /// In ar, this message translates to:
  /// **'العسل الطبيعي'**
  String get honey;

  /// No description provided for @beeswax.
  ///
  /// In ar, this message translates to:
  /// **'شمع النحل'**
  String get beeswax;

  /// No description provided for @eggs.
  ///
  /// In ar, this message translates to:
  /// **'البيض (بلدي، مزارع)'**
  String get eggs;

  /// No description provided for @organicFertilizer.
  ///
  /// In ar, this message translates to:
  /// **'السماد الطبيعي العضوي'**
  String get organicFertilizer;

  /// No description provided for @livestockTools.
  ///
  /// In ar, this message translates to:
  /// **'معدات وأدوات تربية المواشي'**
  String get livestockTools;

  /// No description provided for @portableCages.
  ///
  /// In ar, this message translates to:
  /// **'أقفاص وحظائر متنقلة'**
  String get portableCages;

  /// No description provided for @automaticFeeders.
  ///
  /// In ar, this message translates to:
  /// **'معالف ومشارب أوتوماتيكية'**
  String get automaticFeeders;

  /// No description provided for @manualElectricMilking.
  ///
  /// In ar, this message translates to:
  /// **'أجهزة الحلب اليدوية والكهربائية'**
  String get manualElectricMilking;

  /// No description provided for @hoofWoolTools.
  ///
  /// In ar, this message translates to:
  /// **'أدوات القص والتقليم (للحوافر والصوف)'**
  String get hoofWoolTools;

  /// No description provided for @barnHeating.
  ///
  /// In ar, this message translates to:
  /// **'مستلزمات تدفئة الحظائر'**
  String get barnHeating;

  /// No description provided for @ventilationSystems.
  ///
  /// In ar, this message translates to:
  /// **'أنظمة تهوية وتحكم في الحرارة'**
  String get ventilationSystems;

  /// No description provided for @adrar.
  ///
  /// In ar, this message translates to:
  /// **'أدرار'**
  String get adrar;

  /// No description provided for @aoulef.
  ///
  /// In ar, this message translates to:
  /// **'أولف'**
  String get aoulef;

  /// No description provided for @aougrout.
  ///
  /// In ar, this message translates to:
  /// **'أوقروت'**
  String get aougrout;

  /// No description provided for @fenoughil.
  ///
  /// In ar, this message translates to:
  /// **'فنوغيل'**
  String get fenoughil;

  /// No description provided for @reggane.
  ///
  /// In ar, this message translates to:
  /// **'رقان'**
  String get reggane;

  /// No description provided for @timimoun.
  ///
  /// In ar, this message translates to:
  /// **'تيميمون'**
  String get timimoun;

  /// No description provided for @tsabit.
  ///
  /// In ar, this message translates to:
  /// **'تسابيت'**
  String get tsabit;

  /// No description provided for @zaouietKounta.
  ///
  /// In ar, this message translates to:
  /// **'زاوية كنتة'**
  String get zaouietKounta;

  /// No description provided for @chlef.
  ///
  /// In ar, this message translates to:
  /// **'الشلف'**
  String get chlef;

  /// No description provided for @abouElHassan.
  ///
  /// In ar, this message translates to:
  /// **'أبو الحسن'**
  String get abouElHassan;

  /// No description provided for @ainMerane.
  ///
  /// In ar, this message translates to:
  /// **'عين مران'**
  String get ainMerane;

  /// No description provided for @beniHaoua.
  ///
  /// In ar, this message translates to:
  /// **'بني حواء'**
  String get beniHaoua;

  /// No description provided for @boukadir.
  ///
  /// In ar, this message translates to:
  /// **'بوقادير'**
  String get boukadir;

  /// No description provided for @elKarimia.
  ///
  /// In ar, this message translates to:
  /// **'الكريمية'**
  String get elKarimia;

  /// No description provided for @elMarsa.
  ///
  /// In ar, this message translates to:
  /// **'المرسى'**
  String get elMarsa;

  /// No description provided for @ouedFodda.
  ///
  /// In ar, this message translates to:
  /// **'وادي الفضة'**
  String get ouedFodda;

  /// No description provided for @ouledBenAbdelkader.
  ///
  /// In ar, this message translates to:
  /// **'أولاد بن عبد القادر'**
  String get ouledBenAbdelkader;

  /// No description provided for @ouledFares.
  ///
  /// In ar, this message translates to:
  /// **'أولاد فارس'**
  String get ouledFares;

  /// No description provided for @taougrit.
  ///
  /// In ar, this message translates to:
  /// **'تاوقريت'**
  String get taougrit;

  /// No description provided for @tenes.
  ///
  /// In ar, this message translates to:
  /// **'تنس'**
  String get tenes;

  /// No description provided for @zeboudja.
  ///
  /// In ar, this message translates to:
  /// **'زبوجة'**
  String get zeboudja;

  /// No description provided for @laghouat.
  ///
  /// In ar, this message translates to:
  /// **'الأغواط'**
  String get laghouat;

  /// No description provided for @aflou.
  ///
  /// In ar, this message translates to:
  /// **'أفلو'**
  String get aflou;

  /// No description provided for @ainMadhi.
  ///
  /// In ar, this message translates to:
  /// **'عين ماضي'**
  String get ainMadhi;

  /// No description provided for @brida.
  ///
  /// In ar, this message translates to:
  /// **'بريدة'**
  String get brida;

  /// No description provided for @elGhicha.
  ///
  /// In ar, this message translates to:
  /// **'الغيشة'**
  String get elGhicha;

  /// No description provided for @gueltetSidiSaad.
  ///
  /// In ar, this message translates to:
  /// **'قلتة سيدي سعد'**
  String get gueltetSidiSaad;

  /// No description provided for @hassiRMel.
  ///
  /// In ar, this message translates to:
  /// **'حاسي الرمل'**
  String get hassiRMel;

  /// No description provided for @ksarElHirane.
  ///
  /// In ar, this message translates to:
  /// **'قصر الحيران'**
  String get ksarElHirane;

  /// No description provided for @ouedMorra.
  ///
  /// In ar, this message translates to:
  /// **'واد مرة'**
  String get ouedMorra;

  /// No description provided for @sidiMakhlouf.
  ///
  /// In ar, this message translates to:
  /// **'سيدي مخلوف'**
  String get sidiMakhlouf;

  /// No description provided for @oumElBouaghi.
  ///
  /// In ar, this message translates to:
  /// **'أم البواقي'**
  String get oumElBouaghi;

  /// No description provided for @ainBabouche.
  ///
  /// In ar, this message translates to:
  /// **'عين بابوش'**
  String get ainBabouche;

  /// No description provided for @ksarSbahi.
  ///
  /// In ar, this message translates to:
  /// **'قصر الصباحي'**
  String get ksarSbahi;

  /// No description provided for @ainBeida.
  ///
  /// In ar, this message translates to:
  /// **'عين البيضاء'**
  String get ainBeida;

  /// No description provided for @fkirina.
  ///
  /// In ar, this message translates to:
  /// **'فكرينة'**
  String get fkirina;

  /// No description provided for @ainMlila.
  ///
  /// In ar, this message translates to:
  /// **'عين مليلة'**
  String get ainMlila;

  /// No description provided for @soukNaamane.
  ///
  /// In ar, this message translates to:
  /// **'سوق نعمان'**
  String get soukNaamane;

  /// No description provided for @ainFakroun.
  ///
  /// In ar, this message translates to:
  /// **'عين فكرون'**
  String get ainFakroun;

  /// No description provided for @sigus.
  ///
  /// In ar, this message translates to:
  /// **'سيقوس'**
  String get sigus;

  /// No description provided for @ainKercha.
  ///
  /// In ar, this message translates to:
  /// **'عين كرشة'**
  String get ainKercha;

  /// No description provided for @meskiana.
  ///
  /// In ar, this message translates to:
  /// **'مسكيانة'**
  String get meskiana;

  /// No description provided for @dhalaa.
  ///
  /// In ar, this message translates to:
  /// **'الضلعة'**
  String get dhalaa;

  /// No description provided for @batna.
  ///
  /// In ar, this message translates to:
  /// **'باتنة'**
  String get batna;

  /// No description provided for @ainDjasser.
  ///
  /// In ar, this message translates to:
  /// **'عين جاسر'**
  String get ainDjasser;

  /// No description provided for @ainTouta.
  ///
  /// In ar, this message translates to:
  /// **'عين التوتة'**
  String get ainTouta;

  /// No description provided for @arris.
  ///
  /// In ar, this message translates to:
  /// **'أريس'**
  String get arris;

  /// No description provided for @barika.
  ///
  /// In ar, this message translates to:
  /// **'بريكة'**
  String get barika;

  /// No description provided for @bouzina.
  ///
  /// In ar, this message translates to:
  /// **'بوزينة'**
  String get bouzina;

  /// No description provided for @chemora.
  ///
  /// In ar, this message translates to:
  /// **'الشمرة'**
  String get chemora;

  /// No description provided for @djezzar.
  ///
  /// In ar, this message translates to:
  /// **'الجزار'**
  String get djezzar;

  /// No description provided for @elMadher.
  ///
  /// In ar, this message translates to:
  /// **'المعذر'**
  String get elMadher;

  /// No description provided for @ichmoul.
  ///
  /// In ar, this message translates to:
  /// **'إشمول'**
  String get ichmoul;

  /// No description provided for @menaa.
  ///
  /// In ar, this message translates to:
  /// **'منعة'**
  String get menaa;

  /// No description provided for @merouana.
  ///
  /// In ar, this message translates to:
  /// **'مروانة'**
  String get merouana;

  /// No description provided for @ngaous.
  ///
  /// In ar, this message translates to:
  /// **'نقاوس'**
  String get ngaous;

  /// No description provided for @ouledSiSlimane.
  ///
  /// In ar, this message translates to:
  /// **'أولاد سي سليمان'**
  String get ouledSiSlimane;

  /// No description provided for @rasElAioun.
  ///
  /// In ar, this message translates to:
  /// **'رأس العيون'**
  String get rasElAioun;

  /// No description provided for @seggana.
  ///
  /// In ar, this message translates to:
  /// **'سقانة'**
  String get seggana;

  /// No description provided for @seriana.
  ///
  /// In ar, this message translates to:
  /// **'سريانة'**
  String get seriana;

  /// No description provided for @tazoult.
  ///
  /// In ar, this message translates to:
  /// **'تازولت'**
  String get tazoult;

  /// No description provided for @tenietElAbed.
  ///
  /// In ar, this message translates to:
  /// **'ثنية العابد'**
  String get tenietElAbed;

  /// No description provided for @timgad.
  ///
  /// In ar, this message translates to:
  /// **'تيمقاد'**
  String get timgad;

  /// No description provided for @tkout.
  ///
  /// In ar, this message translates to:
  /// **'تكوت'**
  String get tkout;

  /// No description provided for @bejaia.
  ///
  /// In ar, this message translates to:
  /// **'بجاية'**
  String get bejaia;

  /// No description provided for @adekar.
  ///
  /// In ar, this message translates to:
  /// **'أدكار'**
  String get adekar;

  /// No description provided for @akbou.
  ///
  /// In ar, this message translates to:
  /// **'أقبو'**
  String get akbou;

  /// No description provided for @amizour.
  ///
  /// In ar, this message translates to:
  /// **'أميزور'**
  String get amizour;

  /// No description provided for @aokas.
  ///
  /// In ar, this message translates to:
  /// **'أوقاس'**
  String get aokas;

  /// No description provided for @barbacha.
  ///
  /// In ar, this message translates to:
  /// **'برباشة'**
  String get barbacha;

  /// No description provided for @beniMaouche.
  ///
  /// In ar, this message translates to:
  /// **'بني معوش'**
  String get beniMaouche;

  /// No description provided for @chemini.
  ///
  /// In ar, this message translates to:
  /// **'شميني'**
  String get chemini;

  /// No description provided for @darguina.
  ///
  /// In ar, this message translates to:
  /// **'درقينة'**
  String get darguina;

  /// No description provided for @elKseur.
  ///
  /// In ar, this message translates to:
  /// **'القصر'**
  String get elKseur;

  /// No description provided for @ighilAli.
  ///
  /// In ar, this message translates to:
  /// **'إغيل علي'**
  String get ighilAli;

  /// No description provided for @kherrata.
  ///
  /// In ar, this message translates to:
  /// **'خراطة'**
  String get kherrata;

  /// No description provided for @ouzellaguen.
  ///
  /// In ar, this message translates to:
  /// **'أوزلاقن'**
  String get ouzellaguen;

  /// No description provided for @seddouk.
  ///
  /// In ar, this message translates to:
  /// **'صدوق'**
  String get seddouk;

  /// No description provided for @sidiAich.
  ///
  /// In ar, this message translates to:
  /// **'سيدي عيش'**
  String get sidiAich;

  /// No description provided for @soukElTenine.
  ///
  /// In ar, this message translates to:
  /// **'سوق الإثنين'**
  String get soukElTenine;

  /// No description provided for @tazmalt.
  ///
  /// In ar, this message translates to:
  /// **'تازمالت'**
  String get tazmalt;

  /// No description provided for @tichy.
  ///
  /// In ar, this message translates to:
  /// **'تيشي'**
  String get tichy;

  /// No description provided for @timezrit.
  ///
  /// In ar, this message translates to:
  /// **'تيمزريت'**
  String get timezrit;

  /// No description provided for @biskra.
  ///
  /// In ar, this message translates to:
  /// **'بسكرة'**
  String get biskra;

  /// No description provided for @djemorah.
  ///
  /// In ar, this message translates to:
  /// **'جمورة'**
  String get djemorah;

  /// No description provided for @elKantara.
  ///
  /// In ar, this message translates to:
  /// **'القنطرة'**
  String get elKantara;

  /// No description provided for @mChouneche.
  ///
  /// In ar, this message translates to:
  /// **'مشونش'**
  String get mChouneche;

  /// No description provided for @sidiOkba.
  ///
  /// In ar, this message translates to:
  /// **'سيدي عقبة'**
  String get sidiOkba;

  /// No description provided for @zeribetElOued.
  ///
  /// In ar, this message translates to:
  /// **'زريبة الوادي'**
  String get zeribetElOued;

  /// No description provided for @ourlal.
  ///
  /// In ar, this message translates to:
  /// **'أورلال'**
  String get ourlal;

  /// No description provided for @tolga.
  ///
  /// In ar, this message translates to:
  /// **'طولقة'**
  String get tolga;

  /// No description provided for @sidiKhaled.
  ///
  /// In ar, this message translates to:
  /// **'سيدي خالد'**
  String get sidiKhaled;

  /// No description provided for @foughala.
  ///
  /// In ar, this message translates to:
  /// **'فوغالة'**
  String get foughala;

  /// No description provided for @elOutaya.
  ///
  /// In ar, this message translates to:
  /// **'الوطاية'**
  String get elOutaya;

  /// No description provided for @bechar.
  ///
  /// In ar, this message translates to:
  /// **'بشار'**
  String get bechar;

  /// No description provided for @beniOunif.
  ///
  /// In ar, this message translates to:
  /// **'بني ونيف'**
  String get beniOunif;

  /// No description provided for @lahmar.
  ///
  /// In ar, this message translates to:
  /// **'لحمر'**
  String get lahmar;

  /// No description provided for @kenadsa.
  ///
  /// In ar, this message translates to:
  /// **'القنادسة'**
  String get kenadsa;

  /// No description provided for @taghit.
  ///
  /// In ar, this message translates to:
  /// **'تاغيت'**
  String get taghit;

  /// No description provided for @abadla.
  ///
  /// In ar, this message translates to:
  /// **'العبادلة'**
  String get abadla;

  /// No description provided for @tabelbala.
  ///
  /// In ar, this message translates to:
  /// **'تبلبالة'**
  String get tabelbala;

  /// No description provided for @igli.
  ///
  /// In ar, this message translates to:
  /// **'إقلي'**
  String get igli;

  /// No description provided for @beniAbbes.
  ///
  /// In ar, this message translates to:
  /// **'بني عباس'**
  String get beniAbbes;

  /// No description provided for @elOuata.
  ///
  /// In ar, this message translates to:
  /// **'الواتة'**
  String get elOuata;

  /// No description provided for @ouledKhoudir.
  ///
  /// In ar, this message translates to:
  /// **'أولاد خضير'**
  String get ouledKhoudir;

  /// No description provided for @blida.
  ///
  /// In ar, this message translates to:
  /// **'البليدة'**
  String get blida;

  /// No description provided for @boufarik.
  ///
  /// In ar, this message translates to:
  /// **'بوفاريك'**
  String get boufarik;

  /// No description provided for @bougara.
  ///
  /// In ar, this message translates to:
  /// **'بوقرة'**
  String get bougara;

  /// No description provided for @bouinan.
  ///
  /// In ar, this message translates to:
  /// **'بوعينان'**
  String get bouinan;

  /// No description provided for @elAffroun.
  ///
  /// In ar, this message translates to:
  /// **'العفرون'**
  String get elAffroun;

  /// No description provided for @larbaa.
  ///
  /// In ar, this message translates to:
  /// **'الأربعاء'**
  String get larbaa;

  /// No description provided for @meftah.
  ///
  /// In ar, this message translates to:
  /// **'مفتاح'**
  String get meftah;

  /// No description provided for @mouzaia.
  ///
  /// In ar, this message translates to:
  /// **'موزاية'**
  String get mouzaia;

  /// No description provided for @ouedAlleug.
  ///
  /// In ar, this message translates to:
  /// **'وادي العلايق'**
  String get ouedAlleug;

  /// No description provided for @ouledYaich.
  ///
  /// In ar, this message translates to:
  /// **'أولاد يعيش'**
  String get ouledYaich;

  /// No description provided for @bouira.
  ///
  /// In ar, this message translates to:
  /// **'البويرة'**
  String get bouira;

  /// No description provided for @haizer.
  ///
  /// In ar, this message translates to:
  /// **'الحيزر'**
  String get haizer;

  /// No description provided for @bechloul.
  ///
  /// In ar, this message translates to:
  /// **'بشلول'**
  String get bechloul;

  /// No description provided for @mChedallah.
  ///
  /// In ar, this message translates to:
  /// **'مشدالله'**
  String get mChedallah;

  /// No description provided for @kadiria.
  ///
  /// In ar, this message translates to:
  /// **'القادرية'**
  String get kadiria;

  /// No description provided for @lakhdaria.
  ///
  /// In ar, this message translates to:
  /// **'الأخضرية'**
  String get lakhdaria;

  /// No description provided for @birGhbalou.
  ///
  /// In ar, this message translates to:
  /// **'بئر غبالو'**
  String get birGhbalou;

  /// No description provided for @ainBessam.
  ///
  /// In ar, this message translates to:
  /// **'عين بسام'**
  String get ainBessam;

  /// No description provided for @soukElKhemis.
  ///
  /// In ar, this message translates to:
  /// **'سوق الخميس'**
  String get soukElKhemis;

  /// No description provided for @elHachimia.
  ///
  /// In ar, this message translates to:
  /// **'الهاشمية'**
  String get elHachimia;

  /// No description provided for @sourElGhozlane.
  ///
  /// In ar, this message translates to:
  /// **'سور الغزلان'**
  String get sourElGhozlane;

  /// No description provided for @bordjOkhriss.
  ///
  /// In ar, this message translates to:
  /// **'برج أوخريص'**
  String get bordjOkhriss;

  /// No description provided for @tamanrasset.
  ///
  /// In ar, this message translates to:
  /// **'تمنراست'**
  String get tamanrasset;

  /// No description provided for @abalessa.
  ///
  /// In ar, this message translates to:
  /// **'أبلسة'**
  String get abalessa;

  /// No description provided for @inGhar.
  ///
  /// In ar, this message translates to:
  /// **'عين غار'**
  String get inGhar;

  /// No description provided for @tazrouk.
  ///
  /// In ar, this message translates to:
  /// **'تازروك'**
  String get tazrouk;

  /// No description provided for @tinzaouten.
  ///
  /// In ar, this message translates to:
  /// **'تين زواتين'**
  String get tinzaouten;

  /// No description provided for @tebessa.
  ///
  /// In ar, this message translates to:
  /// **'تبسة'**
  String get tebessa;

  /// No description provided for @elKouif.
  ///
  /// In ar, this message translates to:
  /// **'الكويف'**
  String get elKouif;

  /// No description provided for @morsott.
  ///
  /// In ar, this message translates to:
  /// **'مرسط'**
  String get morsott;

  /// No description provided for @elMaLabiodh.
  ///
  /// In ar, this message translates to:
  /// **'الماء الأبيض'**
  String get elMaLabiodh;

  /// No description provided for @elAouinet.
  ///
  /// In ar, this message translates to:
  /// **'العوينات'**
  String get elAouinet;

  /// No description provided for @ouenza.
  ///
  /// In ar, this message translates to:
  /// **'الونزة'**
  String get ouenza;

  /// No description provided for @birMokkadem.
  ///
  /// In ar, this message translates to:
  /// **'بئر مقدم'**
  String get birMokkadem;

  /// No description provided for @birElAter.
  ///
  /// In ar, this message translates to:
  /// **'بئر العاتر'**
  String get birElAter;

  /// No description provided for @elOgla.
  ///
  /// In ar, this message translates to:
  /// **'العقلة'**
  String get elOgla;

  /// No description provided for @oumAli.
  ///
  /// In ar, this message translates to:
  /// **'أم علي'**
  String get oumAli;

  /// No description provided for @negrine.
  ///
  /// In ar, this message translates to:
  /// **'نقرين'**
  String get negrine;

  /// No description provided for @cheria.
  ///
  /// In ar, this message translates to:
  /// **'الشريعة'**
  String get cheria;

  /// No description provided for @tlemcen.
  ///
  /// In ar, this message translates to:
  /// **'تلمسان'**
  String get tlemcen;

  /// No description provided for @ainTallout.
  ///
  /// In ar, this message translates to:
  /// **'عين تالوت'**
  String get ainTallout;

  /// No description provided for @babElAssa.
  ///
  /// In ar, this message translates to:
  /// **'باب العسة'**
  String get babElAssa;

  /// No description provided for @beniBoussaid.
  ///
  /// In ar, this message translates to:
  /// **'بني بوسعيد'**
  String get beniBoussaid;

  /// No description provided for @beniSnous.
  ///
  /// In ar, this message translates to:
  /// **'بني سنوس'**
  String get beniSnous;

  /// No description provided for @bensekrane.
  ///
  /// In ar, this message translates to:
  /// **'بن سكران'**
  String get bensekrane;

  /// No description provided for @chetouane.
  ///
  /// In ar, this message translates to:
  /// **'شتوان'**
  String get chetouane;

  /// No description provided for @elAricha.
  ///
  /// In ar, this message translates to:
  /// **'العريشة'**
  String get elAricha;

  /// No description provided for @fellaoucene.
  ///
  /// In ar, this message translates to:
  /// **'فلاوسن'**
  String get fellaoucene;

  /// No description provided for @ghazaouet.
  ///
  /// In ar, this message translates to:
  /// **'الغزوات'**
  String get ghazaouet;

  /// No description provided for @hennaya.
  ///
  /// In ar, this message translates to:
  /// **'الحناية'**
  String get hennaya;

  /// No description provided for @honaine.
  ///
  /// In ar, this message translates to:
  /// **'هنين'**
  String get honaine;

  /// No description provided for @maghnia.
  ///
  /// In ar, this message translates to:
  /// **'مغنية'**
  String get maghnia;

  /// No description provided for @mansourah.
  ///
  /// In ar, this message translates to:
  /// **'منصورة'**
  String get mansourah;

  /// No description provided for @marsaBenMHidi.
  ///
  /// In ar, this message translates to:
  /// **'مرسى بن مهيدي'**
  String get marsaBenMHidi;

  /// No description provided for @nedroma.
  ///
  /// In ar, this message translates to:
  /// **'ندرومة'**
  String get nedroma;

  /// No description provided for @ouledMimoun.
  ///
  /// In ar, this message translates to:
  /// **'أولاد ميمون'**
  String get ouledMimoun;

  /// No description provided for @remchi.
  ///
  /// In ar, this message translates to:
  /// **'الرمشي'**
  String get remchi;

  /// No description provided for @sabra.
  ///
  /// In ar, this message translates to:
  /// **'صبرة'**
  String get sabra;

  /// No description provided for @sebdou.
  ///
  /// In ar, this message translates to:
  /// **'سبدو'**
  String get sebdou;

  /// No description provided for @sidiDjillali.
  ///
  /// In ar, this message translates to:
  /// **'سيدي الجيلالي'**
  String get sidiDjillali;

  /// No description provided for @tiaret.
  ///
  /// In ar, this message translates to:
  /// **'تيارت'**
  String get tiaret;

  /// No description provided for @sougueur.
  ///
  /// In ar, this message translates to:
  /// **'السوقر'**
  String get sougueur;

  /// No description provided for @ainDeheb.
  ///
  /// In ar, this message translates to:
  /// **'عين الذهب'**
  String get ainDeheb;

  /// No description provided for @ainKermes.
  ///
  /// In ar, this message translates to:
  /// **'عين كرمس'**
  String get ainKermes;

  /// No description provided for @frenda.
  ///
  /// In ar, this message translates to:
  /// **'فرندة'**
  String get frenda;

  /// No description provided for @dahmouni.
  ///
  /// In ar, this message translates to:
  /// **'دحموني'**
  String get dahmouni;

  /// No description provided for @mahdia.
  ///
  /// In ar, this message translates to:
  /// **'مهدية'**
  String get mahdia;

  /// No description provided for @hamadia.
  ///
  /// In ar, this message translates to:
  /// **'حمادية'**
  String get hamadia;

  /// No description provided for @ksarChellala.
  ///
  /// In ar, this message translates to:
  /// **'قصر الشلالة'**
  String get ksarChellala;

  /// No description provided for @medroussa.
  ///
  /// In ar, this message translates to:
  /// **'مدروسة'**
  String get medroussa;

  /// No description provided for @mechraSafa.
  ///
  /// In ar, this message translates to:
  /// **'مشرع الصفا'**
  String get mechraSafa;

  /// No description provided for @rahouia.
  ///
  /// In ar, this message translates to:
  /// **'الرحوية'**
  String get rahouia;

  /// No description provided for @ouedLilli.
  ///
  /// In ar, this message translates to:
  /// **'وادي ليلي'**
  String get ouedLilli;

  /// No description provided for @meghila.
  ///
  /// In ar, this message translates to:
  /// **'مغيلة'**
  String get meghila;

  /// No description provided for @tiziOuzou.
  ///
  /// In ar, this message translates to:
  /// **'تيزي وزو'**
  String get tiziOuzou;

  /// No description provided for @ainElHammam.
  ///
  /// In ar, this message translates to:
  /// **'عين الحمام'**
  String get ainElHammam;

  /// No description provided for @azazga.
  ///
  /// In ar, this message translates to:
  /// **'عزازقة'**
  String get azazga;

  /// No description provided for @azeffoun.
  ///
  /// In ar, this message translates to:
  /// **'أزفون'**
  String get azeffoun;

  /// No description provided for @beniDouala.
  ///
  /// In ar, this message translates to:
  /// **'بني دوالة'**
  String get beniDouala;

  /// No description provided for @beniYenni.
  ///
  /// In ar, this message translates to:
  /// **'بني يني'**
  String get beniYenni;

  /// No description provided for @boghni.
  ///
  /// In ar, this message translates to:
  /// **'بوغني'**
  String get boghni;

  /// No description provided for @bouzguen.
  ///
  /// In ar, this message translates to:
  /// **'بوزقن'**
  String get bouzguen;

  /// No description provided for @draaBenKhedda.
  ///
  /// In ar, this message translates to:
  /// **'ذراع بن خدة'**
  String get draaBenKhedda;

  /// No description provided for @draaElMizan.
  ///
  /// In ar, this message translates to:
  /// **'ذراع الميزان'**
  String get draaElMizan;

  /// No description provided for @iferhounen.
  ///
  /// In ar, this message translates to:
  /// **'إفرحونن'**
  String get iferhounen;

  /// No description provided for @larbaaNathIrathen.
  ///
  /// In ar, this message translates to:
  /// **'الأربعاء ناث إيراثن'**
  String get larbaaNathIrathen;

  /// No description provided for @maatkas.
  ///
  /// In ar, this message translates to:
  /// **'معاتقة'**
  String get maatkas;

  /// No description provided for @makouda.
  ///
  /// In ar, this message translates to:
  /// **'ماكودة'**
  String get makouda;

  /// No description provided for @mekla.
  ///
  /// In ar, this message translates to:
  /// **'مقلع'**
  String get mekla;

  /// No description provided for @ouacif.
  ///
  /// In ar, this message translates to:
  /// **'واسيف'**
  String get ouacif;

  /// No description provided for @ouadhia.
  ///
  /// In ar, this message translates to:
  /// **'واضية'**
  String get ouadhia;

  /// No description provided for @ouaguenoun.
  ///
  /// In ar, this message translates to:
  /// **'واقنون'**
  String get ouaguenoun;

  /// No description provided for @tigzirt.
  ///
  /// In ar, this message translates to:
  /// **'تيقزيرت'**
  String get tigzirt;

  /// No description provided for @tiziGheniff.
  ///
  /// In ar, this message translates to:
  /// **'تيزي غنيف'**
  String get tiziGheniff;

  /// No description provided for @tiziRached.
  ///
  /// In ar, this message translates to:
  /// **'تيزي راشد'**
  String get tiziRached;

  /// No description provided for @alger.
  ///
  /// In ar, this message translates to:
  /// **'الجزائر'**
  String get alger;

  /// No description provided for @zeralda.
  ///
  /// In ar, this message translates to:
  /// **'زرالدة'**
  String get zeralda;

  /// No description provided for @cheraga.
  ///
  /// In ar, this message translates to:
  /// **'الشراقة'**
  String get cheraga;

  /// No description provided for @draria.
  ///
  /// In ar, this message translates to:
  /// **'الدرارية'**
  String get draria;

  /// No description provided for @birMouradRais.
  ///
  /// In ar, this message translates to:
  /// **'بئر مراد رايس'**
  String get birMouradRais;

  /// No description provided for @birtouta.
  ///
  /// In ar, this message translates to:
  /// **'بئر توتة'**
  String get birtouta;

  /// No description provided for @bouzareah.
  ///
  /// In ar, this message translates to:
  /// **'بوزريعة'**
  String get bouzareah;

  /// No description provided for @babElOued.
  ///
  /// In ar, this message translates to:
  /// **'باب الوادي'**
  String get babElOued;

  /// No description provided for @sidiMHamed.
  ///
  /// In ar, this message translates to:
  /// **'سيدي امحمد'**
  String get sidiMHamed;

  /// No description provided for @husseinDey.
  ///
  /// In ar, this message translates to:
  /// **'حسين داي'**
  String get husseinDey;

  /// No description provided for @elHarrach.
  ///
  /// In ar, this message translates to:
  /// **'الحراش'**
  String get elHarrach;

  /// No description provided for @baraki.
  ///
  /// In ar, this message translates to:
  /// **'براقي'**
  String get baraki;

  /// No description provided for @darElBeida.
  ///
  /// In ar, this message translates to:
  /// **'الدار البيضاء'**
  String get darElBeida;

  /// No description provided for @rouiba.
  ///
  /// In ar, this message translates to:
  /// **'الرويبة'**
  String get rouiba;

  /// No description provided for @djelfa.
  ///
  /// In ar, this message translates to:
  /// **'الجلفة'**
  String get djelfa;

  /// No description provided for @ainElIbel.
  ///
  /// In ar, this message translates to:
  /// **'عين الإبل'**
  String get ainElIbel;

  /// No description provided for @ainOussara.
  ///
  /// In ar, this message translates to:
  /// **'عين وسارة'**
  String get ainOussara;

  /// No description provided for @birine.
  ///
  /// In ar, this message translates to:
  /// **'بيرين'**
  String get birine;

  /// No description provided for @charef.
  ///
  /// In ar, this message translates to:
  /// **'الشارف'**
  String get charef;

  /// No description provided for @darChioukh.
  ///
  /// In ar, this message translates to:
  /// **'دار الشيوخ'**
  String get darChioukh;

  /// No description provided for @elIdrissia.
  ///
  /// In ar, this message translates to:
  /// **'الإدريسية'**
  String get elIdrissia;

  /// No description provided for @faidhElBotma.
  ///
  /// In ar, this message translates to:
  /// **'فيض البطمة'**
  String get faidhElBotma;

  /// No description provided for @hadSahary.
  ///
  /// In ar, this message translates to:
  /// **'حد الصحاري'**
  String get hadSahary;

  /// No description provided for @hassiBahbah.
  ///
  /// In ar, this message translates to:
  /// **'حاسي بحبح'**
  String get hassiBahbah;

  /// No description provided for @sidiLadjel.
  ///
  /// In ar, this message translates to:
  /// **'سيدي لعجال'**
  String get sidiLadjel;

  /// No description provided for @messaad.
  ///
  /// In ar, this message translates to:
  /// **'مسعد'**
  String get messaad;

  /// No description provided for @jijel.
  ///
  /// In ar, this message translates to:
  /// **'جيجل'**
  String get jijel;

  /// No description provided for @chekfa.
  ///
  /// In ar, this message translates to:
  /// **'الشقفة'**
  String get chekfa;

  /// No description provided for @djimla.
  ///
  /// In ar, this message translates to:
  /// **'جيملة'**
  String get djimla;

  /// No description provided for @elAncer.
  ///
  /// In ar, this message translates to:
  /// **'العنصر'**
  String get elAncer;

  /// No description provided for @elAouana.
  ///
  /// In ar, this message translates to:
  /// **'العوانة'**
  String get elAouana;

  /// No description provided for @elMilia.
  ///
  /// In ar, this message translates to:
  /// **'الميلية'**
  String get elMilia;

  /// No description provided for @settara.
  ///
  /// In ar, this message translates to:
  /// **'السطارة'**
  String get settara;

  /// No description provided for @sidiMaarouf.
  ///
  /// In ar, this message translates to:
  /// **'سيدي معروف'**
  String get sidiMaarouf;

  /// No description provided for @taher.
  ///
  /// In ar, this message translates to:
  /// **'الطاهير'**
  String get taher;

  /// No description provided for @texenna.
  ///
  /// In ar, this message translates to:
  /// **'تاكسنة'**
  String get texenna;

  /// No description provided for @ziamaMansouriah.
  ///
  /// In ar, this message translates to:
  /// **'زيامة منصورية'**
  String get ziamaMansouriah;

  /// No description provided for @setif.
  ///
  /// In ar, this message translates to:
  /// **'سطيف'**
  String get setif;

  /// No description provided for @ainArnat.
  ///
  /// In ar, this message translates to:
  /// **'عين أرنات'**
  String get ainArnat;

  /// No description provided for @ainAzel.
  ///
  /// In ar, this message translates to:
  /// **'عين آزال'**
  String get ainAzel;

  /// No description provided for @ainElKebira.
  ///
  /// In ar, this message translates to:
  /// **'عين الكبيرة'**
  String get ainElKebira;

  /// No description provided for @ainOulmene.
  ///
  /// In ar, this message translates to:
  /// **'عين ولمان'**
  String get ainOulmene;

  /// No description provided for @amoucha.
  ///
  /// In ar, this message translates to:
  /// **'عموشة'**
  String get amoucha;

  /// No description provided for @babor.
  ///
  /// In ar, this message translates to:
  /// **'بابور'**
  String get babor;

  /// No description provided for @beniAziz.
  ///
  /// In ar, this message translates to:
  /// **'بني عزيز'**
  String get beniAziz;

  /// No description provided for @beniOurtilane.
  ///
  /// In ar, this message translates to:
  /// **'بني ورتيلان'**
  String get beniOurtilane;

  /// No description provided for @birElArch.
  ///
  /// In ar, this message translates to:
  /// **'بئر العرش'**
  String get birElArch;

  /// No description provided for @bouandas.
  ///
  /// In ar, this message translates to:
  /// **'بوعنداس'**
  String get bouandas;

  /// No description provided for @bougaa.
  ///
  /// In ar, this message translates to:
  /// **'بوقاعة'**
  String get bougaa;

  /// No description provided for @djemila.
  ///
  /// In ar, this message translates to:
  /// **'جميلة'**
  String get djemila;

  /// No description provided for @elEulma.
  ///
  /// In ar, this message translates to:
  /// **'العلمة'**
  String get elEulma;

  /// No description provided for @guidjel.
  ///
  /// In ar, this message translates to:
  /// **'قيجل'**
  String get guidjel;

  /// No description provided for @guenzet.
  ///
  /// In ar, this message translates to:
  /// **'قنزات'**
  String get guenzet;

  /// No description provided for @hammamGuergour.
  ///
  /// In ar, this message translates to:
  /// **'حمام قرقور'**
  String get hammamGuergour;

  /// No description provided for @hammamSoukhna.
  ///
  /// In ar, this message translates to:
  /// **'حمام السخنة'**
  String get hammamSoukhna;

  /// No description provided for @maoklane.
  ///
  /// In ar, this message translates to:
  /// **'ماوكلان'**
  String get maoklane;

  /// No description provided for @salahBey.
  ///
  /// In ar, this message translates to:
  /// **'صالح باي'**
  String get salahBey;

  /// No description provided for @saida.
  ///
  /// In ar, this message translates to:
  /// **'سعيدة'**
  String get saida;

  /// No description provided for @ainElHadjar.
  ///
  /// In ar, this message translates to:
  /// **'عين الحجر'**
  String get ainElHadjar;

  /// No description provided for @sidiBoubekeur.
  ///
  /// In ar, this message translates to:
  /// **'سيدي بوبكر'**
  String get sidiBoubekeur;

  /// No description provided for @elHassasna.
  ///
  /// In ar, this message translates to:
  /// **'الحساسنة'**
  String get elHassasna;

  /// No description provided for @ouledBrahim.
  ///
  /// In ar, this message translates to:
  /// **'أولاد إبراهيم'**
  String get ouledBrahim;

  /// No description provided for @youb.
  ///
  /// In ar, this message translates to:
  /// **'يوب'**
  String get youb;

  /// No description provided for @skikda.
  ///
  /// In ar, this message translates to:
  /// **'سكيكدة'**
  String get skikda;

  /// No description provided for @azzaba.
  ///
  /// In ar, this message translates to:
  /// **'عزابة'**
  String get azzaba;

  /// No description provided for @ainKechra.
  ///
  /// In ar, this message translates to:
  /// **'عين قشرة'**
  String get ainKechra;

  /// No description provided for @benAzzouz.
  ///
  /// In ar, this message translates to:
  /// **'بن عزوز'**
  String get benAzzouz;

  /// No description provided for @collo.
  ///
  /// In ar, this message translates to:
  /// **'القل'**
  String get collo;

  /// No description provided for @elHadaiek.
  ///
  /// In ar, this message translates to:
  /// **'الحدائق'**
  String get elHadaiek;

  /// No description provided for @elHarrouch.
  ///
  /// In ar, this message translates to:
  /// **'الحروش'**
  String get elHarrouch;

  /// No description provided for @ouledAttia.
  ///
  /// In ar, this message translates to:
  /// **'أولاد عطية'**
  String get ouledAttia;

  /// No description provided for @oumToub.
  ///
  /// In ar, this message translates to:
  /// **'أم الطوب'**
  String get oumToub;

  /// No description provided for @ramdaneDjamel.
  ///
  /// In ar, this message translates to:
  /// **'رمضان جمال'**
  String get ramdaneDjamel;

  /// No description provided for @sidiMezghiche.
  ///
  /// In ar, this message translates to:
  /// **'سيدي مزغيش'**
  String get sidiMezghiche;

  /// No description provided for @tamalous.
  ///
  /// In ar, this message translates to:
  /// **'تمالوس'**
  String get tamalous;

  /// No description provided for @zitouna.
  ///
  /// In ar, this message translates to:
  /// **'الزيتونة'**
  String get zitouna;

  /// No description provided for @sidiBelAbbes.
  ///
  /// In ar, this message translates to:
  /// **'سيدي بلعباس'**
  String get sidiBelAbbes;

  /// No description provided for @ainElBerd.
  ///
  /// In ar, this message translates to:
  /// **'عين البرد'**
  String get ainElBerd;

  /// No description provided for @benBadis.
  ///
  /// In ar, this message translates to:
  /// **'بن باديس'**
  String get benBadis;

  /// No description provided for @marhoum.
  ///
  /// In ar, this message translates to:
  /// **'مرحوم'**
  String get marhoum;

  /// No description provided for @merine.
  ///
  /// In ar, this message translates to:
  /// **'مرين'**
  String get merine;

  /// No description provided for @mostefaBenBrahim.
  ///
  /// In ar, this message translates to:
  /// **'مصطفى بن إبراهيم'**
  String get mostefaBenBrahim;

  /// No description provided for @moulaySlissen.
  ///
  /// In ar, this message translates to:
  /// **'مولاي سليسن'**
  String get moulaySlissen;

  /// No description provided for @rasElMa.
  ///
  /// In ar, this message translates to:
  /// **'رأس الماء'**
  String get rasElMa;

  /// No description provided for @sfisef.
  ///
  /// In ar, this message translates to:
  /// **'سفيزف'**
  String get sfisef;

  /// No description provided for @sidiAliBenyoub.
  ///
  /// In ar, this message translates to:
  /// **'سيدي علي بن يوب'**
  String get sidiAliBenyoub;

  /// No description provided for @sidiAliBoussidi.
  ///
  /// In ar, this message translates to:
  /// **'سيدي علي بوسيدي'**
  String get sidiAliBoussidi;

  /// No description provided for @sidiLahcene.
  ///
  /// In ar, this message translates to:
  /// **'سيدي لحسن'**
  String get sidiLahcene;

  /// No description provided for @telagh.
  ///
  /// In ar, this message translates to:
  /// **'تلاغ'**
  String get telagh;

  /// No description provided for @tenira.
  ///
  /// In ar, this message translates to:
  /// **'تنيرة'**
  String get tenira;

  /// No description provided for @tessala.
  ///
  /// In ar, this message translates to:
  /// **'تسالة'**
  String get tessala;

  /// No description provided for @annaba.
  ///
  /// In ar, this message translates to:
  /// **'عنابة'**
  String get annaba;

  /// No description provided for @ainBerda.
  ///
  /// In ar, this message translates to:
  /// **'عين الباردة'**
  String get ainBerda;

  /// No description provided for @elHadjar.
  ///
  /// In ar, this message translates to:
  /// **'الحجار'**
  String get elHadjar;

  /// No description provided for @berrahal.
  ///
  /// In ar, this message translates to:
  /// **'برحال'**
  String get berrahal;

  /// No description provided for @chetaibi.
  ///
  /// In ar, this message translates to:
  /// **'شطايبي'**
  String get chetaibi;

  /// No description provided for @elBouni.
  ///
  /// In ar, this message translates to:
  /// **'البوني'**
  String get elBouni;

  /// No description provided for @guelma.
  ///
  /// In ar, this message translates to:
  /// **'قالمة'**
  String get guelma;

  /// No description provided for @ainMakhlouf.
  ///
  /// In ar, this message translates to:
  /// **'عين مخلوف'**
  String get ainMakhlouf;

  /// No description provided for @bouchegouf.
  ///
  /// In ar, this message translates to:
  /// **'بوشقوف'**
  String get bouchegouf;

  /// No description provided for @guelaatBouSbaa.
  ///
  /// In ar, this message translates to:
  /// **'قلعة بوصبع'**
  String get guelaatBouSbaa;

  /// No description provided for @hammamDebagh.
  ///
  /// In ar, this message translates to:
  /// **'حمام دباغ'**
  String get hammamDebagh;

  /// No description provided for @hammamNBails.
  ///
  /// In ar, this message translates to:
  /// **'حمام النبايل'**
  String get hammamNBails;

  /// No description provided for @heliopolis.
  ///
  /// In ar, this message translates to:
  /// **'هيليوبوليس'**
  String get heliopolis;

  /// No description provided for @houariBoumediene.
  ///
  /// In ar, this message translates to:
  /// **'هواري بومدين'**
  String get houariBoumediene;

  /// No description provided for @khezarra.
  ///
  /// In ar, this message translates to:
  /// **'خزارة'**
  String get khezarra;

  /// No description provided for @ouedZenati.
  ///
  /// In ar, this message translates to:
  /// **'وادي الزناتي'**
  String get ouedZenati;

  /// No description provided for @constantine.
  ///
  /// In ar, this message translates to:
  /// **'قسنطينة'**
  String get constantine;

  /// No description provided for @elKhroub.
  ///
  /// In ar, this message translates to:
  /// **'الخروب'**
  String get elKhroub;

  /// No description provided for @ainAbid.
  ///
  /// In ar, this message translates to:
  /// **'عين عبيد'**
  String get ainAbid;

  /// No description provided for @zighoudYoucef.
  ///
  /// In ar, this message translates to:
  /// **'زيغود يوسف'**
  String get zighoudYoucef;

  /// No description provided for @hammaBouziane.
  ///
  /// In ar, this message translates to:
  /// **'حامة بوزيان'**
  String get hammaBouziane;

  /// No description provided for @ibnZiad.
  ///
  /// In ar, this message translates to:
  /// **'ابن زياد'**
  String get ibnZiad;

  /// No description provided for @medea.
  ///
  /// In ar, this message translates to:
  /// **'المدية'**
  String get medea;

  /// No description provided for @ainBoucif.
  ///
  /// In ar, this message translates to:
  /// **'عين بوسيف'**
  String get ainBoucif;

  /// No description provided for @aziz.
  ///
  /// In ar, this message translates to:
  /// **'عزيز'**
  String get aziz;

  /// No description provided for @beniSlimane.
  ///
  /// In ar, this message translates to:
  /// **'بني سليمان'**
  String get beniSlimane;

  /// No description provided for @berrouaghia.
  ///
  /// In ar, this message translates to:
  /// **'البرواقية'**
  String get berrouaghia;

  /// No description provided for @chahbounia.
  ///
  /// In ar, this message translates to:
  /// **'شهبونية'**
  String get chahbounia;

  /// No description provided for @chellalettElAdhaoura.
  ///
  /// In ar, this message translates to:
  /// **'شلالة العذاورة'**
  String get chellalettElAdhaoura;

  /// No description provided for @elAzizia.
  ///
  /// In ar, this message translates to:
  /// **'العزيزية'**
  String get elAzizia;

  /// No description provided for @elGuelbElKebir.
  ///
  /// In ar, this message translates to:
  /// **'القلب الكبير'**
  String get elGuelbElKebir;

  /// No description provided for @elOmaria.
  ///
  /// In ar, this message translates to:
  /// **'العمارية'**
  String get elOmaria;

  /// No description provided for @ksarBoukhari.
  ///
  /// In ar, this message translates to:
  /// **'قصر البخاري'**
  String get ksarBoukhari;

  /// No description provided for @ouamri.
  ///
  /// In ar, this message translates to:
  /// **'وامري'**
  String get ouamri;

  /// No description provided for @ouledAntar.
  ///
  /// In ar, this message translates to:
  /// **'أولاد عنتر'**
  String get ouledAntar;

  /// No description provided for @ouzera.
  ///
  /// In ar, this message translates to:
  /// **'وزرة'**
  String get ouzera;

  /// No description provided for @seghouane.
  ///
  /// In ar, this message translates to:
  /// **'السغوان'**
  String get seghouane;

  /// No description provided for @sidiNaamane.
  ///
  /// In ar, this message translates to:
  /// **'سيدي نعمان'**
  String get sidiNaamane;

  /// No description provided for @siMahdjoub.
  ///
  /// In ar, this message translates to:
  /// **'سي المحجوب'**
  String get siMahdjoub;

  /// No description provided for @souagui.
  ///
  /// In ar, this message translates to:
  /// **'السواقي'**
  String get souagui;

  /// No description provided for @tablat.
  ///
  /// In ar, this message translates to:
  /// **'تابلاط'**
  String get tablat;

  /// No description provided for @mostaganem.
  ///
  /// In ar, this message translates to:
  /// **'مستغانم'**
  String get mostaganem;

  /// No description provided for @achaacha.
  ///
  /// In ar, this message translates to:
  /// **'عشعاشة'**
  String get achaacha;

  /// No description provided for @ainNouissi.
  ///
  /// In ar, this message translates to:
  /// **'عين نويسي'**
  String get ainNouissi;

  /// No description provided for @ainTadles.
  ///
  /// In ar, this message translates to:
  /// **'عين تادلس'**
  String get ainTadles;

  /// No description provided for @bouguirat.
  ///
  /// In ar, this message translates to:
  /// **'بوقيراط'**
  String get bouguirat;

  /// No description provided for @hassiMameche.
  ///
  /// In ar, this message translates to:
  /// **'حاسي مماش'**
  String get hassiMameche;

  /// No description provided for @kheireddine.
  ///
  /// In ar, this message translates to:
  /// **'خير الدين'**
  String get kheireddine;

  /// No description provided for @mesra.
  ///
  /// In ar, this message translates to:
  /// **'ماسرة'**
  String get mesra;

  /// No description provided for @sidiAli.
  ///
  /// In ar, this message translates to:
  /// **'سيدي علي'**
  String get sidiAli;

  /// No description provided for @sidiLakhdar.
  ///
  /// In ar, this message translates to:
  /// **'سيدي لخضر'**
  String get sidiLakhdar;

  /// No description provided for @mSila.
  ///
  /// In ar, this message translates to:
  /// **'المسيلة'**
  String get mSila;

  /// No description provided for @hammamDalaa.
  ///
  /// In ar, this message translates to:
  /// **'حمام الضلعة'**
  String get hammamDalaa;

  /// No description provided for @ouledDerradj.
  ///
  /// In ar, this message translates to:
  /// **'أولاد دراج'**
  String get ouledDerradj;

  /// No description provided for @sidiAissa.
  ///
  /// In ar, this message translates to:
  /// **'سيدي عيسى'**
  String get sidiAissa;

  /// No description provided for @ainElMelh.
  ///
  /// In ar, this message translates to:
  /// **'عين الملح'**
  String get ainElMelh;

  /// No description provided for @benSrour.
  ///
  /// In ar, this message translates to:
  /// **'بن سرور'**
  String get benSrour;

  /// No description provided for @bouSaada.
  ///
  /// In ar, this message translates to:
  /// **'بوسعادة'**
  String get bouSaada;

  /// No description provided for @ouledSidiBrahim.
  ///
  /// In ar, this message translates to:
  /// **'أولاد سيدي إبراهيم'**
  String get ouledSidiBrahim;

  /// No description provided for @sidiAmeur.
  ///
  /// In ar, this message translates to:
  /// **'سيدي عامر'**
  String get sidiAmeur;

  /// No description provided for @magra.
  ///
  /// In ar, this message translates to:
  /// **'مقرة'**
  String get magra;

  /// No description provided for @chellal.
  ///
  /// In ar, this message translates to:
  /// **'شلال'**
  String get chellal;

  /// No description provided for @khoubana.
  ///
  /// In ar, this message translates to:
  /// **'خبانة'**
  String get khoubana;

  /// No description provided for @medjedel.
  ///
  /// In ar, this message translates to:
  /// **'مجدل'**
  String get medjedel;

  /// No description provided for @ainElHadjel.
  ///
  /// In ar, this message translates to:
  /// **'عين الحجل'**
  String get ainElHadjel;

  /// No description provided for @djebelMessaad.
  ///
  /// In ar, this message translates to:
  /// **'جبل مساعد'**
  String get djebelMessaad;

  /// No description provided for @mascara.
  ///
  /// In ar, this message translates to:
  /// **'معسكر'**
  String get mascara;

  /// No description provided for @ainFares.
  ///
  /// In ar, this message translates to:
  /// **'عين فارس'**
  String get ainFares;

  /// No description provided for @ainFekan.
  ///
  /// In ar, this message translates to:
  /// **'عين فكان'**
  String get ainFekan;

  /// No description provided for @aouf.
  ///
  /// In ar, this message translates to:
  /// **'عوف'**
  String get aouf;

  /// No description provided for @bouHanifia.
  ///
  /// In ar, this message translates to:
  /// **'بوحنيفية'**
  String get bouHanifia;

  /// No description provided for @elBordj.
  ///
  /// In ar, this message translates to:
  /// **'البرج'**
  String get elBordj;

  /// No description provided for @ghriss.
  ///
  /// In ar, this message translates to:
  /// **'غريس'**
  String get ghriss;

  /// No description provided for @hachem.
  ///
  /// In ar, this message translates to:
  /// **'الحشم'**
  String get hachem;

  /// No description provided for @mohammadia.
  ///
  /// In ar, this message translates to:
  /// **'المحمدية'**
  String get mohammadia;

  /// No description provided for @oggaz.
  ///
  /// In ar, this message translates to:
  /// **'عقاز'**
  String get oggaz;

  /// No description provided for @ouedElAbtal.
  ///
  /// In ar, this message translates to:
  /// **'وادي الأبطال'**
  String get ouedElAbtal;

  /// No description provided for @ouedTaria.
  ///
  /// In ar, this message translates to:
  /// **'وادي التاغية'**
  String get ouedTaria;

  /// No description provided for @sig.
  ///
  /// In ar, this message translates to:
  /// **'سيق'**
  String get sig;

  /// No description provided for @tighennif.
  ///
  /// In ar, this message translates to:
  /// **'تيغنيف'**
  String get tighennif;

  /// No description provided for @tizi.
  ///
  /// In ar, this message translates to:
  /// **'تيزي'**
  String get tizi;

  /// No description provided for @zahana.
  ///
  /// In ar, this message translates to:
  /// **'زهانة'**
  String get zahana;

  /// No description provided for @ouargla.
  ///
  /// In ar, this message translates to:
  /// **'ورقلة'**
  String get ouargla;

  /// No description provided for @elBorma.
  ///
  /// In ar, this message translates to:
  /// **'البرمة'**
  String get elBorma;

  /// No description provided for @hassiMessaoud.
  ///
  /// In ar, this message translates to:
  /// **'حاسي مسعود'**
  String get hassiMessaoud;

  /// No description provided for @nGoussa.
  ///
  /// In ar, this message translates to:
  /// **'نقوسة'**
  String get nGoussa;

  /// No description provided for @sidiKhouiled.
  ///
  /// In ar, this message translates to:
  /// **'سيدي خويلد'**
  String get sidiKhouiled;

  /// No description provided for @oran.
  ///
  /// In ar, this message translates to:
  /// **'وهران'**
  String get oran;

  /// No description provided for @ainElTurk.
  ///
  /// In ar, this message translates to:
  /// **'عين الترك'**
  String get ainElTurk;

  /// No description provided for @arzew.
  ///
  /// In ar, this message translates to:
  /// **'أرزيو'**
  String get arzew;

  /// No description provided for @bethioua.
  ///
  /// In ar, this message translates to:
  /// **'بطيوة'**
  String get bethioua;

  /// No description provided for @esSenia.
  ///
  /// In ar, this message translates to:
  /// **'السانية'**
  String get esSenia;

  /// No description provided for @birElDjir.
  ///
  /// In ar, this message translates to:
  /// **'بئر الجير'**
  String get birElDjir;

  /// No description provided for @boutlelis.
  ///
  /// In ar, this message translates to:
  /// **'بوتليليس'**
  String get boutlelis;

  /// No description provided for @ouedTlelat.
  ///
  /// In ar, this message translates to:
  /// **'وادي تليلات'**
  String get ouedTlelat;

  /// No description provided for @gdyel.
  ///
  /// In ar, this message translates to:
  /// **'قديل'**
  String get gdyel;

  /// No description provided for @elBayadh.
  ///
  /// In ar, this message translates to:
  /// **'البيض'**
  String get elBayadh;

  /// No description provided for @rogassa.
  ///
  /// In ar, this message translates to:
  /// **'رقاصة'**
  String get rogassa;

  /// No description provided for @brezina.
  ///
  /// In ar, this message translates to:
  /// **'بريزينة'**
  String get brezina;

  /// No description provided for @elAbiodhSidiCheikh.
  ///
  /// In ar, this message translates to:
  /// **'الأبيض سيدي الشيخ'**
  String get elAbiodhSidiCheikh;

  /// No description provided for @bougtoub.
  ///
  /// In ar, this message translates to:
  /// **'بوقطب'**
  String get bougtoub;

  /// No description provided for @chellala.
  ///
  /// In ar, this message translates to:
  /// **'شلالة'**
  String get chellala;

  /// No description provided for @boussemghoun.
  ///
  /// In ar, this message translates to:
  /// **'بوسمغون'**
  String get boussemghoun;

  /// No description provided for @boualem.
  ///
  /// In ar, this message translates to:
  /// **'بوعلام'**
  String get boualem;

  /// No description provided for @illizi.
  ///
  /// In ar, this message translates to:
  /// **'إليزي'**
  String get illizi;

  /// No description provided for @inAmenas.
  ///
  /// In ar, this message translates to:
  /// **'عين أمناس'**
  String get inAmenas;

  /// No description provided for @bordjBouArreridj.
  ///
  /// In ar, this message translates to:
  /// **'برج بوعريريج'**
  String get bordjBouArreridj;

  /// No description provided for @ainTaghrout.
  ///
  /// In ar, this message translates to:
  /// **'عين تاغروت'**
  String get ainTaghrout;

  /// No description provided for @rasElOued.
  ///
  /// In ar, this message translates to:
  /// **'رأس الوادي'**
  String get rasElOued;

  /// No description provided for @bordjGhedir.
  ///
  /// In ar, this message translates to:
  /// **'برج الغدير'**
  String get bordjGhedir;

  /// No description provided for @birKasdali.
  ///
  /// In ar, this message translates to:
  /// **'بئر قاصد علي'**
  String get birKasdali;

  /// No description provided for @elHamadia.
  ///
  /// In ar, this message translates to:
  /// **'الحمادية'**
  String get elHamadia;

  /// No description provided for @medjana.
  ///
  /// In ar, this message translates to:
  /// **'مجانة'**
  String get medjana;

  /// No description provided for @bordjZemoura.
  ///
  /// In ar, this message translates to:
  /// **'برج زمورة'**
  String get bordjZemoura;

  /// No description provided for @djaafra.
  ///
  /// In ar, this message translates to:
  /// **'جعافرة'**
  String get djaafra;

  /// No description provided for @boumerdes.
  ///
  /// In ar, this message translates to:
  /// **'بومرداس'**
  String get boumerdes;

  /// No description provided for @baghlia.
  ///
  /// In ar, this message translates to:
  /// **'بغلية'**
  String get baghlia;

  /// No description provided for @boudouaou.
  ///
  /// In ar, this message translates to:
  /// **'بودواو'**
  String get boudouaou;

  /// No description provided for @bordjMenaiel.
  ///
  /// In ar, this message translates to:
  /// **'برج منايل'**
  String get bordjMenaiel;

  /// No description provided for @dellys.
  ///
  /// In ar, this message translates to:
  /// **'دلس'**
  String get dellys;

  /// No description provided for @khemisElKechna.
  ///
  /// In ar, this message translates to:
  /// **'خميس الخشنة'**
  String get khemisElKechna;

  /// No description provided for @isser.
  ///
  /// In ar, this message translates to:
  /// **'يسر'**
  String get isser;

  /// No description provided for @naciria.
  ///
  /// In ar, this message translates to:
  /// **'الناصرية'**
  String get naciria;

  /// No description provided for @thenia.
  ///
  /// In ar, this message translates to:
  /// **'الثنية'**
  String get thenia;

  /// No description provided for @elTarf.
  ///
  /// In ar, this message translates to:
  /// **'الطارف'**
  String get elTarf;

  /// No description provided for @elKala.
  ///
  /// In ar, this message translates to:
  /// **'القالة'**
  String get elKala;

  /// No description provided for @benMhidi.
  ///
  /// In ar, this message translates to:
  /// **'بن مهيدي'**
  String get benMhidi;

  /// No description provided for @besbes.
  ///
  /// In ar, this message translates to:
  /// **'البسباس'**
  String get besbes;

  /// No description provided for @drean.
  ///
  /// In ar, this message translates to:
  /// **'الذرعان'**
  String get drean;

  /// No description provided for @bouhadjar.
  ///
  /// In ar, this message translates to:
  /// **'بوحجار'**
  String get bouhadjar;

  /// No description provided for @bouteldja.
  ///
  /// In ar, this message translates to:
  /// **'بوثلجة'**
  String get bouteldja;

  /// No description provided for @tindouf.
  ///
  /// In ar, this message translates to:
  /// **'تندوف'**
  String get tindouf;

  /// No description provided for @tissemsilt.
  ///
  /// In ar, this message translates to:
  /// **'تيسمسيلت'**
  String get tissemsilt;

  /// No description provided for @ammari.
  ///
  /// In ar, this message translates to:
  /// **'عماري'**
  String get ammari;

  /// No description provided for @bordjBouNaama.
  ///
  /// In ar, this message translates to:
  /// **'برج بونعامة'**
  String get bordjBouNaama;

  /// No description provided for @bordjElEmirAbdelkader.
  ///
  /// In ar, this message translates to:
  /// **'برج الأمير عبد القادر'**
  String get bordjElEmirAbdelkader;

  /// No description provided for @khemisti.
  ///
  /// In ar, this message translates to:
  /// **'خميستي'**
  String get khemisti;

  /// No description provided for @lardjem.
  ///
  /// In ar, this message translates to:
  /// **'لرجام'**
  String get lardjem;

  /// No description provided for @lazharia.
  ///
  /// In ar, this message translates to:
  /// **'الأزهرية'**
  String get lazharia;

  /// No description provided for @thenietElHad.
  ///
  /// In ar, this message translates to:
  /// **'ثنية الأحد'**
  String get thenietElHad;

  /// No description provided for @elOued.
  ///
  /// In ar, this message translates to:
  /// **'الوادي'**
  String get elOued;

  /// No description provided for @bayadha.
  ///
  /// In ar, this message translates to:
  /// **'البياضة'**
  String get bayadha;

  /// No description provided for @debila.
  ///
  /// In ar, this message translates to:
  /// **'الدبيلة'**
  String get debila;

  /// No description provided for @guemar.
  ///
  /// In ar, this message translates to:
  /// **'قمار'**
  String get guemar;

  /// No description provided for @hassiKhalifa.
  ///
  /// In ar, this message translates to:
  /// **'حاسي خليفة'**
  String get hassiKhalifa;

  /// No description provided for @magrane.
  ///
  /// In ar, this message translates to:
  /// **'المقرن'**
  String get magrane;

  /// No description provided for @mihOuensa.
  ///
  /// In ar, this message translates to:
  /// **'اميه وانسة'**
  String get mihOuensa;

  /// No description provided for @reguiba.
  ///
  /// In ar, this message translates to:
  /// **'الرقيبة'**
  String get reguiba;

  /// No description provided for @robbah.
  ///
  /// In ar, this message translates to:
  /// **'الرباح'**
  String get robbah;

  /// No description provided for @talebLarbi.
  ///
  /// In ar, this message translates to:
  /// **'الطالب العربي'**
  String get talebLarbi;

  /// No description provided for @khenchela.
  ///
  /// In ar, this message translates to:
  /// **'خنشلة'**
  String get khenchela;

  /// No description provided for @babar.
  ///
  /// In ar, this message translates to:
  /// **'بابار'**
  String get babar;

  /// No description provided for @bouhmama.
  ///
  /// In ar, this message translates to:
  /// **'بوحمامة'**
  String get bouhmama;

  /// No description provided for @chechar.
  ///
  /// In ar, this message translates to:
  /// **'ششار'**
  String get chechar;

  /// No description provided for @elHamma.
  ///
  /// In ar, this message translates to:
  /// **'الحامة'**
  String get elHamma;

  /// No description provided for @kais.
  ///
  /// In ar, this message translates to:
  /// **'قايس'**
  String get kais;

  /// No description provided for @ouledRechache.
  ///
  /// In ar, this message translates to:
  /// **'أولاد رشاش'**
  String get ouledRechache;

  /// No description provided for @ainTouila.
  ///
  /// In ar, this message translates to:
  /// **'عين الطويلة'**
  String get ainTouila;

  /// No description provided for @soukAhras.
  ///
  /// In ar, this message translates to:
  /// **'سوق أهراس'**
  String get soukAhras;

  /// No description provided for @birBouHaouch.
  ///
  /// In ar, this message translates to:
  /// **'بئر بوحوش'**
  String get birBouHaouch;

  /// No description provided for @heddada.
  ///
  /// In ar, this message translates to:
  /// **'الحدادة'**
  String get heddada;

  /// No description provided for @mdaourouch.
  ///
  /// In ar, this message translates to:
  /// **'مداوروش'**
  String get mdaourouch;

  /// No description provided for @mechroha.
  ///
  /// In ar, this message translates to:
  /// **'المشروحة'**
  String get mechroha;

  /// No description provided for @merahna.
  ///
  /// In ar, this message translates to:
  /// **'المراهنة'**
  String get merahna;

  /// No description provided for @ouledDriss.
  ///
  /// In ar, this message translates to:
  /// **'أولاد إدريس'**
  String get ouledDriss;

  /// No description provided for @oumElAdhaim.
  ///
  /// In ar, this message translates to:
  /// **'أم العظايم'**
  String get oumElAdhaim;

  /// No description provided for @sedrata.
  ///
  /// In ar, this message translates to:
  /// **'سدراتة'**
  String get sedrata;

  /// No description provided for @taoura.
  ///
  /// In ar, this message translates to:
  /// **'تاورة'**
  String get taoura;

  /// No description provided for @tipaza.
  ///
  /// In ar, this message translates to:
  /// **'تيبازة'**
  String get tipaza;

  /// No description provided for @ahmarElAin.
  ///
  /// In ar, this message translates to:
  /// **'أحمر العين'**
  String get ahmarElAin;

  /// No description provided for @bouIsmail.
  ///
  /// In ar, this message translates to:
  /// **'بواسماعيل'**
  String get bouIsmail;

  /// No description provided for @cherchell.
  ///
  /// In ar, this message translates to:
  /// **'شرشال'**
  String get cherchell;

  /// No description provided for @damous.
  ///
  /// In ar, this message translates to:
  /// **'الداموس'**
  String get damous;

  /// No description provided for @fouka.
  ///
  /// In ar, this message translates to:
  /// **'فوكة'**
  String get fouka;

  /// No description provided for @gouraya.
  ///
  /// In ar, this message translates to:
  /// **'قوراية'**
  String get gouraya;

  /// No description provided for @hadjout.
  ///
  /// In ar, this message translates to:
  /// **'حجوط'**
  String get hadjout;

  /// No description provided for @kolea.
  ///
  /// In ar, this message translates to:
  /// **'القليعة'**
  String get kolea;

  /// No description provided for @sidiAmar.
  ///
  /// In ar, this message translates to:
  /// **'سيدي عمار'**
  String get sidiAmar;

  /// No description provided for @mila.
  ///
  /// In ar, this message translates to:
  /// **'ميلة'**
  String get mila;

  /// No description provided for @chelghoumLaid.
  ///
  /// In ar, this message translates to:
  /// **'شلغوم العيد'**
  String get chelghoumLaid;

  /// No description provided for @ferdjioua.
  ///
  /// In ar, this message translates to:
  /// **'فرجيوة'**
  String get ferdjioua;

  /// No description provided for @graremGouga.
  ///
  /// In ar, this message translates to:
  /// **'قرارم قوقة'**
  String get graremGouga;

  /// No description provided for @ouedEndja.
  ///
  /// In ar, this message translates to:
  /// **'واد النجاء'**
  String get ouedEndja;

  /// No description provided for @rouached.
  ///
  /// In ar, this message translates to:
  /// **'الرواشد'**
  String get rouached;

  /// No description provided for @terraiBainen.
  ///
  /// In ar, this message translates to:
  /// **'ترعي باينان'**
  String get terraiBainen;

  /// No description provided for @tassadaneHaddada.
  ///
  /// In ar, this message translates to:
  /// **'تسدان حدادة'**
  String get tassadaneHaddada;

  /// No description provided for @ainBeidaHarriche.
  ///
  /// In ar, this message translates to:
  /// **'عين البيضاء حريش'**
  String get ainBeidaHarriche;

  /// No description provided for @sidiMerouane.
  ///
  /// In ar, this message translates to:
  /// **'سيدي مروان'**
  String get sidiMerouane;

  /// No description provided for @teleghma.
  ///
  /// In ar, this message translates to:
  /// **'تلاغمة'**
  String get teleghma;

  /// No description provided for @bouhatem.
  ///
  /// In ar, this message translates to:
  /// **'بوحاتم'**
  String get bouhatem;

  /// No description provided for @tadjenanet.
  ///
  /// In ar, this message translates to:
  /// **'تاجنانت'**
  String get tadjenanet;

  /// No description provided for @ainDefla.
  ///
  /// In ar, this message translates to:
  /// **'عين الدفلى'**
  String get ainDefla;

  /// No description provided for @ainLechiekh.
  ///
  /// In ar, this message translates to:
  /// **'عين الاشياخ'**
  String get ainLechiekh;

  /// No description provided for @bathia.
  ///
  /// In ar, this message translates to:
  /// **'بطحية'**
  String get bathia;

  /// No description provided for @bordjEmirKhaled.
  ///
  /// In ar, this message translates to:
  /// **'برج الأمير خالد'**
  String get bordjEmirKhaled;

  /// No description provided for @boumedfaa.
  ///
  /// In ar, this message translates to:
  /// **'بومدفع'**
  String get boumedfaa;

  /// No description provided for @djelida.
  ///
  /// In ar, this message translates to:
  /// **'جليدة'**
  String get djelida;

  /// No description provided for @djendel.
  ///
  /// In ar, this message translates to:
  /// **'جندل'**
  String get djendel;

  /// No description provided for @elAbadia.
  ///
  /// In ar, this message translates to:
  /// **'العبادية'**
  String get elAbadia;

  /// No description provided for @elAmra.
  ///
  /// In ar, this message translates to:
  /// **'العامرة'**
  String get elAmra;

  /// No description provided for @elAttaf.
  ///
  /// In ar, this message translates to:
  /// **'العطاف'**
  String get elAttaf;

  /// No description provided for @hammamRigha.
  ///
  /// In ar, this message translates to:
  /// **'حمام ريغة'**
  String get hammamRigha;

  /// No description provided for @khemisMiliana.
  ///
  /// In ar, this message translates to:
  /// **'خميس مليانة'**
  String get khemisMiliana;

  /// No description provided for @miliana.
  ///
  /// In ar, this message translates to:
  /// **'مليانة'**
  String get miliana;

  /// No description provided for @rouina.
  ///
  /// In ar, this message translates to:
  /// **'الروينة'**
  String get rouina;

  /// No description provided for @naama.
  ///
  /// In ar, this message translates to:
  /// **'النعامة'**
  String get naama;

  /// No description provided for @ainSefra.
  ///
  /// In ar, this message translates to:
  /// **'عين الصفراء'**
  String get ainSefra;

  /// No description provided for @assela.
  ///
  /// In ar, this message translates to:
  /// **'عسلة'**
  String get assela;

  /// No description provided for @makmanBenAmer.
  ///
  /// In ar, this message translates to:
  /// **'مكمن بن عامر'**
  String get makmanBenAmer;

  /// No description provided for @mecheria.
  ///
  /// In ar, this message translates to:
  /// **'المشرية'**
  String get mecheria;

  /// No description provided for @moghrar.
  ///
  /// In ar, this message translates to:
  /// **'مغرار'**
  String get moghrar;

  /// No description provided for @sfissifa.
  ///
  /// In ar, this message translates to:
  /// **'صفيصيفة'**
  String get sfissifa;

  /// No description provided for @ainElArbaa.
  ///
  /// In ar, this message translates to:
  /// **'عين الأربعاء'**
  String get ainElArbaa;

  /// No description provided for @ainKihal.
  ///
  /// In ar, this message translates to:
  /// **'عين الكيحل'**
  String get ainKihal;

  /// No description provided for @ainTemouchent.
  ///
  /// In ar, this message translates to:
  /// **'عين تموشنت'**
  String get ainTemouchent;

  /// No description provided for @beniSaf.
  ///
  /// In ar, this message translates to:
  /// **'بني صاف'**
  String get beniSaf;

  /// No description provided for @elAmria.
  ///
  /// In ar, this message translates to:
  /// **'العامرية'**
  String get elAmria;

  /// No description provided for @elMalah.
  ///
  /// In ar, this message translates to:
  /// **'المالح'**
  String get elMalah;

  /// No description provided for @hammamBouHadjar.
  ///
  /// In ar, this message translates to:
  /// **'حمام بوحجر'**
  String get hammamBouHadjar;

  /// No description provided for @oulhacaElGheraba.
  ///
  /// In ar, this message translates to:
  /// **'أولحاسة الغرابة'**
  String get oulhacaElGheraba;

  /// No description provided for @ghardaia.
  ///
  /// In ar, this message translates to:
  /// **'غرداية'**
  String get ghardaia;

  /// No description provided for @elMeniaa.
  ///
  /// In ar, this message translates to:
  /// **'المنيعة'**
  String get elMeniaa;

  /// No description provided for @metlili.
  ///
  /// In ar, this message translates to:
  /// **'متليلي'**
  String get metlili;

  /// No description provided for @berriane.
  ///
  /// In ar, this message translates to:
  /// **'بريان'**
  String get berriane;

  /// No description provided for @daiaBenDahoua.
  ///
  /// In ar, this message translates to:
  /// **'ضاية بن ضحوة'**
  String get daiaBenDahoua;

  /// No description provided for @mansoura.
  ///
  /// In ar, this message translates to:
  /// **'منصورة'**
  String get mansoura;

  /// No description provided for @zelfana.
  ///
  /// In ar, this message translates to:
  /// **'زلفانة'**
  String get zelfana;

  /// No description provided for @guerrara.
  ///
  /// In ar, this message translates to:
  /// **'القرارة'**
  String get guerrara;

  /// No description provided for @bounoura.
  ///
  /// In ar, this message translates to:
  /// **'بونورة'**
  String get bounoura;

  /// No description provided for @ainTarek.
  ///
  /// In ar, this message translates to:
  /// **'عين طارق'**
  String get ainTarek;

  /// No description provided for @ammiMoussa.
  ///
  /// In ar, this message translates to:
  /// **'عمي موسى'**
  String get ammiMoussa;

  /// No description provided for @djidioua.
  ///
  /// In ar, this message translates to:
  /// **'جديوية'**
  String get djidioua;

  /// No description provided for @elHamadna.
  ///
  /// In ar, this message translates to:
  /// **'الحمادنة'**
  String get elHamadna;

  /// No description provided for @elMatmar.
  ///
  /// In ar, this message translates to:
  /// **'المطمر'**
  String get elMatmar;

  /// No description provided for @mazouna.
  ///
  /// In ar, this message translates to:
  /// **'مازونة'**
  String get mazouna;

  /// No description provided for @mendes.
  ///
  /// In ar, this message translates to:
  /// **'منداس'**
  String get mendes;

  /// No description provided for @ouedRhiou.
  ///
  /// In ar, this message translates to:
  /// **'وادي رهيو'**
  String get ouedRhiou;

  /// No description provided for @ramka.
  ///
  /// In ar, this message translates to:
  /// **'الرمكة'**
  String get ramka;

  /// No description provided for @relizane.
  ///
  /// In ar, this message translates to:
  /// **'غليزان'**
  String get relizane;

  /// No description provided for @sidiMHamedBenAli.
  ///
  /// In ar, this message translates to:
  /// **'سيدي امحمد بن علي'**
  String get sidiMHamedBenAli;

  /// No description provided for @yellel.
  ///
  /// In ar, this message translates to:
  /// **'يلل'**
  String get yellel;

  /// No description provided for @zemmora.
  ///
  /// In ar, this message translates to:
  /// **'زمورة'**
  String get zemmora;

  /// No description provided for @tinerkouk.
  ///
  /// In ar, this message translates to:
  /// **'تينركوك'**
  String get tinerkouk;

  /// No description provided for @charouine.
  ///
  /// In ar, this message translates to:
  /// **'شروين'**
  String get charouine;

  /// No description provided for @bordjBadjiMokhtar.
  ///
  /// In ar, this message translates to:
  /// **'برج باجي مختار'**
  String get bordjBadjiMokhtar;

  /// No description provided for @ouledDjellal.
  ///
  /// In ar, this message translates to:
  /// **'أولاد جلال'**
  String get ouledDjellal;

  /// No description provided for @kerzaz.
  ///
  /// In ar, this message translates to:
  /// **'كرزاز'**
  String get kerzaz;

  /// No description provided for @timoudi.
  ///
  /// In ar, this message translates to:
  /// **'تيمودي'**
  String get timoudi;

  /// No description provided for @inSalah.
  ///
  /// In ar, this message translates to:
  /// **'عين صالح'**
  String get inSalah;

  /// No description provided for @inGuezzam.
  ///
  /// In ar, this message translates to:
  /// **'عين قزام'**
  String get inGuezzam;

  /// No description provided for @tinZaouatine.
  ///
  /// In ar, this message translates to:
  /// **'تين زواتين'**
  String get tinZaouatine;

  /// No description provided for @elHadjira.
  ///
  /// In ar, this message translates to:
  /// **'الحجيرة'**
  String get elHadjira;

  /// No description provided for @megarine.
  ///
  /// In ar, this message translates to:
  /// **'المقارين'**
  String get megarine;

  /// No description provided for @taibet.
  ///
  /// In ar, this message translates to:
  /// **'الطيبات'**
  String get taibet;

  /// No description provided for @tamacine.
  ///
  /// In ar, this message translates to:
  /// **'تماسين'**
  String get tamacine;

  /// No description provided for @touggourt.
  ///
  /// In ar, this message translates to:
  /// **'تقرت'**
  String get touggourt;

  /// No description provided for @djanet.
  ///
  /// In ar, this message translates to:
  /// **'جانت'**
  String get djanet;

  /// No description provided for @elMGhair.
  ///
  /// In ar, this message translates to:
  /// **'المغير'**
  String get elMGhair;

  /// No description provided for @djamaa.
  ///
  /// In ar, this message translates to:
  /// **'جامعة'**
  String get djamaa;

  /// No description provided for @pleaseSelectLabel.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار '**
  String get pleaseSelectLabel;

  /// No description provided for @languageEnglish.
  ///
  /// In ar, this message translates to:
  /// **'الإنجليزية'**
  String get languageEnglish;

  /// No description provided for @languageFrench.
  ///
  /// In ar, this message translates to:
  /// **'الفرنسية'**
  String get languageFrench;

  /// No description provided for @languageArabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @please_enter_all_info.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال جميع المعلومات'**
  String get please_enter_all_info;

  /// No description provided for @invalid_email_format.
  ///
  /// In ar, this message translates to:
  /// **'صيغة البريد الإلكتروني غير صحيحة'**
  String get invalid_email_format;

  /// No description provided for @invalid_phone_format.
  ///
  /// In ar, this message translates to:
  /// **'صيغة رقم الهاتف غير صحيحة'**
  String get invalid_phone_format;

  /// No description provided for @password_min_length.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور يجب أن تكون 6 أحرف على الأقل'**
  String get password_min_length;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور غير متطابقة'**
  String get passwords_do_not_match;

  /// No description provided for @verify_email_title.
  ///
  /// In ar, this message translates to:
  /// **' تبقّى القليل ! '**
  String get verify_email_title;

  /// No description provided for @verify_email_desc.
  ///
  /// In ar, this message translates to:
  /// **'يرجى التحقق من بريدك الإلكتروني من خلال النقر على الرابط المرسل إلى'**
  String get verify_email_desc;

  /// No description provided for @after_verification_login.
  ///
  /// In ar, this message translates to:
  /// **'بعد التحقق، قم بتسجيل الدخول مرة أخرى'**
  String get after_verification_login;

  /// No description provided for @logging_in.
  ///
  /// In ar, this message translates to:
  /// **'جاري تسجيل الدخول ... ⏳'**
  String get logging_in;

  /// No description provided for @error_no_user_found.
  ///
  /// In ar, this message translates to:
  /// **'❌ لا يوجد مستخدم بهذا البريد الإلكتروني'**
  String get error_no_user_found;

  /// No description provided for @error_wrong_password.
  ///
  /// In ar, this message translates to:
  /// **'🔑 كلمة المرور غير صحيحة'**
  String get error_wrong_password;

  /// No description provided for @error_login_failed.
  ///
  /// In ar, this message translates to:
  /// **'⚠️ حدث خطأ أثناء تسجيل الدخول'**
  String get error_login_failed;

  /// No description provided for @error_unexpected.
  ///
  /// In ar, this message translates to:
  /// **'⚠️ حدث خطأ غير متوقع'**
  String get error_unexpected;

  /// No description provided for @error_email_already_used.
  ///
  /// In ar, this message translates to:
  /// **'📧 البريد الإلكتروني مسجل مسبقًا'**
  String get error_email_already_used;

  /// No description provided for @error_signup_unexpected.
  ///
  /// In ar, this message translates to:
  /// **'⚠️ حدث خطأ غير متوقع أثناء إنشاء الحساب'**
  String get error_signup_unexpected;

  /// No description provided for @error_generic_unexpected.
  ///
  /// In ar, this message translates to:
  /// **'⚠️ حدث خطأ غير متوقع'**
  String get error_generic_unexpected;

  /// No description provided for @error_enter_email.
  ///
  /// In ar, this message translates to:
  /// **'❌ يرجى إدخال البريد الإلكتروني'**
  String get error_enter_email;

  /// No description provided for @error_no_account_for_email.
  ///
  /// In ar, this message translates to:
  /// **'❌ لا يوجد حساب مرتبط بهذا البريد الإلكتروني'**
  String get error_no_account_for_email;

  /// No description provided for @error_reset_password_failed.
  ///
  /// In ar, this message translates to:
  /// **'⚠️ حدث خطأ أثناء إرسال طلب إعادة تعيين كلمة المرور'**
  String get error_reset_password_failed;

  /// No description provided for @password_reset_title.
  ///
  /// In ar, this message translates to:
  /// **'🔑 إعادة تعيين كلمة المرور'**
  String get password_reset_title;

  /// No description provided for @password_reset_success_desc.
  ///
  /// In ar, this message translates to:
  /// **'📩 تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني'**
  String get password_reset_success_desc;

  /// No description provided for @error_google_signin.
  ///
  /// In ar, this message translates to:
  /// **'⚠️ حدث خطأ أثناء تسجيل الدخول باستخدام جوجل'**
  String get error_google_signin;

  /// No description provided for @confirm_delete_title.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الحذف'**
  String get confirm_delete_title;

  /// No description provided for @confirm_delete_message.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد أنك تريد حذف هذا التعليق؟'**
  String get confirm_delete_message;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @congratulations.
  ///
  /// In ar, this message translates to:
  /// **'🎉 تهانينا'**
  String get congratulations;

  /// No description provided for @successMessage.
  ///
  /// In ar, this message translates to:
  /// **'واو! أنت الآن'**
  String get successMessage;

  /// No description provided for @alert.
  ///
  /// In ar, this message translates to:
  /// **'⚠️ تنبيه'**
  String get alert;

  /// No description provided for @alertMessage.
  ///
  /// In ar, this message translates to:
  /// **'يجب عليك تحميل بعض الملفات .. بعد التحقق ستتلقى إشعارًا'**
  String get alertMessage;

  /// No description provided for @switchActiveProfile.
  ///
  /// In ar, this message translates to:
  /// **'تبديل الحساب النشط'**
  String get switchActiveProfile;

  /// No description provided for @alertContent.
  ///
  /// In ar, this message translates to:
  /// **'هذا النوع غير مفعل من طرف الإدارة'**
  String get alertContent;

  /// No description provided for @wilaya01.
  ///
  /// In ar, this message translates to:
  /// **'01 - أدرار'**
  String get wilaya01;

  /// No description provided for @wilaya02.
  ///
  /// In ar, this message translates to:
  /// **'02 - الشلف'**
  String get wilaya02;

  /// No description provided for @wilaya03.
  ///
  /// In ar, this message translates to:
  /// **'03 - الأغواط'**
  String get wilaya03;

  /// No description provided for @wilaya04.
  ///
  /// In ar, this message translates to:
  /// **'04 - أم البواقي'**
  String get wilaya04;

  /// No description provided for @wilaya05.
  ///
  /// In ar, this message translates to:
  /// **'05 - باتنة'**
  String get wilaya05;

  /// No description provided for @wilaya06.
  ///
  /// In ar, this message translates to:
  /// **'06 - بجاية'**
  String get wilaya06;

  /// No description provided for @wilaya07.
  ///
  /// In ar, this message translates to:
  /// **'07 - بسكرة'**
  String get wilaya07;

  /// No description provided for @wilaya08.
  ///
  /// In ar, this message translates to:
  /// **'08 - بشار'**
  String get wilaya08;

  /// No description provided for @wilaya09.
  ///
  /// In ar, this message translates to:
  /// **'09 - البليدة'**
  String get wilaya09;

  /// No description provided for @wilaya10.
  ///
  /// In ar, this message translates to:
  /// **'10 - البويرة'**
  String get wilaya10;

  /// No description provided for @wilaya11.
  ///
  /// In ar, this message translates to:
  /// **'11 - تمنراست'**
  String get wilaya11;

  /// No description provided for @wilaya12.
  ///
  /// In ar, this message translates to:
  /// **'12 - تبسة'**
  String get wilaya12;

  /// No description provided for @wilaya13.
  ///
  /// In ar, this message translates to:
  /// **'13 - تلمسان'**
  String get wilaya13;

  /// No description provided for @wilaya14.
  ///
  /// In ar, this message translates to:
  /// **'14 - تيارت'**
  String get wilaya14;

  /// No description provided for @wilaya15.
  ///
  /// In ar, this message translates to:
  /// **'15 - تيزي وزو'**
  String get wilaya15;

  /// No description provided for @wilaya16.
  ///
  /// In ar, this message translates to:
  /// **'16 - الجزائر'**
  String get wilaya16;

  /// No description provided for @wilaya17.
  ///
  /// In ar, this message translates to:
  /// **'17 - الجلفة'**
  String get wilaya17;

  /// No description provided for @wilaya18.
  ///
  /// In ar, this message translates to:
  /// **'18 - جيجل'**
  String get wilaya18;

  /// No description provided for @wilaya19.
  ///
  /// In ar, this message translates to:
  /// **'19 - سطيف'**
  String get wilaya19;

  /// No description provided for @wilaya20.
  ///
  /// In ar, this message translates to:
  /// **'20 - سعيدة'**
  String get wilaya20;

  /// No description provided for @wilaya21.
  ///
  /// In ar, this message translates to:
  /// **'21 - سكيكدة'**
  String get wilaya21;

  /// No description provided for @wilaya22.
  ///
  /// In ar, this message translates to:
  /// **'22 - سيدي بلعباس'**
  String get wilaya22;

  /// No description provided for @wilaya23.
  ///
  /// In ar, this message translates to:
  /// **'23 - عنابة'**
  String get wilaya23;

  /// No description provided for @wilaya24.
  ///
  /// In ar, this message translates to:
  /// **'24 - قالمة'**
  String get wilaya24;

  /// No description provided for @wilaya25.
  ///
  /// In ar, this message translates to:
  /// **'25 - قسنطينة'**
  String get wilaya25;

  /// No description provided for @wilaya26.
  ///
  /// In ar, this message translates to:
  /// **'26 - المدية'**
  String get wilaya26;

  /// No description provided for @wilaya27.
  ///
  /// In ar, this message translates to:
  /// **'27 - مستغانم'**
  String get wilaya27;

  /// No description provided for @wilaya28.
  ///
  /// In ar, this message translates to:
  /// **'28 - المسيلة'**
  String get wilaya28;

  /// No description provided for @wilaya29.
  ///
  /// In ar, this message translates to:
  /// **'29 - معسكر'**
  String get wilaya29;

  /// No description provided for @wilaya30.
  ///
  /// In ar, this message translates to:
  /// **'30 - ورقلة'**
  String get wilaya30;

  /// No description provided for @wilaya31.
  ///
  /// In ar, this message translates to:
  /// **'31 - وهران'**
  String get wilaya31;

  /// No description provided for @wilaya32.
  ///
  /// In ar, this message translates to:
  /// **'32 - البيض'**
  String get wilaya32;

  /// No description provided for @wilaya33.
  ///
  /// In ar, this message translates to:
  /// **'33 - إليزي'**
  String get wilaya33;

  /// No description provided for @wilaya34.
  ///
  /// In ar, this message translates to:
  /// **'34 - برج بوعريريج'**
  String get wilaya34;

  /// No description provided for @wilaya35.
  ///
  /// In ar, this message translates to:
  /// **'35 - بومرداس'**
  String get wilaya35;

  /// No description provided for @wilaya36.
  ///
  /// In ar, this message translates to:
  /// **'36 - الطارف'**
  String get wilaya36;

  /// No description provided for @wilaya37.
  ///
  /// In ar, this message translates to:
  /// **'37 - تندوف'**
  String get wilaya37;

  /// No description provided for @wilaya38.
  ///
  /// In ar, this message translates to:
  /// **'38 - تيسمسيلت'**
  String get wilaya38;

  /// No description provided for @wilaya39.
  ///
  /// In ar, this message translates to:
  /// **'39 - الوادي'**
  String get wilaya39;

  /// No description provided for @wilaya40.
  ///
  /// In ar, this message translates to:
  /// **'40 - خنشلة'**
  String get wilaya40;

  /// No description provided for @wilaya41.
  ///
  /// In ar, this message translates to:
  /// **'41 - سوق أهراس'**
  String get wilaya41;

  /// No description provided for @wilaya42.
  ///
  /// In ar, this message translates to:
  /// **'42 - تيبازة'**
  String get wilaya42;

  /// No description provided for @wilaya43.
  ///
  /// In ar, this message translates to:
  /// **'43 - ميلة'**
  String get wilaya43;

  /// No description provided for @wilaya44.
  ///
  /// In ar, this message translates to:
  /// **'44 - عين الدفلى'**
  String get wilaya44;

  /// No description provided for @wilaya45.
  ///
  /// In ar, this message translates to:
  /// **'45 - النعامة'**
  String get wilaya45;

  /// No description provided for @wilaya46.
  ///
  /// In ar, this message translates to:
  /// **'46 - عين تموشنت'**
  String get wilaya46;

  /// No description provided for @wilaya47.
  ///
  /// In ar, this message translates to:
  /// **'47 - غرداية'**
  String get wilaya47;

  /// No description provided for @wilaya48.
  ///
  /// In ar, this message translates to:
  /// **'48 - غليزان'**
  String get wilaya48;

  /// No description provided for @wilaya49.
  ///
  /// In ar, this message translates to:
  /// **'49 - تميمون'**
  String get wilaya49;

  /// No description provided for @wilaya50.
  ///
  /// In ar, this message translates to:
  /// **'50 - برج باجي مختار'**
  String get wilaya50;

  /// No description provided for @wilaya51.
  ///
  /// In ar, this message translates to:
  /// **'51 - أولاد جلال'**
  String get wilaya51;

  /// No description provided for @wilaya52.
  ///
  /// In ar, this message translates to:
  /// **'52 - بني عباس'**
  String get wilaya52;

  /// No description provided for @wilaya53.
  ///
  /// In ar, this message translates to:
  /// **'53 - عين صالح'**
  String get wilaya53;

  /// No description provided for @wilaya54.
  ///
  /// In ar, this message translates to:
  /// **'54 - عين قزام'**
  String get wilaya54;

  /// No description provided for @wilaya55.
  ///
  /// In ar, this message translates to:
  /// **'55 - تقرت'**
  String get wilaya55;

  /// No description provided for @wilaya56.
  ///
  /// In ar, this message translates to:
  /// **'56 - جانت'**
  String get wilaya56;

  /// No description provided for @wilaya57.
  ///
  /// In ar, this message translates to:
  /// **'57 - المغير'**
  String get wilaya57;

  /// No description provided for @wilaya58.
  ///
  /// In ar, this message translates to:
  /// **'58 - المنيعة'**
  String get wilaya58;

  /// No description provided for @welcome.
  ///
  /// In ar, this message translates to:
  /// **'مرحبًا'**
  String get welcome;

  /// No description provided for @joinOurPlatform.
  ///
  /// In ar, this message translates to:
  /// **'انضم إلى منصتنا وابدأ الآن'**
  String get joinOurPlatform;

  /// No description provided for @confirmPassword.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور'**
  String get confirmPassword;

  /// No description provided for @emailError.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال البريد الإلكتروني'**
  String get emailError;

  /// No description provided for @passwordError.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال كلمة المرور'**
  String get passwordError;

  /// No description provided for @confirmPasswordError.
  ///
  /// In ar, this message translates to:
  /// **'يرجى تأكيد كلمة المرور'**
  String get confirmPasswordError;

  /// No description provided for @invalidEmailError.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني غير صالح'**
  String get invalidEmailError;

  /// No description provided for @invalidPhoneError.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف غير صالح'**
  String get invalidPhoneError;

  /// No description provided for @agricultureConsulting.
  ///
  /// In ar, this message translates to:
  /// **'استشارات الزراعة'**
  String get agricultureConsulting;

  /// No description provided for @organicFarmingConsulting.
  ///
  /// In ar, this message translates to:
  /// **'استشارات في الزراعة العضوية'**
  String get organicFarmingConsulting;

  /// No description provided for @sustainableFarmingConsulting.
  ///
  /// In ar, this message translates to:
  /// **'استشارات في الزراعة المستدامة'**
  String get sustainableFarmingConsulting;

  /// No description provided for @soilAnalysis.
  ///
  /// In ar, this message translates to:
  /// **'تحليل التربة'**
  String get soilAnalysis;

  /// No description provided for @waterAnalysis.
  ///
  /// In ar, this message translates to:
  /// **'تحليل المياه'**
  String get waterAnalysis;

  /// No description provided for @trainingServices.
  ///
  /// In ar, this message translates to:
  /// **'خدمات التوعية والتدريب'**
  String get trainingServices;

  /// No description provided for @modernFarmingTechniques.
  ///
  /// In ar, this message translates to:
  /// **'حول تقنيات الزراعة الحديثة'**
  String get modernFarmingTechniques;

  /// No description provided for @agricultureWorkshops.
  ///
  /// In ar, this message translates to:
  /// **'ورش العمل الزراعية'**
  String get agricultureWorkshops;

  /// No description provided for @agriTech.
  ///
  /// In ar, this message translates to:
  /// **'التكنولوجيا الزراعية'**
  String get agriTech;

  /// No description provided for @agriTechConsulting.
  ///
  /// In ar, this message translates to:
  /// **'استشارات في استخدام التكنولوجيا الزراعية'**
  String get agriTechConsulting;

  /// No description provided for @smartFarmingApps.
  ///
  /// In ar, this message translates to:
  /// **'تطبيقات الزراعة الذكية'**
  String get smartFarmingApps;

  /// No description provided for @farmerGuidance.
  ///
  /// In ar, this message translates to:
  /// **'خدمات توجيهية للمزارعين'**
  String get farmerGuidance;

  /// No description provided for @personalFarmingPlans.
  ///
  /// In ar, this message translates to:
  /// **'خطط الزراعة الخاصة بالمزارع'**
  String get personalFarmingPlans;

  /// No description provided for @cropManagement.
  ///
  /// In ar, this message translates to:
  /// **'إدارة المحاصيل بشكل فعال'**
  String get cropManagement;

  /// No description provided for @plantAnimalHealth.
  ///
  /// In ar, this message translates to:
  /// **'مراقبة صحة النباتات والحيوانات'**
  String get plantAnimalHealth;

  /// No description provided for @diseasePestMonitoring.
  ///
  /// In ar, this message translates to:
  /// **'مراقبة الأمراض والآفات الزراعية'**
  String get diseasePestMonitoring;

  /// No description provided for @cropProtection.
  ///
  /// In ar, this message translates to:
  /// **'الوقاية والتغذية المناسبة للمحاصيل'**
  String get cropProtection;

  /// No description provided for @financeAdminConsulting.
  ///
  /// In ar, this message translates to:
  /// **'الاستشارات المالية والإدارية'**
  String get financeAdminConsulting;

  /// No description provided for @agriFinanceConsulting.
  ///
  /// In ar, this message translates to:
  /// **'استشارات في التمويل الزراعي'**
  String get agriFinanceConsulting;

  /// No description provided for @farmManagementConsulting.
  ///
  /// In ar, this message translates to:
  /// **'استشارات في إدارة المزارع'**
  String get farmManagementConsulting;

  /// No description provided for @agriEquipmentRepair.
  ///
  /// In ar, this message translates to:
  /// **'إصلاح المعدات الزراعية'**
  String get agriEquipmentRepair;

  /// No description provided for @heavyMachineryRepair.
  ///
  /// In ar, this message translates to:
  /// **'إصلاح الآلات الثقيلة'**
  String get heavyMachineryRepair;

  /// No description provided for @irrigationSystemRepair.
  ///
  /// In ar, this message translates to:
  /// **'إصلاح أنظمة الري'**
  String get irrigationSystemRepair;

  /// No description provided for @facilityMaintenance.
  ///
  /// In ar, this message translates to:
  /// **'صيانة المنشآت'**
  String get facilityMaintenance;

  /// No description provided for @electricalEquipmentRepair.
  ///
  /// In ar, this message translates to:
  /// **'إصلاح المعدات الكهربائية'**
  String get electricalEquipmentRepair;

  /// No description provided for @smallTruck.
  ///
  /// In ar, this message translates to:
  /// **'شاحنة صغيرة'**
  String get smallTruck;

  /// No description provided for @largeTruck.
  ///
  /// In ar, this message translates to:
  /// **'شاحنة كبيرة'**
  String get largeTruck;

  /// No description provided for @refrigeratedTruck.
  ///
  /// In ar, this message translates to:
  /// **'شاحنة مبردة'**
  String get refrigeratedTruck;

  /// No description provided for @sell.
  ///
  /// In ar, this message translates to:
  /// **'بيع'**
  String get sell;

  /// No description provided for @kg.
  ///
  /// In ar, this message translates to:
  /// **'كلغ'**
  String get kg;

  /// No description provided for @ton.
  ///
  /// In ar, this message translates to:
  /// **'طن'**
  String get ton;

  /// No description provided for @liter.
  ///
  /// In ar, this message translates to:
  /// **'لتر'**
  String get liter;

  /// No description provided for @box.
  ///
  /// In ar, this message translates to:
  /// **'صندوق'**
  String get box;

  /// No description provided for @squareMeter.
  ///
  /// In ar, this message translates to:
  /// **'م²'**
  String get squareMeter;

  /// No description provided for @hectare.
  ///
  /// In ar, this message translates to:
  /// **'هكتار'**
  String get hectare;

  /// No description provided for @piece.
  ///
  /// In ar, this message translates to:
  /// **'قطعة'**
  String get piece;

  /// No description provided for @set.
  ///
  /// In ar, this message translates to:
  /// **'مجموعة'**
  String get set;

  /// No description provided for @livestockTransport.
  ///
  /// In ar, this message translates to:
  /// **'نقل المواشي'**
  String get livestockTransport;

  /// No description provided for @cropTransport.
  ///
  /// In ar, this message translates to:
  /// **'نقل المحاصيل'**
  String get cropTransport;

  /// No description provided for @generalTransport.
  ///
  /// In ar, this message translates to:
  /// **'نقل عام'**
  String get generalTransport;

  /// No description provided for @pleaseUploadProductImageFirst.
  ///
  /// In ar, this message translates to:
  /// **'📸 الرجاء تحميل صورة المنتج أولًا'**
  String get pleaseUploadProductImageFirst;

  /// No description provided for @success.
  ///
  /// In ar, this message translates to:
  /// **'نجاح'**
  String get success;

  /// No description provided for @addedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تمت الإضافة بنجاح '**
  String get addedSuccessfully;

  /// No description provided for @tapToSelectImages.
  ///
  /// In ar, this message translates to:
  /// **'اضغط لاختيار الصور'**
  String get tapToSelectImages;

  /// No description provided for @category.
  ///
  /// In ar, this message translates to:
  /// **'الصنف'**
  String get category;

  /// No description provided for @subCategory.
  ///
  /// In ar, this message translates to:
  /// **'الصنف الفرعي'**
  String get subCategory;

  /// No description provided for @product.
  ///
  /// In ar, this message translates to:
  /// **'المنتج'**
  String get product;

  /// No description provided for @quantity.
  ///
  /// In ar, this message translates to:
  /// **'الكمية'**
  String get quantity;

  /// No description provided for @pleaseFillField.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء ملء الحقل'**
  String get pleaseFillField;

  /// No description provided for @rentOrSell.
  ///
  /// In ar, this message translates to:
  /// **'إيجار / بيع'**
  String get rentOrSell;

  /// No description provided for @area.
  ///
  /// In ar, this message translates to:
  /// **'المساحة'**
  String get area;

  /// No description provided for @price.
  ///
  /// In ar, this message translates to:
  /// **'السعر'**
  String get price;

  /// No description provided for @unit.
  ///
  /// In ar, this message translates to:
  /// **'الوحدة'**
  String get unit;

  /// No description provided for @wilaya.
  ///
  /// In ar, this message translates to:
  /// **'الولاية'**
  String get wilaya;

  /// No description provided for @daira.
  ///
  /// In ar, this message translates to:
  /// **'الدائرة'**
  String get daira;

  /// No description provided for @description.
  ///
  /// In ar, this message translates to:
  /// **'الوصف'**
  String get description;

  /// No description provided for @reset.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تعيين'**
  String get reset;

  /// No description provided for @formIsEmpty.
  ///
  /// In ar, this message translates to:
  /// **'النموذج فارغ'**
  String get formIsEmpty;

  /// No description provided for @share.
  ///
  /// In ar, this message translates to:
  /// **'انشر'**
  String get share;

  /// No description provided for @userTypeCannotAdd.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكنه إضافة عناصر'**
  String get userTypeCannotAdd;

  /// No description provided for @agriculturalProduct.
  ///
  /// In ar, this message translates to:
  /// **'منتج زراعي'**
  String get agriculturalProduct;

  /// No description provided for @animalProduct.
  ///
  /// In ar, this message translates to:
  /// **'منتج حيواني'**
  String get animalProduct;

  /// No description provided for @commercialProduct.
  ///
  /// In ar, this message translates to:
  /// **'منتج تجاري'**
  String get commercialProduct;

  /// No description provided for @minPrice.
  ///
  /// In ar, this message translates to:
  /// **'السعر الأدنى'**
  String get minPrice;

  /// No description provided for @maxPrice.
  ///
  /// In ar, this message translates to:
  /// **'السعر الأقصى'**
  String get maxPrice;

  /// No description provided for @apply.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق'**
  String get apply;

  /// No description provided for @chooseEquipment.
  ///
  /// In ar, this message translates to:
  /// **'اختر المعدة'**
  String get chooseEquipment;

  /// No description provided for @chooseProduct.
  ///
  /// In ar, this message translates to:
  /// **'اختر المنتوج'**
  String get chooseProduct;

  /// No description provided for @chooseSubCategory.
  ///
  /// In ar, this message translates to:
  /// **'اختر التصنيف الفرعي'**
  String get chooseSubCategory;

  /// No description provided for @chooseCategory.
  ///
  /// In ar, this message translates to:
  /// **'اختر الفئة'**
  String get chooseCategory;

  /// No description provided for @filterProducts.
  ///
  /// In ar, this message translates to:
  /// **'تصفية المنتجات'**
  String get filterProducts;

  /// No description provided for @productType.
  ///
  /// In ar, this message translates to:
  /// **'نوع المنتج'**
  String get productType;

  /// No description provided for @available.
  ///
  /// In ar, this message translates to:
  /// **'متوفر'**
  String get available;

  /// No description provided for @dinar.
  ///
  /// In ar, this message translates to:
  /// **'دج'**
  String get dinar;

  /// No description provided for @forageCutter.
  ///
  /// In ar, this message translates to:
  /// **'آلة قص الأعلاف'**
  String get forageCutter;

  /// No description provided for @grainGrinder.
  ///
  /// In ar, this message translates to:
  /// **'آلة طحن الحبوب'**
  String get grainGrinder;

  /// No description provided for @forageConveyor.
  ///
  /// In ar, this message translates to:
  /// **'ناقلة الأعلاف'**
  String get forageConveyor;

  /// No description provided for @landLeveler.
  ///
  /// In ar, this message translates to:
  /// **'آلة تسوية الأرض'**
  String get landLeveler;

  /// No description provided for @submersiblePumps.
  ///
  /// In ar, this message translates to:
  /// **'مضخات غاطسة'**
  String get submersiblePumps;

  /// No description provided for @dripIrrigationSystems.
  ///
  /// In ar, this message translates to:
  /// **'أنظمة الري بالتنقيط'**
  String get dripIrrigationSystems;

  /// No description provided for @waterFilters.
  ///
  /// In ar, this message translates to:
  /// **'فلاتر مياه'**
  String get waterFilters;

  /// No description provided for @irrigationControllers.
  ///
  /// In ar, this message translates to:
  /// **'أجهزة تحكم في الري'**
  String get irrigationControllers;

  /// No description provided for @controlValves.
  ///
  /// In ar, this message translates to:
  /// **'صمامات تحكم'**
  String get controlValves;

  /// No description provided for @plasticWaterTank.
  ///
  /// In ar, this message translates to:
  /// **'خزان مياه بلاستيكي'**
  String get plasticWaterTank;

  /// No description provided for @storageAndCooling.
  ///
  /// In ar, this message translates to:
  /// **'معدات التخزين والتبريد'**
  String get storageAndCooling;

  /// No description provided for @coldRoom.
  ///
  /// In ar, this message translates to:
  /// **'غرف تبريد'**
  String get coldRoom;

  /// No description provided for @industrialFridge.
  ///
  /// In ar, this message translates to:
  /// **'ثلاجات صناعية'**
  String get industrialFridge;

  /// No description provided for @mobileCoolingUnit.
  ///
  /// In ar, this message translates to:
  /// **'وحدات تبريد متنقلة'**
  String get mobileCoolingUnit;

  /// No description provided for @portableCooler.
  ///
  /// In ar, this message translates to:
  /// **'مبردات محمولة'**
  String get portableCooler;

  /// No description provided for @metalShelves.
  ///
  /// In ar, this message translates to:
  /// **'رفوف تخزين معدنية'**
  String get metalShelves;

  /// No description provided for @cropStorageBoxes.
  ///
  /// In ar, this message translates to:
  /// **'صناديق حفظ المحاصيل'**
  String get cropStorageBoxes;

  /// No description provided for @prefabWarehouse.
  ///
  /// In ar, this message translates to:
  /// **'مستودعات معدنية جاهزة'**
  String get prefabWarehouse;

  /// No description provided for @packagingEquipment.
  ///
  /// In ar, this message translates to:
  /// **'معدات التعبئة والتغليف'**
  String get packagingEquipment;

  /// No description provided for @plasticWrappingMachine.
  ///
  /// In ar, this message translates to:
  /// **'آلة تغليف بلاستيكي'**
  String get plasticWrappingMachine;

  /// No description provided for @labelingMachine.
  ///
  /// In ar, this message translates to:
  /// **'آلة تلصيق الملصقات'**
  String get labelingMachine;

  /// No description provided for @digitalScales.
  ///
  /// In ar, this message translates to:
  /// **'موازين رقمية'**
  String get digitalScales;

  /// No description provided for @cropBags.
  ///
  /// In ar, this message translates to:
  /// **'أكياس تعبئة محاصيل'**
  String get cropBags;

  /// No description provided for @cardboardBoxes.
  ///
  /// In ar, this message translates to:
  /// **'صناديق كرتونية'**
  String get cardboardBoxes;

  /// No description provided for @packingSterilizer.
  ///
  /// In ar, this message translates to:
  /// **'آلة تعقيم التعبئة'**
  String get packingSterilizer;

  /// No description provided for @electronicScale.
  ///
  /// In ar, this message translates to:
  /// **'ميزان إلكتروني'**
  String get electronicScale;

  /// No description provided for @our_trusted_veterinarians.
  ///
  /// In ar, this message translates to:
  /// **'أطبائنا البيطريين الموثوقين'**
  String get our_trusted_veterinarians;

  /// No description provided for @type_label.
  ///
  /// In ar, this message translates to:
  /// **'النوع'**
  String get type_label;

  /// No description provided for @transport_means_label.
  ///
  /// In ar, this message translates to:
  /// **'وسيلة النقل'**
  String get transport_means_label;

  /// No description provided for @reportWrongInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات خاطئة'**
  String get reportWrongInfo;

  /// No description provided for @reportSpam.
  ///
  /// In ar, this message translates to:
  /// **'بريد عشوائي أو احتيال'**
  String get reportSpam;

  /// No description provided for @reportOther.
  ///
  /// In ar, this message translates to:
  /// **'أخرى'**
  String get reportOther;

  /// No description provided for @reportConfirmation.
  ///
  /// In ar, this message translates to:
  /// **'لقد تلقينا إشارتك — شكرًا لدعمك مجتمعنا! 🤝'**
  String get reportConfirmation;

  /// No description provided for @unspecified.
  ///
  /// In ar, this message translates to:
  /// **'غير محددة'**
  String get unspecified;

  /// No description provided for @details.
  ///
  /// In ar, this message translates to:
  /// **'التفاصيل'**
  String get details;

  /// No description provided for @readMore.
  ///
  /// In ar, this message translates to:
  /// **'اقرأ المزيد'**
  String get readMore;

  /// No description provided for @readLess.
  ///
  /// In ar, this message translates to:
  /// **'اقرأ أقل'**
  String get readLess;

  /// No description provided for @loginToLike.
  ///
  /// In ar, this message translates to:
  /// **'يرجى تسجيل الدخول للإعجاب أو عدم الإعجاب بالعناصر'**
  String get loginToLike;

  /// No description provided for @loginToMessage.
  ///
  /// In ar, this message translates to:
  /// **'تحتاج إلى تسجيل الدخول لإرسال رسالة'**
  String get loginToMessage;

  /// No description provided for @chat.
  ///
  /// In ar, this message translates to:
  /// **'دردشة'**
  String get chat;

  /// No description provided for @cannotOpenDialer.
  ///
  /// In ar, this message translates to:
  /// **'تعذر فتح تطبيق الاتصال'**
  String get cannotOpenDialer;

  /// No description provided for @noPhoneNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف غير متوفر'**
  String get noPhoneNumber;

  /// No description provided for @call.
  ///
  /// In ar, this message translates to:
  /// **'اتصال'**
  String get call;

  /// No description provided for @unknown.
  ///
  /// In ar, this message translates to:
  /// **'غير معروف'**
  String get unknown;

  /// No description provided for @productLabel.
  ///
  /// In ar, this message translates to:
  /// **'المنتج :'**
  String get productLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In ar, this message translates to:
  /// **'الفئة :'**
  String get categoryLabel;

  /// No description provided for @subCategoryLabel.
  ///
  /// In ar, this message translates to:
  /// **'الفئة الفرعية :'**
  String get subCategoryLabel;

  /// No description provided for @locationLabel.
  ///
  /// In ar, this message translates to:
  /// **'الموقع :'**
  String get locationLabel;

  /// No description provided for @writeComment.
  ///
  /// In ar, this message translates to:
  /// **'اكتب تعليقًا...'**
  String get writeComment;

  /// No description provided for @errorAddingComment.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء إضافة التعليق. حاول مرة أخرى لاحقًا'**
  String get errorAddingComment;

  /// No description provided for @guest.
  ///
  /// In ar, this message translates to:
  /// **'زائر'**
  String get guest;

  /// No description provided for @comments.
  ///
  /// In ar, this message translates to:
  /// **'التعليقات'**
  String get comments;

  /// No description provided for @noCommentsYet.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تعليقات بعد'**
  String get noCommentsYet;

  /// No description provided for @chooseAnimalProduct.
  ///
  /// In ar, this message translates to:
  /// **'اختر منتجًا حيوانيًا'**
  String get chooseAnimalProduct;

  /// No description provided for @head.
  ///
  /// In ar, this message translates to:
  /// **'رأس'**
  String get head;

  /// No description provided for @pack.
  ///
  /// In ar, this message translates to:
  /// **'علبة'**
  String get pack;

  /// No description provided for @loginToCall.
  ///
  /// In ar, this message translates to:
  /// **'يجب عليك تسجيل الدخول لإجراء المكالمة'**
  String get loginToCall;

  /// No description provided for @nav_home.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get nav_home;

  /// No description provided for @nav_services.
  ///
  /// In ar, this message translates to:
  /// **'الخدمات'**
  String get nav_services;

  /// No description provided for @nav_add.
  ///
  /// In ar, this message translates to:
  /// **'إضافة'**
  String get nav_add;

  /// No description provided for @nav_messages.
  ///
  /// In ar, this message translates to:
  /// **'الرسائل'**
  String get nav_messages;

  /// No description provided for @nav_profile.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get nav_profile;

  /// No description provided for @done.
  ///
  /// In ar, this message translates to:
  /// **'تم'**
  String get done;

  /// No description provided for @add_profile_picture_subtitle.
  ///
  /// In ar, this message translates to:
  /// **'أضف صورة للملف الشخصي حتى يتمكن أصدقاؤك من التعرف عليك'**
  String get add_profile_picture_subtitle;

  /// No description provided for @profile_picture.
  ///
  /// In ar, this message translates to:
  /// **'صورة الملف الشخصي'**
  String get profile_picture;

  /// No description provided for @skip.
  ///
  /// In ar, this message translates to:
  /// **'تخطي'**
  String get skip;

  /// No description provided for @profile_picture_updated_successfully.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث صورة الملف الشخصي بنجاح'**
  String get profile_picture_updated_successfully;

  /// No description provided for @landSuitableForAgriculture.
  ///
  /// In ar, this message translates to:
  /// **'أرض صالحة للزراعة'**
  String get landSuitableForAgriculture;

  /// No description provided for @plant_apple.
  ///
  /// In ar, this message translates to:
  /// **'تفاح'**
  String get plant_apple;

  /// No description provided for @plant_cherry.
  ///
  /// In ar, this message translates to:
  /// **'كرز'**
  String get plant_cherry;

  /// No description provided for @plant_corn.
  ///
  /// In ar, this message translates to:
  /// **'ذرة'**
  String get plant_corn;

  /// No description provided for @plant_grape.
  ///
  /// In ar, this message translates to:
  /// **'عنب'**
  String get plant_grape;

  /// No description provided for @plant_peach.
  ///
  /// In ar, this message translates to:
  /// **'خوخ'**
  String get plant_peach;

  /// No description provided for @plant_potato.
  ///
  /// In ar, this message translates to:
  /// **'بطاطا'**
  String get plant_potato;

  /// No description provided for @plant_strawberry.
  ///
  /// In ar, this message translates to:
  /// **'فراولة'**
  String get plant_strawberry;

  /// No description provided for @plant_tomato.
  ///
  /// In ar, this message translates to:
  /// **'طماطم'**
  String get plant_tomato;

  /// No description provided for @appleAppleScabLabel.
  ///
  /// In ar, this message translates to:
  /// **'جرب التفاح'**
  String get appleAppleScabLabel;

  /// No description provided for @appleAppleScabSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'قم بإزالة الأوراق المتساقطة وتخلص منها.'**
  String get appleAppleScabSuggestion1;

  /// No description provided for @appleAppleScabSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'استخدم مبيدات الفطريات في وقت مبكر من الموسم.'**
  String get appleAppleScabSuggestion2;

  /// No description provided for @appleAppleScabSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'تأكد من وجود تهوية جيدة.'**
  String get appleAppleScabSuggestion3;

  /// No description provided for @appleBlackRotLabel.
  ///
  /// In ar, this message translates to:
  /// **'تعفن التفاح الأسود'**
  String get appleBlackRotLabel;

  /// No description provided for @appleBlackRotSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'قم بتقليم الفروع المصابة.'**
  String get appleBlackRotSuggestion1;

  /// No description provided for @appleBlackRotSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'تخلص من الثمار المتحللة أو الجافة.'**
  String get appleBlackRotSuggestion2;

  /// No description provided for @appleBlackRotSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'استخدم مبيدات الفطريات أثناء موسم النمو.'**
  String get appleBlackRotSuggestion3;

  /// No description provided for @appleCedarAppleRustLabel.
  ///
  /// In ar, this message translates to:
  /// **'صدأ التفاح والعرعر'**
  String get appleCedarAppleRustLabel;

  /// No description provided for @appleCedarAppleRustSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'قم بإزالة أشجار العرعر القريبة إن أمكن.'**
  String get appleCedarAppleRustSuggestion1;

  /// No description provided for @appleCedarAppleRustSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'استخدم مبيدات الفطريات بانتظام.'**
  String get appleCedarAppleRustSuggestion2;

  /// No description provided for @appleCedarAppleRustSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'ازرع أنواعاً مقاومة للمرض.'**
  String get appleCedarAppleRustSuggestion3;

  /// No description provided for @appleHealthyLabel.
  ///
  /// In ar, this message translates to:
  /// **'تفاح سليم'**
  String get appleHealthyLabel;

  /// No description provided for @appleHealthySuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'تأكد من الري والتسميد المناسب.'**
  String get appleHealthySuggestion1;

  /// No description provided for @appleHealthySuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'قم بالتقليم المنتظم لتحسين التهوية.'**
  String get appleHealthySuggestion2;

  /// No description provided for @appleHealthySuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'راقب الآفات والأمراض باستمرار.'**
  String get appleHealthySuggestion3;

  /// No description provided for @cherryPowderyMildewLabel.
  ///
  /// In ar, this message translates to:
  /// **'البياض الدقيقي في الكرز'**
  String get cherryPowderyMildewLabel;

  /// No description provided for @cherryPowderyMildewSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'قم بإزالة الأوراق المصابة.'**
  String get cherryPowderyMildewSuggestion1;

  /// No description provided for @cherryPowderyMildewSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'استخدم مبيدات فطرية تحتوي على الكبريت.'**
  String get cherryPowderyMildewSuggestion2;

  /// No description provided for @cherryPowderyMildewSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'تأكد من وجود تهوية جيدة.'**
  String get cherryPowderyMildewSuggestion3;

  /// No description provided for @cherryHealthyLabel.
  ///
  /// In ar, this message translates to:
  /// **'كرز سليم'**
  String get cherryHealthyLabel;

  /// No description provided for @cherryHealthySuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'قم بري النبات بشكل كافٍ وسمّده بشكل مناسب.'**
  String get cherryHealthySuggestion1;

  /// No description provided for @cherryHealthySuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'قُم بالتقليم لتحسين التهوية.'**
  String get cherryHealthySuggestion2;

  /// No description provided for @cherryHealthySuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'افحص النبات بانتظام لاكتشاف الآفات.'**
  String get cherryHealthySuggestion3;

  /// No description provided for @cornCercosporaLeafSpotLabel.
  ///
  /// In ar, this message translates to:
  /// **'بقعة أوراق السركوسبورا في الذرة (البقعة الرمادية)'**
  String get cornCercosporaLeafSpotLabel;

  /// No description provided for @cornCercosporaLeafSpotSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'قم بإزالة بقايا المحصول بعد الحصاد.'**
  String get cornCercosporaLeafSpotSuggestion1;

  /// No description provided for @cornCercosporaLeafSpotSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'استخدم مبيدات الفطريات عند الضرورة.'**
  String get cornCercosporaLeafSpotSuggestion2;

  /// No description provided for @cornCercosporaLeafSpotSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'ازرع هجنًا مقاومة.'**
  String get cornCercosporaLeafSpotSuggestion3;

  /// No description provided for @cornCommonRustLabel.
  ///
  /// In ar, this message translates to:
  /// **'الصدأ الشائع في الذرة'**
  String get cornCommonRustLabel;

  /// No description provided for @cornCommonRustSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'ازرع أصنافًا مقاومة.'**
  String get cornCommonRustSuggestion1;

  /// No description provided for @cornCommonRustSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'استخدم مبيدات الفطريات في بداية الموسم.'**
  String get cornCommonRustSuggestion2;

  /// No description provided for @cornCommonRustSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'قم بإزالة بقايا النباتات المصابة.'**
  String get cornCommonRustSuggestion3;

  /// No description provided for @cornNorthernLeafBlightLabel.
  ///
  /// In ar, this message translates to:
  /// **'لفحة الأوراق الشمالية في الذرة'**
  String get cornNorthernLeafBlightLabel;

  /// No description provided for @cornNorthernLeafBlightSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'استخدم هجنًا مقاومة.'**
  String get cornNorthernLeafBlightSuggestion1;

  /// No description provided for @cornNorthernLeafBlightSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'قم بتدوير المحاصيل.'**
  String get cornNorthernLeafBlightSuggestion2;

  /// No description provided for @cornNorthernLeafBlightSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'استخدم مبيدات الفطريات عند الضرورة.'**
  String get cornNorthernLeafBlightSuggestion3;

  /// No description provided for @cornHealthyLabel.
  ///
  /// In ar, this message translates to:
  /// **'ذرة سليمة'**
  String get cornHealthyLabel;

  /// No description provided for @cornHealthySuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'تأكد من الري والتسميد الجيد.'**
  String get cornHealthySuggestion1;

  /// No description provided for @cornHealthySuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'قم بتدوير المحاصيل.'**
  String get cornHealthySuggestion2;

  /// No description provided for @cornHealthySuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'راقب الآفات بانتظام.'**
  String get cornHealthySuggestion3;

  /// No description provided for @grapeBlackRotLabel.
  ///
  /// In ar, this message translates to:
  /// **'تعفن العنب الأسود'**
  String get grapeBlackRotLabel;

  /// No description provided for @grapeBlackRotSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'قم بإزالة الثمار المجففة والفسائل المصابة.'**
  String get grapeBlackRotSuggestion1;

  /// No description provided for @grapeBlackRotSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'استخدم مبيدات فطرية عند بداية التزهير وقبل إغلاق العناقيد.'**
  String get grapeBlackRotSuggestion2;

  /// No description provided for @grapeBlackRotSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'وفر تهوية جيدة من خلال التقليم.'**
  String get grapeBlackRotSuggestion3;

  /// No description provided for @grapeEscaLabel.
  ///
  /// In ar, this message translates to:
  /// **'إسكا العنب (الحصبة السوداء)'**
  String get grapeEscaLabel;

  /// No description provided for @grapeEscaSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'قم بإزالة وتدمير الكروم المصابة.'**
  String get grapeEscaSuggestion1;

  /// No description provided for @grapeEscaSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'تجنب جرح الكروم أثناء التقليم.'**
  String get grapeEscaSuggestion2;

  /// No description provided for @grapeEscaSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'استخدم المعالجات الفطرية إذا كانت موصى بها.'**
  String get grapeEscaSuggestion3;

  /// No description provided for @grapeLeafBlightLabel.
  ///
  /// In ar, this message translates to:
  /// **'لفحة أوراق العنب (بقعة إيساريوبيسيس)'**
  String get grapeLeafBlightLabel;

  /// No description provided for @grapeLeafBlightSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'أزل الأوراق والحطام المصابة.'**
  String get grapeLeafBlightSuggestion1;

  /// No description provided for @grapeLeafBlightSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'استخدم مبيدات الفطريات بانتظام خلال موسم النمو.'**
  String get grapeLeafBlightSuggestion2;

  /// No description provided for @grapeLeafBlightSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'شجع على التهوية الجيدة.'**
  String get grapeLeafBlightSuggestion3;

  /// No description provided for @grapeHealthyLabel.
  ///
  /// In ar, this message translates to:
  /// **'عنب سليم'**
  String get grapeHealthyLabel;

  /// No description provided for @grapeHealthySuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'حافظ على ري وتسميد مناسب.'**
  String get grapeHealthySuggestion1;

  /// No description provided for @grapeHealthySuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'قُم بالتقليم المنتظم لتحسين التهوية.'**
  String get grapeHealthySuggestion2;

  /// No description provided for @grapeHealthySuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'افحص بشكل متكرر بحثًا عن الأمراض والآفات.'**
  String get grapeHealthySuggestion3;

  /// No description provided for @peachBacterialSpotLabel.
  ///
  /// In ar, this message translates to:
  /// **'البقعة البكتيرية في الخوخ'**
  String get peachBacterialSpotLabel;

  /// No description provided for @peachBacterialSpotSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'استخدم مبيدات بكتيرية تعتمد على النحاس.'**
  String get peachBacterialSpotSuggestion1;

  /// No description provided for @peachBacterialSpotSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'قم بإزالة المواد النباتية المصابة وتدميرها.'**
  String get peachBacterialSpotSuggestion2;

  /// No description provided for @peachBacterialSpotSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'تجنب الري العلوي.'**
  String get peachBacterialSpotSuggestion3;

  /// No description provided for @peachHealthyLabel.
  ///
  /// In ar, this message translates to:
  /// **'خوخ سليم'**
  String get peachHealthyLabel;

  /// No description provided for @peachHealthySuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'وفر الري والتسميد الكافي.'**
  String get peachHealthySuggestion1;

  /// No description provided for @peachHealthySuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'قُم بتقليم الأشجار لضمان تهوية جيدة.'**
  String get peachHealthySuggestion2;

  /// No description provided for @peachHealthySuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'راقب الآفات بانتظام.'**
  String get peachHealthySuggestion3;

  /// No description provided for @potatoEarlyBlightLabel.
  ///
  /// In ar, this message translates to:
  /// **'اللفحة المبكرة في البطاطا'**
  String get potatoEarlyBlightLabel;

  /// No description provided for @potatoEarlyBlightSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'قم بتدوير المحاصيل إلى نباتات غير عائلة.'**
  String get potatoEarlyBlightSuggestion1;

  /// No description provided for @potatoEarlyBlightSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'قم بإزالة وتدمير الأوراق المصابة.'**
  String get potatoEarlyBlightSuggestion2;

  /// No description provided for @potatoEarlyBlightSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'استخدم مبيدات الفطريات بشكل وقائي.'**
  String get potatoEarlyBlightSuggestion3;

  /// No description provided for @potatoLateBlightLabel.
  ///
  /// In ar, this message translates to:
  /// **'اللفحة المتأخرة في البطاطا'**
  String get potatoLateBlightLabel;

  /// No description provided for @potatoLateBlightSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'أزل النباتات المصابة فورًا وتخلص منها.'**
  String get potatoLateBlightSuggestion1;

  /// No description provided for @potatoLateBlightSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'استخدم مبيدات الفطريات بانتظام خلال الطقس الرطب.'**
  String get potatoLateBlightSuggestion2;

  /// No description provided for @potatoLateBlightSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'استخدم أصنافًا مقاومة.'**
  String get potatoLateBlightSuggestion3;

  /// No description provided for @potatoHealthyLabel.
  ///
  /// In ar, this message translates to:
  /// **'بطاطا سليمة'**
  String get potatoHealthyLabel;

  /// No description provided for @potatoHealthySuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'وفر ريًا وتغذية مناسبة.'**
  String get potatoHealthySuggestion1;

  /// No description provided for @potatoHealthySuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'قم بتطبيق تدوير المحاصيل.'**
  String get potatoHealthySuggestion2;

  /// No description provided for @potatoHealthySuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'افحص بانتظام الآفات والأمراض.'**
  String get potatoHealthySuggestion3;

  /// No description provided for @strawberryLeafScorchLabel.
  ///
  /// In ar, this message translates to:
  /// **'احتراق أوراق الفراولة'**
  String get strawberryLeafScorchLabel;

  /// No description provided for @strawberryLeafScorchSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'قم بإزالة وتدمير الأوراق المصابة.'**
  String get strawberryLeafScorchSuggestion1;

  /// No description provided for @strawberryLeafScorchSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'استخدم مبيدات الفطريات في المراحل المبكرة للمرض.'**
  String get strawberryLeafScorchSuggestion2;

  /// No description provided for @strawberryLeafScorchSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'تجنب الري العلوي لتقليل الرطوبة.'**
  String get strawberryLeafScorchSuggestion3;

  /// No description provided for @strawberryHealthyLabel.
  ///
  /// In ar, this message translates to:
  /// **'فراولة سليمة'**
  String get strawberryHealthyLabel;

  /// No description provided for @strawberryHealthySuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'حافظ على توازن الري والتسميد.'**
  String get strawberryHealthySuggestion1;

  /// No description provided for @strawberryHealthySuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'قم بإزالة الأعشاب الضارة والحطام بانتظام.'**
  String get strawberryHealthySuggestion2;

  /// No description provided for @strawberryHealthySuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'افحص النباتات بشكل متكرر لاكتشاف الآفات والأمراض.'**
  String get strawberryHealthySuggestion3;

  /// No description provided for @tomatoBacterialSpotLabel.
  ///
  /// In ar, this message translates to:
  /// **'البقعة البكتيرية في الطماطم'**
  String get tomatoBacterialSpotLabel;

  /// No description provided for @tomatoBacterialSpotSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'استخدم مبيدات بكتيرية تعتمد على النحاس.'**
  String get tomatoBacterialSpotSuggestion1;

  /// No description provided for @tomatoBacterialSpotSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'قم بإزالة وتدمير النباتات المصابة.'**
  String get tomatoBacterialSpotSuggestion2;

  /// No description provided for @tomatoBacterialSpotSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'تجنب التعامل مع النباتات المبللة لتفادي انتشار المرض.'**
  String get tomatoBacterialSpotSuggestion3;

  /// No description provided for @tomatoEarlyBlightLabel.
  ///
  /// In ar, this message translates to:
  /// **'اللفحة المبكرة في الطماطم'**
  String get tomatoEarlyBlightLabel;

  /// No description provided for @tomatoEarlyBlightSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'قم بتدوير المحاصيل لتقليل تراكم الأمراض.'**
  String get tomatoEarlyBlightSuggestion1;

  /// No description provided for @tomatoEarlyBlightSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'أزل الأوراق المصابة فورًا.'**
  String get tomatoEarlyBlightSuggestion2;

  /// No description provided for @tomatoEarlyBlightSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'استخدم مبيدات الفطريات بشكل وقائي.'**
  String get tomatoEarlyBlightSuggestion3;

  /// No description provided for @tomatoLateBlightLabel.
  ///
  /// In ar, this message translates to:
  /// **'اللفحة المتأخرة في الطماطم'**
  String get tomatoLateBlightLabel;

  /// No description provided for @tomatoLateBlightSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'قم بإزالة وتدمير النباتات المصابة.'**
  String get tomatoLateBlightSuggestion1;

  /// No description provided for @tomatoLateBlightSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'استخدم مبيدات الفطريات بانتظام، خصوصًا في الظروف الرطبة.'**
  String get tomatoLateBlightSuggestion2;

  /// No description provided for @tomatoLateBlightSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'استخدم أصناف طماطم مقاومة.'**
  String get tomatoLateBlightSuggestion3;

  /// No description provided for @tomatoLeafMoldLabel.
  ///
  /// In ar, this message translates to:
  /// **'عفن أوراق الطماطم'**
  String get tomatoLeafMoldLabel;

  /// No description provided for @tomatoLeafMoldSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'وفر تهوية جيدة للنباتات.'**
  String get tomatoLeafMoldSuggestion1;

  /// No description provided for @tomatoLeafMoldSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'تجنب الري العلوي.'**
  String get tomatoLeafMoldSuggestion2;

  /// No description provided for @tomatoLeafMoldSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'استخدم المبيدات المناسبة عند الحاجة.'**
  String get tomatoLeafMoldSuggestion3;

  /// No description provided for @tomatoSeptoriaLeafSpotLabel.
  ///
  /// In ar, this message translates to:
  /// **'بقعة أوراق السبتوريا في الطماطم'**
  String get tomatoSeptoriaLeafSpotLabel;

  /// No description provided for @tomatoSeptoriaLeafSpotSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'قم بإزالة وتدمير الأوراق المصابة.'**
  String get tomatoSeptoriaLeafSpotSuggestion1;

  /// No description provided for @tomatoSeptoriaLeafSpotSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'مارس تدوير المحاصيل.'**
  String get tomatoSeptoriaLeafSpotSuggestion2;

  /// No description provided for @tomatoSeptoriaLeafSpotSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'استخدم مبيدات الفطريات بشكل وقائي.'**
  String get tomatoSeptoriaLeafSpotSuggestion3;

  /// No description provided for @tomatoSpiderMitesLabel.
  ///
  /// In ar, this message translates to:
  /// **'العنكبوت الأحمر (ذو البقعتين) في الطماطم'**
  String get tomatoSpiderMitesLabel;

  /// No description provided for @tomatoSpiderMitesSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'استخدم مبيدات العناكب أو الصابون الحشري.'**
  String get tomatoSpiderMitesSuggestion1;

  /// No description provided for @tomatoSpiderMitesSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'شجع على وجود الأعداء الحيوية مثل الدعسوقة.'**
  String get tomatoSpiderMitesSuggestion2;

  /// No description provided for @tomatoSpiderMitesSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'حافظ على ري كافٍ لتقليل التوتر النباتي.'**
  String get tomatoSpiderMitesSuggestion3;

  /// No description provided for @tomatoTargetSpotLabel.
  ///
  /// In ar, this message translates to:
  /// **'بقعة الهدف في الطماطم'**
  String get tomatoTargetSpotLabel;

  /// No description provided for @tomatoTargetSpotSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'قم بإزالة الأوراق والحطام المصاب.'**
  String get tomatoTargetSpotSuggestion1;

  /// No description provided for @tomatoTargetSpotSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'استخدم مبيدات الفطريات في المراحل المبكرة.'**
  String get tomatoTargetSpotSuggestion2;

  /// No description provided for @tomatoTargetSpotSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'قم بتدوير المحاصيل.'**
  String get tomatoTargetSpotSuggestion3;

  /// No description provided for @tomatoYellowLeafCurlVirusLabel.
  ///
  /// In ar, this message translates to:
  /// **'فيروس تجعد أوراق الطماطم الأصفر'**
  String get tomatoYellowLeafCurlVirusLabel;

  /// No description provided for @tomatoYellowLeafCurlVirusSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'استخدم أصناف طماطم مقاومة.'**
  String get tomatoYellowLeafCurlVirusSuggestion1;

  /// No description provided for @tomatoYellowLeafCurlVirusSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'تحكم في أعداد الذباب الأبيض.'**
  String get tomatoYellowLeafCurlVirusSuggestion2;

  /// No description provided for @tomatoYellowLeafCurlVirusSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'قم بإزالة النباتات المصابة بسرعة.'**
  String get tomatoYellowLeafCurlVirusSuggestion3;

  /// No description provided for @tomatoMosaicVirusLabel.
  ///
  /// In ar, this message translates to:
  /// **'فيروس موزاييك الطماطم'**
  String get tomatoMosaicVirusLabel;

  /// No description provided for @tomatoMosaicVirusSuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'استخدم بذور وشتلات خالية من الفيروسات.'**
  String get tomatoMosaicVirusSuggestion1;

  /// No description provided for @tomatoMosaicVirusSuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'قم بإزالة وتدمير النباتات المصابة.'**
  String get tomatoMosaicVirusSuggestion2;

  /// No description provided for @tomatoMosaicVirusSuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'عقّم الأدوات لتفادي الانتشار.'**
  String get tomatoMosaicVirusSuggestion3;

  /// No description provided for @tomatoHealthyLabel.
  ///
  /// In ar, this message translates to:
  /// **'طماطم سليمة'**
  String get tomatoHealthyLabel;

  /// No description provided for @tomatoHealthySuggestion1.
  ///
  /// In ar, this message translates to:
  /// **'حافظ على توازن الري والتسميد.'**
  String get tomatoHealthySuggestion1;

  /// No description provided for @tomatoHealthySuggestion2.
  ///
  /// In ar, this message translates to:
  /// **'وفر تهوية جيدة حول النباتات.'**
  String get tomatoHealthySuggestion2;

  /// No description provided for @tomatoHealthySuggestion3.
  ///
  /// In ar, this message translates to:
  /// **'افحص النباتات بانتظام لاكتشاف الآفات والأمراض.'**
  String get tomatoHealthySuggestion3;

  /// No description provided for @lowConfidenceDetection.
  ///
  /// In ar, this message translates to:
  /// **'تعذر اكتشاف المرض بدقة كافية. جرب صورة أخرى.'**
  String get lowConfidenceDetection;

  /// No description provided for @imageAnalysisError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء تحليل الصورة'**
  String get imageAnalysisError;

  /// No description provided for @supported.
  ///
  /// In ar, this message translates to:
  /// **'مدعوم :'**
  String get supported;

  /// No description provided for @tapToAddImage.
  ///
  /// In ar, this message translates to:
  /// **'اضغط لإضافة صورة ورقة'**
  String get tapToAddImage;

  /// No description provided for @selectImageSource.
  ///
  /// In ar, this message translates to:
  /// **'اختر من المعرض أو التقط صورة'**
  String get selectImageSource;

  /// No description provided for @analyzingImage.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ تحليل صورة النبات...'**
  String get analyzingImage;

  /// No description provided for @pleaseWait.
  ///
  /// In ar, this message translates to:
  /// **'قد يستغرق ذلك بضع ثوانٍ'**
  String get pleaseWait;

  /// No description provided for @detectionResult.
  ///
  /// In ar, this message translates to:
  /// **'نتيجة الكشف'**
  String get detectionResult;

  /// No description provided for @confidence.
  ///
  /// In ar, this message translates to:
  /// **'نسبة الثقة'**
  String get confidence;

  /// No description provided for @treatmentRecommendations.
  ///
  /// In ar, this message translates to:
  /// **'توصيات العلاج'**
  String get treatmentRecommendations;

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'تحليل ذكي لصحة النباتات'**
  String get appTitle;

  /// No description provided for @uploadInstruction.
  ///
  /// In ar, this message translates to:
  /// **'قم بتحميل صورة واضحة لورقة نبات للكشف عن الأمراض'**
  String get uploadInstruction;

  /// No description provided for @tapToAddImages.
  ///
  /// In ar, this message translates to:
  /// **'اضغط لإضافة الصور'**
  String get tapToAddImages;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
