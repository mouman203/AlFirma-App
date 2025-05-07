// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `الإعدادات`
  String get settings {
    return Intl.message('الإعدادات', name: 'settings', desc: '', args: []);
  }

  /// `الأمان`
  String get security {
    return Intl.message('الأمان', name: 'security', desc: '', args: []);
  }

  /// `يجب أن تكون مسجلاً للدخول للوصول إلى إعدادات الأمان`
  String get securityMessage {
    return Intl.message(
      'يجب أن تكون مسجلاً للدخول للوصول إلى إعدادات الأمان',
      name: 'securityMessage',
      desc: '',
      args: [],
    );
  }

  /// `الوضع الفاتح`
  String get lightMode {
    return Intl.message('الوضع الفاتح', name: 'lightMode', desc: '', args: []);
  }

  /// `الوضع الداكن`
  String get darkMode {
    return Intl.message('الوضع الداكن', name: 'darkMode', desc: '', args: []);
  }

  /// `اللغة`
  String get language {
    return Intl.message('اللغة', name: 'language', desc: '', args: []);
  }

  /// `الإشعارات`
  String get notifications {
    return Intl.message('الإشعارات', name: 'notifications', desc: '', args: []);
  }

  /// `اتصل بنا`
  String get contactUs {
    return Intl.message('اتصل بنا', name: 'contactUs', desc: '', args: []);
  }

  /// `يرجى تسجيل الدخول للتواصل مع الدعم`
  String get loginToContactSupport {
    return Intl.message(
      'يرجى تسجيل الدخول للتواصل مع الدعم',
      name: 'loginToContactSupport',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل الخروج`
  String get logout {
    return Intl.message('تسجيل الخروج', name: 'logout', desc: '', args: []);
  }

  /// `  ! تحذير   `
  String get alertWarning {
    return Intl.message(
      '  ! تحذير   ',
      name: 'alertWarning',
      desc: '',
      args: [],
    );
  }

  /// `هل أنت متأكد أنك تريد تسجيل الخروج؟`
  String get confirmLogout {
    return Intl.message(
      'هل أنت متأكد أنك تريد تسجيل الخروج؟',
      name: 'confirmLogout',
      desc: '',
      args: [],
    );
  }

  /// `لا`
  String get no {
    return Intl.message('لا', name: 'no', desc: '', args: []);
  }

  /// `نعم`
  String get yes {
    return Intl.message('نعم', name: 'yes', desc: '', args: []);
  }

  /// `المتابِعون`
  String get followers {
    return Intl.message('المتابِعون', name: 'followers', desc: '', args: []);
  }

  /// `المتابَعون`
  String get following {
    return Intl.message('المتابَعون', name: 'following', desc: '', args: []);
  }

  /// `متابعة`
  String get follow {
    return Intl.message('متابعة', name: 'follow', desc: '', args: []);
  }

  /// `إلغاء المتابعة`
  String get unfollow {
    return Intl.message('إلغاء المتابعة', name: 'unfollow', desc: '', args: []);
  }

  /// `لا توجد عناصر بعد`
  String get noItemsYet {
    return Intl.message(
      'لا توجد عناصر بعد',
      name: 'noItemsYet',
      desc: '',
      args: [],
    );
  }

  /// `لا توجد عناصر محفوظة حتى الآن`
  String get noSavedItems {
    return Intl.message(
      'لا توجد عناصر محفوظة حتى الآن',
      name: 'noSavedItems',
      desc: '',
      args: [],
    );
  }

  /// `تعديل الملف الشخصي`
  String get edit_profile {
    return Intl.message(
      'تعديل الملف الشخصي',
      name: 'edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `📸 اختر صورة`
  String get choose_picture {
    return Intl.message(
      '📸 اختر صورة',
      name: 'choose_picture',
      desc: '',
      args: [],
    );
  }

  /// `اختيار من المعرض`
  String get select_from_gallery {
    return Intl.message(
      'اختيار من المعرض',
      name: 'select_from_gallery',
      desc: '',
      args: [],
    );
  }

  /// `التقاط باستخدام الكاميرا`
  String get capture_with_camera {
    return Intl.message(
      'التقاط باستخدام الكاميرا',
      name: 'capture_with_camera',
      desc: '',
      args: [],
    );
  }

  /// `لا توجد تغييرات`
  String get no_changes_detected {
    return Intl.message(
      'لا توجد تغييرات',
      name: 'no_changes_detected',
      desc: '',
      args: [],
    );
  }

  /// `تم تحديث الملف الشخصي بنجاح`
  String get profile_updated {
    return Intl.message(
      'تم تحديث الملف الشخصي بنجاح',
      name: 'profile_updated',
      desc: '',
      args: [],
    );
  }

  /// ` ❌ خطأ`
  String get error {
    return Intl.message(' ❌ خطأ', name: 'error', desc: '', args: []);
  }

  /// `الاسم`
  String get firstName {
    return Intl.message('الاسم', name: 'firstName', desc: '', args: []);
  }

  /// `اللقب`
  String get lastName {
    return Intl.message('اللقب', name: 'lastName', desc: '', args: []);
  }

  /// `رقم الهاتف`
  String get phoneNumber {
    return Intl.message('رقم الهاتف', name: 'phoneNumber', desc: '', args: []);
  }

  /// `يرجى اختيار الولاية`
  String get selectWilaya {
    return Intl.message(
      'يرجى اختيار الولاية',
      name: 'selectWilaya',
      desc: '',
      args: [],
    );
  }

  /// `اختر الدائرة`
  String get selectDaira {
    return Intl.message(
      'اختر الدائرة',
      name: 'selectDaira',
      desc: '',
      args: [],
    );
  }

  /// `إرسال`
  String get submit {
    return Intl.message('إرسال', name: 'submit', desc: '', args: []);
  }

  /// `يرجى إدخال الاسم`
  String get firstNameError {
    return Intl.message(
      'يرجى إدخال الاسم',
      name: 'firstNameError',
      desc: '',
      args: [],
    );
  }

  /// `يرجى إدخال اللقب`
  String get lastNameError {
    return Intl.message(
      'يرجى إدخال اللقب',
      name: 'lastNameError',
      desc: '',
      args: [],
    );
  }

  /// `يرجى إدخال رقم الهاتف`
  String get phoneNumError {
    return Intl.message(
      'يرجى إدخال رقم الهاتف',
      name: 'phoneNumError',
      desc: '',
      args: [],
    );
  }

  /// `يرجى ادخال 10 ارقام`
  String get phoneNumLengthError {
    return Intl.message(
      'يرجى ادخال 10 ارقام',
      name: 'phoneNumLengthError',
      desc: '',
      args: [],
    );
  }

  /// `يرجى اختيار الولاية`
  String get wilayaError {
    return Intl.message(
      'يرجى اختيار الولاية',
      name: 'wilayaError',
      desc: '',
      args: [],
    );
  }

  /// `يرجى اختيار الدائرة`
  String get dairaError {
    return Intl.message(
      'يرجى اختيار الدائرة',
      name: 'dairaError',
      desc: '',
      args: [],
    );
  }

  /// `تحديث البريد الإلكتروني`
  String get updateEmail {
    return Intl.message(
      'تحديث البريد الإلكتروني',
      name: 'updateEmail',
      desc: '',
      args: [],
    );
  }

  /// `تحديث رقم الهاتف`
  String get updatePhoneNumber {
    return Intl.message(
      'تحديث رقم الهاتف',
      name: 'updatePhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `أدخل بريدًا إلكترونيًا جديدًا`
  String get enterNewEmail {
    return Intl.message(
      'أدخل بريدًا إلكترونيًا جديدًا',
      name: 'enterNewEmail',
      desc: '',
      args: [],
    );
  }

  /// `أدخل رقم هاتف جديد`
  String get enterNewPhoneNumber {
    return Intl.message(
      'أدخل رقم هاتف جديد',
      name: 'enterNewPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `إلغاء`
  String get cancel {
    return Intl.message('إلغاء', name: 'cancel', desc: '', args: []);
  }

  /// `خيارات البريد الإلكتروني`
  String get emailOptions {
    return Intl.message(
      'خيارات البريد الإلكتروني',
      name: 'emailOptions',
      desc: '',
      args: [],
    );
  }

  /// `خيارات رقم الهاتف`
  String get phoneOptions {
    return Intl.message(
      'خيارات رقم الهاتف',
      name: 'phoneOptions',
      desc: '',
      args: [],
    );
  }

  /// `تغيير البريد الإلكتروني`
  String get changeEmail {
    return Intl.message(
      'تغيير البريد الإلكتروني',
      name: 'changeEmail',
      desc: '',
      args: [],
    );
  }

  /// `تغيير رقم الهاتف`
  String get changePhoneNumber {
    return Intl.message(
      'تغيير رقم الهاتف',
      name: 'changePhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `حذف البريد الإلكتروني`
  String get deleteEmail {
    return Intl.message(
      'حذف البريد الإلكتروني',
      name: 'deleteEmail',
      desc: '',
      args: [],
    );
  }

  /// `حذف رقم الهاتف`
  String get deletePhoneNumber {
    return Intl.message(
      'حذف رقم الهاتف',
      name: 'deletePhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `تغيير كلمة المرور`
  String get changePassword {
    return Intl.message(
      'تغيير كلمة المرور',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `كلمة المرور القديمة`
  String get oldPassword {
    return Intl.message(
      'كلمة المرور القديمة',
      name: 'oldPassword',
      desc: '',
      args: [],
    );
  }

  /// `كلمة المرور الجديدة`
  String get newPassword {
    return Intl.message(
      'كلمة المرور الجديدة',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// ` ⚠️تنبيه `
  String get attention {
    return Intl.message(' ⚠️تنبيه ', name: 'attention', desc: '', args: []);
  }

  /// `هل أنت متأكد أنك تريد حذف هذا الحساب؟`
  String get confirmDeleteAccount {
    return Intl.message(
      'هل أنت متأكد أنك تريد حذف هذا الحساب؟',
      name: 'confirmDeleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `هل أنت متأكد أنك تريد حذف `
  String get confirmDeleteItem {
    return Intl.message(
      'هل أنت متأكد أنك تريد حذف ',
      name: 'confirmDeleteItem',
      desc: '',
      args: [],
    );
  }

  /// `الخصوصية والأمان`
  String get privacySecurity {
    return Intl.message(
      'الخصوصية والأمان',
      name: 'privacySecurity',
      desc: '',
      args: [],
    );
  }

  /// `قم بتمكين خيارات مصادقة متعددة لتعزيز أمان حسابك`
  String get securityMessage2 {
    return Intl.message(
      'قم بتمكين خيارات مصادقة متعددة لتعزيز أمان حسابك',
      name: 'securityMessage2',
      desc: '',
      args: [],
    );
  }

  /// `أمان متوسط`
  String get mediumSecurity {
    return Intl.message(
      'أمان متوسط',
      name: 'mediumSecurity',
      desc: '',
      args: [],
    );
  }

  /// `معلومات الاتصال`
  String get contactInfo {
    return Intl.message(
      'معلومات الاتصال',
      name: 'contactInfo',
      desc: '',
      args: [],
    );
  }

  /// `البريد الإلكتروني`
  String get email {
    return Intl.message('البريد الإلكتروني', name: 'email', desc: '', args: []);
  }

  /// `بطاقة الأمان`
  String get securityCard {
    return Intl.message(
      'بطاقة الأمان',
      name: 'securityCard',
      desc: '',
      args: [],
    );
  }

  /// `إدارة الحساب`
  String get accountManagement {
    return Intl.message(
      'إدارة الحساب',
      name: 'accountManagement',
      desc: '',
      args: [],
    );
  }

  /// `حذف الحساب`
  String get deleteAccount {
    return Intl.message(
      'حذف الحساب',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `الحساب`
  String get account {
    return Intl.message('الحساب', name: 'account', desc: '', args: []);
  }

  /// `بريدك الإلكتروني`
  String get yourEmail {
    return Intl.message(
      'بريدك الإلكتروني',
      name: 'yourEmail',
      desc: '',
      args: [],
    );
  }

  /// `اسمك`
  String get yourName {
    return Intl.message('اسمك', name: 'yourName', desc: '', args: []);
  }

  /// `الموضوع`
  String get subject {
    return Intl.message('الموضوع', name: 'subject', desc: '', args: []);
  }

  /// `وصف مشكلتك`
  String get describeProblem {
    return Intl.message(
      'وصف مشكلتك',
      name: 'describeProblem',
      desc: '',
      args: [],
    );
  }

  /// `إرسال التقرير`
  String get sendReport {
    return Intl.message(
      'إرسال التقرير',
      name: 'sendReport',
      desc: '',
      args: [],
    );
  }

  /// `أبلغ عن مشكلتك`
  String get reportYourProblem {
    return Intl.message(
      'أبلغ عن مشكلتك',
      name: 'reportYourProblem',
      desc: '',
      args: [],
    );
  }

  /// `✅ تم إرسال البريد الإلكتروني بنجاح! `
  String get emailSentSuccess {
    return Intl.message(
      '✅ تم إرسال البريد الإلكتروني بنجاح! ',
      name: 'emailSentSuccess',
      desc: '',
      args: [],
    );
  }

  /// ` ❌ حدث خطأ أثناء إرسال البريد الإلكتروني `
  String get emailSendError {
    return Intl.message(
      ' ❌ حدث خطأ أثناء إرسال البريد الإلكتروني ',
      name: 'emailSendError',
      desc: '',
      args: [],
    );
  }

  /// `الإيجار`
  String get rent {
    return Intl.message('الإيجار', name: 'rent', desc: '', args: []);
  }

  /// `الإصلاحات`
  String get repairs {
    return Intl.message('الإصلاحات', name: 'repairs', desc: '', args: []);
  }

  /// `الاستشارة`
  String get consultation {
    return Intl.message('الاستشارة', name: 'consultation', desc: '', args: []);
  }

  /// `توظيف عامل`
  String get hireWorker {
    return Intl.message('توظيف عامل', name: 'hireWorker', desc: '', args: []);
  }

  /// `النقل`
  String get transportation {
    return Intl.message('النقل', name: 'transportation', desc: '', args: []);
  }

  /// `الخبرة`
  String get expertise {
    return Intl.message('الخبرة', name: 'expertise', desc: '', args: []);
  }

  /// `الصفحة غير موجودة`
  String get pageNotFound {
    return Intl.message(
      'الصفحة غير موجودة',
      name: 'pageNotFound',
      desc: '',
      args: [],
    );
  }

  /// `جميع الولايات`
  String get all_wilayas {
    return Intl.message(
      'جميع الولايات',
      name: 'all_wilayas',
      desc: '',
      args: [],
    );
  }

  /// `جميع الدوائر`
  String get all_dairas {
    return Intl.message('جميع الدوائر', name: 'all_dairas', desc: '', args: []);
  }

  /// `خدمات النقل المميزة`
  String get featured_transportations {
    return Intl.message(
      'خدمات النقل المميزة',
      name: 'featured_transportations',
      desc: '',
      args: [],
    );
  }

  /// `لا توجد خدمات نقل`
  String get no_transport_services_found {
    return Intl.message(
      'لا توجد خدمات نقل',
      name: 'no_transport_services_found',
      desc: '',
      args: [],
    );
  }

  /// `حدث خطأ أثناء جلب البيانات`
  String get error_fetching_data {
    return Intl.message(
      'حدث خطأ أثناء جلب البيانات',
      name: 'error_fetching_data',
      desc: '',
      args: [],
    );
  }

  /// `خدمة النقل`
  String get transport_service {
    return Intl.message(
      'خدمة النقل',
      name: 'transport_service',
      desc: '',
      args: [],
    );
  }

  /// `خدمات التصليح`
  String get repairServices {
    return Intl.message(
      'خدمات التصليح',
      name: 'repairServices',
      desc: '',
      args: [],
    );
  }

  /// `خدمات التصليح المميزة`
  String get featuredRepairs {
    return Intl.message(
      'خدمات التصليح المميزة',
      name: 'featuredRepairs',
      desc: '',
      args: [],
    );
  }

  /// `حدث خطأ أثناء جلب البيانات`
  String get errorFetchingData {
    return Intl.message(
      'حدث خطأ أثناء جلب البيانات',
      name: 'errorFetchingData',
      desc: '',
      args: [],
    );
  }

  /// `لم يتم العثور على خدمات تصليح`
  String get noRepairServicesFound {
    return Intl.message(
      'لم يتم العثور على خدمات تصليح',
      name: 'noRepairServicesFound',
      desc: '',
      args: [],
    );
  }

  /// `خدمات الإيجار`
  String get rent_services {
    return Intl.message(
      'خدمات الإيجار',
      name: 'rent_services',
      desc: '',
      args: [],
    );
  }

  /// `الإيجارات المميزة`
  String get featured_rent {
    return Intl.message(
      'الإيجارات المميزة',
      name: 'featured_rent',
      desc: '',
      args: [],
    );
  }

  /// `لم يتم العثور على خدمات للإيجار`
  String get no_rent_services_found {
    return Intl.message(
      'لم يتم العثور على خدمات للإيجار',
      name: 'no_rent_services_found',
      desc: '',
      args: [],
    );
  }

  /// `خدمات الخبرة`
  String get expertise_services {
    return Intl.message(
      'خدمات الخبرة',
      name: 'expertise_services',
      desc: '',
      args: [],
    );
  }

  /// `أبرز الخبرات`
  String get featured_expertise {
    return Intl.message(
      'أبرز الخبرات',
      name: 'featured_expertise',
      desc: '',
      args: [],
    );
  }

  /// `لم يتم العثور على خدمات الخبرة`
  String get no_expertise_found {
    return Intl.message(
      'لم يتم العثور على خدمات الخبرة',
      name: 'no_expertise_found',
      desc: '',
      args: [],
    );
  }

  /// `لا يوجد أطباء بيطريين`
  String get no_veterinarians_found {
    return Intl.message(
      'لا يوجد أطباء بيطريين',
      name: 'no_veterinarians_found',
      desc: '',
      args: [],
    );
  }

  /// `الرسائل`
  String get messages {
    return Intl.message('الرسائل', name: 'messages', desc: '', args: []);
  }

  /// `لا توجد رسائل بعد`
  String get noMessages {
    return Intl.message(
      'لا توجد رسائل بعد',
      name: 'noMessages',
      desc: '',
      args: [],
    );
  }

  /// `رسالة...`
  String get messageHint {
    return Intl.message('رسالة...', name: 'messageHint', desc: '', args: []);
  }

  /// `ناقل`
  String get transporteur {
    return Intl.message('ناقل', name: 'transporteur', desc: '', args: []);
  }

  /// `طبيب بيطرى`
  String get veterinaire {
    return Intl.message('طبيب بيطرى', name: 'veterinaire', desc: '', args: []);
  }

  /// `خبير زراعي`
  String get expertAgri {
    return Intl.message('خبير زراعي', name: 'expertAgri', desc: '', args: []);
  }

  /// `مصلح`
  String get reparateur {
    return Intl.message('مصلح', name: 'reparateur', desc: '', args: []);
  }

  /// `شركة`
  String get entreprise {
    return Intl.message('شركة', name: 'entreprise', desc: '', args: []);
  }

  /// `تاجر`
  String get commercant {
    return Intl.message('تاجر', name: 'commercant', desc: '', args: []);
  }

  /// `فلاح`
  String get agriculteur {
    return Intl.message('فلاح', name: 'agriculteur', desc: '', args: []);
  }

  /// `مربي`
  String get eleveur {
    return Intl.message('مربي', name: 'eleveur', desc: '', args: []);
  }

  /// `عميل`
  String get client {
    return Intl.message('عميل', name: 'client', desc: '', args: []);
  }

  /// `الهوية الأمامية`
  String get identityFront {
    return Intl.message(
      'الهوية الأمامية',
      name: 'identityFront',
      desc: '',
      args: [],
    );
  }

  /// `الهوية الخلفية`
  String get identityBack {
    return Intl.message(
      'الهوية الخلفية',
      name: 'identityBack',
      desc: '',
      args: [],
    );
  }

  /// `رخصة القيادة`
  String get drivingLicense {
    return Intl.message(
      'رخصة القيادة',
      name: 'drivingLicense',
      desc: '',
      args: [],
    );
  }

  /// `شهادة بيطرية`
  String get veterinaryCertificate {
    return Intl.message(
      'شهادة بيطرية',
      name: 'veterinaryCertificate',
      desc: '',
      args: [],
    );
  }

  /// `شهادة`
  String get certificate {
    return Intl.message('شهادة', name: 'certificate', desc: '', args: []);
  }

  /// `السجل التجاري`
  String get commercialRegister {
    return Intl.message(
      'السجل التجاري',
      name: 'commercialRegister',
      desc: '',
      args: [],
    );
  }

  /// `غير مرفقة`
  String get document_not_attached {
    return Intl.message(
      'غير مرفقة',
      name: 'document_not_attached',
      desc: '',
      args: [],
    );
  }

  /// `✅ تم إرسال الوثائق بنجاح`
  String get documents_sent_successfully {
    return Intl.message(
      '✅ تم إرسال الوثائق بنجاح',
      name: 'documents_sent_successfully',
      desc: '',
      args: [],
    );
  }

  /// `توثيق `
  String get document_title {
    return Intl.message('توثيق ', name: 'document_title', desc: '', args: []);
  }

  /// `إرسال الوثائق`
  String get submitDocuments {
    return Intl.message(
      'إرسال الوثائق',
      name: 'submitDocuments',
      desc: '',
      args: [],
    );
  }

  /// `من نحن`
  String get aboutUs {
    return Intl.message('من نحن', name: 'aboutUs', desc: '', args: []);
  }

  /// `👋🏼مرحبًا `
  String get welcomeMessage {
    return Intl.message(
      '👋🏼مرحبًا ',
      name: 'welcomeMessage',
      desc: '',
      args: [],
    );
  }

  /// ` 🔍 استمتع بتصفح التطبيق `
  String get guestSubtitle {
    return Intl.message(
      ' 🔍 استمتع بتصفح التطبيق ',
      name: 'guestSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `⏳ ... جار التحميل `
  String get loading {
    return Intl.message(
      '⏳ ... جار التحميل ',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `مرحبًا`
  String get hi {
    return Intl.message('مرحبًا', name: 'hi', desc: '', args: []);
  }

  /// `الـ`
  String get the {
    return Intl.message('الـ', name: 'the', desc: '', args: []);
  }

  /// `أصبح`
  String get become {
    return Intl.message('أصبح', name: 'become', desc: '', args: []);
  }

  /// `دخول الزائر محدود. يرجى تسجيل الدخول للمتابعة `
  String get guestAccessLimited {
    return Intl.message(
      'دخول الزائر محدود. يرجى تسجيل الدخول للمتابعة ',
      name: 'guestAccessLimited',
      desc: '',
      args: [],
    );
  }

  /// ` ⚠️ الوصول مقيد`
  String get accessRestricted {
    return Intl.message(
      ' ⚠️ الوصول مقيد',
      name: 'accessRestricted',
      desc: '',
      args: [],
    );
  }

  /// `لا يمكنه إضافة المنتجات.`
  String get cannotAddProducts {
    return Intl.message(
      'لا يمكنه إضافة المنتجات.',
      name: 'cannotAddProducts',
      desc: '',
      args: [],
    );
  }

  /// `حسناً`
  String get ok {
    return Intl.message('حسناً', name: 'ok', desc: '', args: []);
  }

  /// `ماسح الذكاء الاصطناعي`
  String get aiScanner {
    return Intl.message(
      'ماسح الذكاء الاصطناعي',
      name: 'aiScanner',
      desc: '',
      args: [],
    );
  }

  /// `احصل على فحص مجاني من جهاز الكشف عن أمراض النباتات بالذكاء الاصطناعي`
  String get aiDescription {
    return Intl.message(
      'احصل على فحص مجاني من جهاز الكشف عن أمراض النباتات بالذكاء الاصطناعي',
      name: 'aiDescription',
      desc: '',
      args: [],
    );
  }

  /// `جربه الآن`
  String get checkItOut {
    return Intl.message('جربه الآن', name: 'checkItOut', desc: '', args: []);
  }

  /// `لاستخدام ماسح الذكاء الاصطناعي، يرجى تسجيل الدخول إلى حسابك`
  String get aiScannerSignInMessage {
    return Intl.message(
      'لاستخدام ماسح الذكاء الاصطناعي، يرجى تسجيل الدخول إلى حسابك',
      name: 'aiScannerSignInMessage',
      desc: '',
      args: [],
    );
  }

  /// `المنتجات المميزة`
  String get featuredProducts {
    return Intl.message(
      'المنتجات المميزة',
      name: 'featuredProducts',
      desc: '',
      args: [],
    );
  }

  /// `رؤية الكل`
  String get seeAll {
    return Intl.message('رؤية الكل', name: 'seeAll', desc: '', args: []);
  }

  /// `لا يوجد منتج بهذا الاسم`
  String get noProductWithName {
    return Intl.message(
      'لا يوجد منتج بهذا الاسم',
      name: 'noProductWithName',
      desc: '',
      args: [],
    );
  }

  /// `ابحث هنا`
  String get searchHere {
    return Intl.message('ابحث هنا', name: 'searchHere', desc: '', args: []);
  }

  /// `تسجيل الدخول`
  String get login {
    return Intl.message('تسجيل الدخول', name: 'login', desc: '', args: []);
  }

  /// `تسجيل الدخول`
  String get signIn {
    return Intl.message('تسجيل الدخول', name: 'signIn', desc: '', args: []);
  }

  /// `مرحبًا بك في منصتنا`
  String get welcomeMessage2 {
    return Intl.message(
      'مرحبًا بك في منصتنا',
      name: 'welcomeMessage2',
      desc: '',
      args: [],
    );
  }

  /// `كلمة المرور`
  String get passwordHint {
    return Intl.message(
      'كلمة المرور',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `هل نسيت كلمة المرور؟`
  String get forgotPassword {
    return Intl.message(
      'هل نسيت كلمة المرور؟',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `سجل الآن`
  String get signup {
    return Intl.message('سجل الآن', name: 'signup', desc: '', args: []);
  }

  /// `ليس لديك حساب ؟`
  String get noAccount {
    return Intl.message(
      'ليس لديك حساب ؟',
      name: 'noAccount',
      desc: '',
      args: [],
    );
  }

  /// `منتوجات فلاحية`
  String get agriculturalProducts {
    return Intl.message(
      'منتوجات فلاحية',
      name: 'agriculturalProducts',
      desc: '',
      args: [],
    );
  }

  /// `الفواكه`
  String get fruits {
    return Intl.message('الفواكه', name: 'fruits', desc: '', args: []);
  }

  /// `الخضروات`
  String get vegetables {
    return Intl.message('الخضروات', name: 'vegetables', desc: '', args: []);
  }

  /// `الحبوب`
  String get grains {
    return Intl.message('الحبوب', name: 'grains', desc: '', args: []);
  }

  /// `المحاصيل الزيتية`
  String get oilCrops {
    return Intl.message(
      'المحاصيل الزيتية',
      name: 'oilCrops',
      desc: '',
      args: [],
    );
  }

  /// `البقوليات`
  String get legumes {
    return Intl.message('البقوليات', name: 'legumes', desc: '', args: []);
  }

  /// `النباتات العطرية و الطبية`
  String get medicinalPlants {
    return Intl.message(
      'النباتات العطرية و الطبية',
      name: 'medicinalPlants',
      desc: '',
      args: [],
    );
  }

  /// `الأعلاف`
  String get fodder {
    return Intl.message('الأعلاف', name: 'fodder', desc: '', args: []);
  }

  /// `تفاح`
  String get apple {
    return Intl.message('تفاح', name: 'apple', desc: '', args: []);
  }

  /// `برتقال`
  String get orange {
    return Intl.message('برتقال', name: 'orange', desc: '', args: []);
  }

  /// `موز`
  String get banana {
    return Intl.message('موز', name: 'banana', desc: '', args: []);
  }

  /// `عنب`
  String get grape {
    return Intl.message('عنب', name: 'grape', desc: '', args: []);
  }

  /// `فراولة`
  String get strawberry {
    return Intl.message('فراولة', name: 'strawberry', desc: '', args: []);
  }

  /// `مانجو`
  String get mango {
    return Intl.message('مانجو', name: 'mango', desc: '', args: []);
  }

  /// `كمثرى`
  String get pear {
    return Intl.message('كمثرى', name: 'pear', desc: '', args: []);
  }

  /// `كرز`
  String get cherry {
    return Intl.message('كرز', name: 'cherry', desc: '', args: []);
  }

  /// `بطيخ`
  String get watermelon {
    return Intl.message('بطيخ', name: 'watermelon', desc: '', args: []);
  }

  /// `شمام`
  String get cantaloupe {
    return Intl.message('شمام', name: 'cantaloupe', desc: '', args: []);
  }

  /// `كيوي`
  String get kiwi {
    return Intl.message('كيوي', name: 'kiwi', desc: '', args: []);
  }

  /// `أناناس`
  String get pineapple {
    return Intl.message('أناناس', name: 'pineapple', desc: '', args: []);
  }

  /// `رمان`
  String get pomegranate {
    return Intl.message('رمان', name: 'pomegranate', desc: '', args: []);
  }

  /// `تين`
  String get fig {
    return Intl.message('تين', name: 'fig', desc: '', args: []);
  }

  /// `تمر`
  String get date {
    return Intl.message('تمر', name: 'date', desc: '', args: []);
  }

  /// `طماطم`
  String get tomato {
    return Intl.message('طماطم', name: 'tomato', desc: '', args: []);
  }

  /// `جزر`
  String get carrot {
    return Intl.message('جزر', name: 'carrot', desc: '', args: []);
  }

  /// `بطاطا`
  String get potato {
    return Intl.message('بطاطا', name: 'potato', desc: '', args: []);
  }

  /// `فلفل`
  String get pepper {
    return Intl.message('فلفل', name: 'pepper', desc: '', args: []);
  }

  /// `بصل`
  String get onion {
    return Intl.message('بصل', name: 'onion', desc: '', args: []);
  }

  /// `ثوم`
  String get garlic {
    return Intl.message('ثوم', name: 'garlic', desc: '', args: []);
  }

  /// `خس`
  String get lettuce {
    return Intl.message('خس', name: 'lettuce', desc: '', args: []);
  }

  /// `خيار`
  String get cucumber {
    return Intl.message('خيار', name: 'cucumber', desc: '', args: []);
  }

  /// `باذنجان`
  String get eggplant {
    return Intl.message('باذنجان', name: 'eggplant', desc: '', args: []);
  }

  /// `سبانخ`
  String get spinach {
    return Intl.message('سبانخ', name: 'spinach', desc: '', args: []);
  }

  /// `ملفوف`
  String get cabbage {
    return Intl.message('ملفوف', name: 'cabbage', desc: '', args: []);
  }

  /// `فجل`
  String get radish {
    return Intl.message('فجل', name: 'radish', desc: '', args: []);
  }

  /// `شمندر`
  String get beet {
    return Intl.message('شمندر', name: 'beet', desc: '', args: []);
  }

  /// `فاصوليا خضراء`
  String get greenBeans {
    return Intl.message(
      'فاصوليا خضراء',
      name: 'greenBeans',
      desc: '',
      args: [],
    );
  }

  /// `كرفس`
  String get celery {
    return Intl.message('كرفس', name: 'celery', desc: '', args: []);
  }

  /// `قمح`
  String get wheat {
    return Intl.message('قمح', name: 'wheat', desc: '', args: []);
  }

  /// `شعير`
  String get barley {
    return Intl.message('شعير', name: 'barley', desc: '', args: []);
  }

  /// `ذرة`
  String get corn {
    return Intl.message('ذرة', name: 'corn', desc: '', args: []);
  }

  /// `أرز`
  String get rice {
    return Intl.message('أرز', name: 'rice', desc: '', args: []);
  }

  /// `سورغم`
  String get sorghum {
    return Intl.message('سورغم', name: 'sorghum', desc: '', args: []);
  }

  /// `شوفان`
  String get oats {
    return Intl.message('شوفان', name: 'oats', desc: '', args: []);
  }

  /// `جاودار`
  String get rye {
    return Intl.message('جاودار', name: 'rye', desc: '', args: []);
  }

  /// `دخن`
  String get millet {
    return Intl.message('دخن', name: 'millet', desc: '', args: []);
  }

  /// `كينوا`
  String get quinoa {
    return Intl.message('كينوا', name: 'quinoa', desc: '', args: []);
  }

  /// `زيتون`
  String get olive {
    return Intl.message('زيتون', name: 'olive', desc: '', args: []);
  }

  /// `لوز`
  String get almond {
    return Intl.message('لوز', name: 'almond', desc: '', args: []);
  }

  /// `بندق`
  String get hazelnut {
    return Intl.message('بندق', name: 'hazelnut', desc: '', args: []);
  }

  /// `جوز`
  String get walnut {
    return Intl.message('جوز', name: 'walnut', desc: '', args: []);
  }

  /// `بذور عباد الشمس`
  String get sunflowerSeeds {
    return Intl.message(
      'بذور عباد الشمس',
      name: 'sunflowerSeeds',
      desc: '',
      args: [],
    );
  }

  /// `بذور السمسم`
  String get sesameSeeds {
    return Intl.message('بذور السمسم', name: 'sesameSeeds', desc: '', args: []);
  }

  /// `بذور الكتان`
  String get flaxSeeds {
    return Intl.message('بذور الكتان', name: 'flaxSeeds', desc: '', args: []);
  }

  /// `بذور اللفت`
  String get rapeseeds {
    return Intl.message('بذور اللفت', name: 'rapeseeds', desc: '', args: []);
  }

  /// `فول سوداني`
  String get peanut {
    return Intl.message('فول سوداني', name: 'peanut', desc: '', args: []);
  }

  /// `عدس`
  String get lentil {
    return Intl.message('عدس', name: 'lentil', desc: '', args: []);
  }

  /// `حمص`
  String get chickpea {
    return Intl.message('حمص', name: 'chickpea', desc: '', args: []);
  }

  /// `فاصوليا بيضاء`
  String get whiteBeans {
    return Intl.message(
      'فاصوليا بيضاء',
      name: 'whiteBeans',
      desc: '',
      args: [],
    );
  }

  /// `فول`
  String get broadBeans {
    return Intl.message('فول', name: 'broadBeans', desc: '', args: []);
  }

  /// `بازلاء مجففة`
  String get driedPeas {
    return Intl.message('بازلاء مجففة', name: 'driedPeas', desc: '', args: []);
  }

  /// `فاصوليا حمراء`
  String get redBeans {
    return Intl.message('فاصوليا حمراء', name: 'redBeans', desc: '', args: []);
  }

  /// `فول الصويا`
  String get soybean {
    return Intl.message('فول الصويا', name: 'soybean', desc: '', args: []);
  }

  /// `نعناع`
  String get mint {
    return Intl.message('نعناع', name: 'mint', desc: '', args: []);
  }

  /// `ريحان`
  String get basil {
    return Intl.message('ريحان', name: 'basil', desc: '', args: []);
  }

  /// `زعتر`
  String get thyme {
    return Intl.message('زعتر', name: 'thyme', desc: '', args: []);
  }

  /// `إكليل الجبل`
  String get rosemary {
    return Intl.message('إكليل الجبل', name: 'rosemary', desc: '', args: []);
  }

  /// `بابونج`
  String get chamomile {
    return Intl.message('بابونج', name: 'chamomile', desc: '', args: []);
  }

  /// `لافندر`
  String get lavender {
    return Intl.message('لافندر', name: 'lavender', desc: '', args: []);
  }

  /// `مريمية`
  String get sage {
    return Intl.message('مريمية', name: 'sage', desc: '', args: []);
  }

  /// `بقدونس`
  String get parsley {
    return Intl.message('بقدونس', name: 'parsley', desc: '', args: []);
  }

  /// `كزبرة`
  String get coriander {
    return Intl.message('كزبرة', name: 'coriander', desc: '', args: []);
  }

  /// `برسيم`
  String get alfalfa {
    return Intl.message('برسيم', name: 'alfalfa', desc: '', args: []);
  }

  /// `تبن`
  String get straw {
    return Intl.message('تبن', name: 'straw', desc: '', args: []);
  }

  /// `نفل`
  String get clover {
    return Intl.message('نفل', name: 'clover', desc: '', args: []);
  }

  /// `سيلاج الذرة`
  String get cornSilage {
    return Intl.message('سيلاج الذرة', name: 'cornSilage', desc: '', args: []);
  }

  /// `سورغم العلفي`
  String get fodderSorghum {
    return Intl.message(
      'سورغم العلفي',
      name: 'fodderSorghum',
      desc: '',
      args: [],
    );
  }

  /// `معدات`
  String get equipment {
    return Intl.message('معدات', name: 'equipment', desc: '', args: []);
  }

  /// `المعدات الزراعية`
  String get agriculturalEquipment {
    return Intl.message(
      'المعدات الزراعية',
      name: 'agriculturalEquipment',
      desc: '',
      args: [],
    );
  }

  /// `معدات الري`
  String get irrigationEquipment {
    return Intl.message(
      'معدات الري',
      name: 'irrigationEquipment',
      desc: '',
      args: [],
    );
  }

  /// `أراضي`
  String get lands {
    return Intl.message('أراضي', name: 'lands', desc: '', args: []);
  }

  /// `جرار زراعي`
  String get tractor {
    return Intl.message('جرار زراعي', name: 'tractor', desc: '', args: []);
  }

  /// `آلة الحرث`
  String get plowMachine {
    return Intl.message('آلة الحرث', name: 'plowMachine', desc: '', args: []);
  }

  /// `آلة الحصاد`
  String get harvester {
    return Intl.message('آلة الحصاد', name: 'harvester', desc: '', args: []);
  }

  /// `آلة البذر`
  String get seeder {
    return Intl.message('آلة البذر', name: 'seeder', desc: '', args: []);
  }

  /// `رشاش مبيدات`
  String get pesticideSprayer {
    return Intl.message(
      'رشاش مبيدات',
      name: 'pesticideSprayer',
      desc: '',
      args: [],
    );
  }

  /// `محراث`
  String get plow {
    return Intl.message('محراث', name: 'plow', desc: '', args: []);
  }

  /// `آلة جمع الأعلاف`
  String get forageHarvester {
    return Intl.message(
      'آلة جمع الأعلاف',
      name: 'forageHarvester',
      desc: '',
      args: [],
    );
  }

  /// `خزان ماء متنقل`
  String get mobileWaterTank {
    return Intl.message(
      'خزان ماء متنقل',
      name: 'mobileWaterTank',
      desc: '',
      args: [],
    );
  }

  /// `مضخة مياه`
  String get waterPump {
    return Intl.message('مضخة مياه', name: 'waterPump', desc: '', args: []);
  }

  /// `آلة التسميد`
  String get fertilizerSpreader {
    return Intl.message(
      'آلة التسميد',
      name: 'fertilizerSpreader',
      desc: '',
      args: [],
    );
  }

  /// `غربال حبوب`
  String get grainSieve {
    return Intl.message('غربال حبوب', name: 'grainSieve', desc: '', args: []);
  }

  /// `مقطورة زراعية`
  String get agriculturalTrailer {
    return Intl.message(
      'مقطورة زراعية',
      name: 'agriculturalTrailer',
      desc: '',
      args: [],
    );
  }

  /// `أنابيب الري`
  String get irrigationPipes {
    return Intl.message(
      'أنابيب الري',
      name: 'irrigationPipes',
      desc: '',
      args: [],
    );
  }

  /// `رشاشات مياه`
  String get waterSprinklers {
    return Intl.message(
      'رشاشات مياه',
      name: 'waterSprinklers',
      desc: '',
      args: [],
    );
  }

  /// `الحيوانات الحية`
  String get liveAnimals {
    return Intl.message(
      'الحيوانات الحية',
      name: 'liveAnimals',
      desc: '',
      args: [],
    );
  }

  /// `أبقار حلوب`
  String get dairyCows {
    return Intl.message('أبقار حلوب', name: 'dairyCows', desc: '', args: []);
  }

  /// `أبقار للتسمين`
  String get beefCattle {
    return Intl.message(
      'أبقار للتسمين',
      name: 'beefCattle',
      desc: '',
      args: [],
    );
  }

  /// `عجول`
  String get calves {
    return Intl.message('عجول', name: 'calves', desc: '', args: []);
  }

  /// `أغنام (خراف، نعاج)`
  String get sheepGoats {
    return Intl.message(
      'أغنام (خراف، نعاج)',
      name: 'sheepGoats',
      desc: '',
      args: [],
    );
  }

  /// `ماعز (جديان، إناث ماعز)`
  String get goats {
    return Intl.message(
      'ماعز (جديان، إناث ماعز)',
      name: 'goats',
      desc: '',
      args: [],
    );
  }

  /// `جمال`
  String get camels {
    return Intl.message('جمال', name: 'camels', desc: '', args: []);
  }

  /// `خيول`
  String get horses {
    return Intl.message('خيول', name: 'horses', desc: '', args: []);
  }

  /// `دواجن (دجاج، بط، ديك رومي)`
  String get poultry {
    return Intl.message(
      'دواجن (دجاج، بط، ديك رومي)',
      name: 'poultry',
      desc: '',
      args: [],
    );
  }

  /// `أرانب`
  String get rabbits {
    return Intl.message('أرانب', name: 'rabbits', desc: '', args: []);
  }

  /// `منتجات الألبان ومشتقاتها`
  String get dairyProducts {
    return Intl.message(
      'منتجات الألبان ومشتقاتها',
      name: 'dairyProducts',
      desc: '',
      args: [],
    );
  }

  /// `الحليب الطازج (بقري، ماعز، غنم)`
  String get freshMilk {
    return Intl.message(
      'الحليب الطازج (بقري، ماعز، غنم)',
      name: 'freshMilk',
      desc: '',
      args: [],
    );
  }

  /// `الجبن (بلدي، موزاريلا، شيدر)`
  String get cheese {
    return Intl.message(
      'الجبن (بلدي، موزاريلا، شيدر)',
      name: 'cheese',
      desc: '',
      args: [],
    );
  }

  /// `الزبدة الطبيعية`
  String get butter {
    return Intl.message('الزبدة الطبيعية', name: 'butter', desc: '', args: []);
  }

  /// `الياغورت الطبيعي`
  String get yogurt {
    return Intl.message('الياغورت الطبيعي', name: 'yogurt', desc: '', args: []);
  }

  /// `القشطة`
  String get cream {
    return Intl.message('القشطة', name: 'cream', desc: '', args: []);
  }

  /// `اللبن الرائب`
  String get labanRaiib {
    return Intl.message('اللبن الرائب', name: 'labanRaiib', desc: '', args: []);
  }

  /// `المنتجات المشتقة من الحيوانات`
  String get animalByproducts {
    return Intl.message(
      'المنتجات المشتقة من الحيوانات',
      name: 'animalByproducts',
      desc: '',
      args: [],
    );
  }

  /// `الصوف الخام`
  String get rawWool {
    return Intl.message('الصوف الخام', name: 'rawWool', desc: '', args: []);
  }

  /// `الجلود الطبيعية (بقر، غنم، ماعز)`
  String get naturalLeather {
    return Intl.message(
      'الجلود الطبيعية (بقر، غنم، ماعز)',
      name: 'naturalLeather',
      desc: '',
      args: [],
    );
  }

  /// `العسل الطبيعي`
  String get honey {
    return Intl.message('العسل الطبيعي', name: 'honey', desc: '', args: []);
  }

  /// `شمع النحل`
  String get beeswax {
    return Intl.message('شمع النحل', name: 'beeswax', desc: '', args: []);
  }

  /// `البيض (بلدي، مزارع)`
  String get eggs {
    return Intl.message(
      'البيض (بلدي، مزارع)',
      name: 'eggs',
      desc: '',
      args: [],
    );
  }

  /// `السماد الطبيعي العضوي`
  String get organicFertilizer {
    return Intl.message(
      'السماد الطبيعي العضوي',
      name: 'organicFertilizer',
      desc: '',
      args: [],
    );
  }

  /// `معدات وأدوات تربية المواشي`
  String get livestockTools {
    return Intl.message(
      'معدات وأدوات تربية المواشي',
      name: 'livestockTools',
      desc: '',
      args: [],
    );
  }

  /// `أقفاص وحظائر متنقلة`
  String get portableCages {
    return Intl.message(
      'أقفاص وحظائر متنقلة',
      name: 'portableCages',
      desc: '',
      args: [],
    );
  }

  /// `معالف ومشارب أوتوماتيكية`
  String get automaticFeeders {
    return Intl.message(
      'معالف ومشارب أوتوماتيكية',
      name: 'automaticFeeders',
      desc: '',
      args: [],
    );
  }

  /// `أجهزة الحلب اليدوية والكهربائية`
  String get manualElectricMilking {
    return Intl.message(
      'أجهزة الحلب اليدوية والكهربائية',
      name: 'manualElectricMilking',
      desc: '',
      args: [],
    );
  }

  /// `أدوات القص والتقليم (للحوافر والصوف)`
  String get hoofWoolTools {
    return Intl.message(
      'أدوات القص والتقليم (للحوافر والصوف)',
      name: 'hoofWoolTools',
      desc: '',
      args: [],
    );
  }

  /// `مستلزمات تدفئة الحظائر`
  String get barnHeating {
    return Intl.message(
      'مستلزمات تدفئة الحظائر',
      name: 'barnHeating',
      desc: '',
      args: [],
    );
  }

  /// `أنظمة تهوية وتحكم في الحرارة`
  String get ventilationSystems {
    return Intl.message(
      'أنظمة تهوية وتحكم في الحرارة',
      name: 'ventilationSystems',
      desc: '',
      args: [],
    );
  }

  /// `أدرار`
  String get adrar {
    return Intl.message('أدرار', name: 'adrar', desc: '', args: []);
  }

  /// `أولف`
  String get aoulef {
    return Intl.message('أولف', name: 'aoulef', desc: '', args: []);
  }

  /// `أوقروت`
  String get aougrout {
    return Intl.message('أوقروت', name: 'aougrout', desc: '', args: []);
  }

  /// `فنوغيل`
  String get fenoughil {
    return Intl.message('فنوغيل', name: 'fenoughil', desc: '', args: []);
  }

  /// `رقان`
  String get reggane {
    return Intl.message('رقان', name: 'reggane', desc: '', args: []);
  }

  /// `تيميمون`
  String get timimoun {
    return Intl.message('تيميمون', name: 'timimoun', desc: '', args: []);
  }

  /// `تسابيت`
  String get tsabit {
    return Intl.message('تسابيت', name: 'tsabit', desc: '', args: []);
  }

  /// `زاوية كنتة`
  String get zaouietKounta {
    return Intl.message(
      'زاوية كنتة',
      name: 'zaouietKounta',
      desc: '',
      args: [],
    );
  }

  /// `الشلف`
  String get chlef {
    return Intl.message('الشلف', name: 'chlef', desc: '', args: []);
  }

  /// `أبو الحسن`
  String get abouElHassan {
    return Intl.message('أبو الحسن', name: 'abouElHassan', desc: '', args: []);
  }

  /// `عين مران`
  String get ainMerane {
    return Intl.message('عين مران', name: 'ainMerane', desc: '', args: []);
  }

  /// `بني حواء`
  String get beniHaoua {
    return Intl.message('بني حواء', name: 'beniHaoua', desc: '', args: []);
  }

  /// `بوقادير`
  String get boukadir {
    return Intl.message('بوقادير', name: 'boukadir', desc: '', args: []);
  }

  /// `الكريمية`
  String get elKarimia {
    return Intl.message('الكريمية', name: 'elKarimia', desc: '', args: []);
  }

  /// `المرسى`
  String get elMarsa {
    return Intl.message('المرسى', name: 'elMarsa', desc: '', args: []);
  }

  /// `وادي الفضة`
  String get ouedFodda {
    return Intl.message('وادي الفضة', name: 'ouedFodda', desc: '', args: []);
  }

  /// `أولاد بن عبد القادر`
  String get ouledBenAbdelkader {
    return Intl.message(
      'أولاد بن عبد القادر',
      name: 'ouledBenAbdelkader',
      desc: '',
      args: [],
    );
  }

  /// `أولاد فارس`
  String get ouledFares {
    return Intl.message('أولاد فارس', name: 'ouledFares', desc: '', args: []);
  }

  /// `تاوقريت`
  String get taougrit {
    return Intl.message('تاوقريت', name: 'taougrit', desc: '', args: []);
  }

  /// `تنس`
  String get tenes {
    return Intl.message('تنس', name: 'tenes', desc: '', args: []);
  }

  /// `زبوجة`
  String get zeboudja {
    return Intl.message('زبوجة', name: 'zeboudja', desc: '', args: []);
  }

  /// `الأغواط`
  String get laghouat {
    return Intl.message('الأغواط', name: 'laghouat', desc: '', args: []);
  }

  /// `أفلو`
  String get aflou {
    return Intl.message('أفلو', name: 'aflou', desc: '', args: []);
  }

  /// `عين ماضي`
  String get ainMadhi {
    return Intl.message('عين ماضي', name: 'ainMadhi', desc: '', args: []);
  }

  /// `بريدة`
  String get brida {
    return Intl.message('بريدة', name: 'brida', desc: '', args: []);
  }

  /// `الغيشة`
  String get elGhicha {
    return Intl.message('الغيشة', name: 'elGhicha', desc: '', args: []);
  }

  /// `قلتة سيدي سعد`
  String get gueltetSidiSaad {
    return Intl.message(
      'قلتة سيدي سعد',
      name: 'gueltetSidiSaad',
      desc: '',
      args: [],
    );
  }

  /// `حاسي الرمل`
  String get hassiRMel {
    return Intl.message('حاسي الرمل', name: 'hassiRMel', desc: '', args: []);
  }

  /// `قصر الحيران`
  String get ksarElHirane {
    return Intl.message(
      'قصر الحيران',
      name: 'ksarElHirane',
      desc: '',
      args: [],
    );
  }

  /// `واد مرة`
  String get ouedMorra {
    return Intl.message('واد مرة', name: 'ouedMorra', desc: '', args: []);
  }

  /// `سيدي مخلوف`
  String get sidiMakhlouf {
    return Intl.message('سيدي مخلوف', name: 'sidiMakhlouf', desc: '', args: []);
  }

  /// `أم البواقي`
  String get oumElBouaghi {
    return Intl.message('أم البواقي', name: 'oumElBouaghi', desc: '', args: []);
  }

  /// `عين بابوش`
  String get ainBabouche {
    return Intl.message('عين بابوش', name: 'ainBabouche', desc: '', args: []);
  }

  /// `قصر الصباحي`
  String get ksarSbahi {
    return Intl.message('قصر الصباحي', name: 'ksarSbahi', desc: '', args: []);
  }

  /// `عين البيضاء`
  String get ainBeida {
    return Intl.message('عين البيضاء', name: 'ainBeida', desc: '', args: []);
  }

  /// `فكرينة`
  String get fkirina {
    return Intl.message('فكرينة', name: 'fkirina', desc: '', args: []);
  }

  /// `عين مليلة`
  String get ainMlila {
    return Intl.message('عين مليلة', name: 'ainMlila', desc: '', args: []);
  }

  /// `سوق نعمان`
  String get soukNaamane {
    return Intl.message('سوق نعمان', name: 'soukNaamane', desc: '', args: []);
  }

  /// `عين فكرون`
  String get ainFakroun {
    return Intl.message('عين فكرون', name: 'ainFakroun', desc: '', args: []);
  }

  /// `سيقوس`
  String get sigus {
    return Intl.message('سيقوس', name: 'sigus', desc: '', args: []);
  }

  /// `عين كرشة`
  String get ainKercha {
    return Intl.message('عين كرشة', name: 'ainKercha', desc: '', args: []);
  }

  /// `مسكيانة`
  String get meskiana {
    return Intl.message('مسكيانة', name: 'meskiana', desc: '', args: []);
  }

  /// `الضلعة`
  String get dhalaa {
    return Intl.message('الضلعة', name: 'dhalaa', desc: '', args: []);
  }

  /// `باتنة`
  String get batna {
    return Intl.message('باتنة', name: 'batna', desc: '', args: []);
  }

  /// `عين جاسر`
  String get ainDjasser {
    return Intl.message('عين جاسر', name: 'ainDjasser', desc: '', args: []);
  }

  /// `عين التوتة`
  String get ainTouta {
    return Intl.message('عين التوتة', name: 'ainTouta', desc: '', args: []);
  }

  /// `أريس`
  String get arris {
    return Intl.message('أريس', name: 'arris', desc: '', args: []);
  }

  /// `بريكة`
  String get barika {
    return Intl.message('بريكة', name: 'barika', desc: '', args: []);
  }

  /// `بوزينة`
  String get bouzina {
    return Intl.message('بوزينة', name: 'bouzina', desc: '', args: []);
  }

  /// `الشمرة`
  String get chemora {
    return Intl.message('الشمرة', name: 'chemora', desc: '', args: []);
  }

  /// `الجزار`
  String get djezzar {
    return Intl.message('الجزار', name: 'djezzar', desc: '', args: []);
  }

  /// `المعذر`
  String get elMadher {
    return Intl.message('المعذر', name: 'elMadher', desc: '', args: []);
  }

  /// `إشمول`
  String get ichmoul {
    return Intl.message('إشمول', name: 'ichmoul', desc: '', args: []);
  }

  /// `منعة`
  String get menaa {
    return Intl.message('منعة', name: 'menaa', desc: '', args: []);
  }

  /// `مروانة`
  String get merouana {
    return Intl.message('مروانة', name: 'merouana', desc: '', args: []);
  }

  /// `نقاوس`
  String get ngaous {
    return Intl.message('نقاوس', name: 'ngaous', desc: '', args: []);
  }

  /// `أولاد سي سليمان`
  String get ouledSiSlimane {
    return Intl.message(
      'أولاد سي سليمان',
      name: 'ouledSiSlimane',
      desc: '',
      args: [],
    );
  }

  /// `رأس العيون`
  String get rasElAioun {
    return Intl.message('رأس العيون', name: 'rasElAioun', desc: '', args: []);
  }

  /// `سقانة`
  String get seggana {
    return Intl.message('سقانة', name: 'seggana', desc: '', args: []);
  }

  /// `سريانة`
  String get seriana {
    return Intl.message('سريانة', name: 'seriana', desc: '', args: []);
  }

  /// `تازولت`
  String get tazoult {
    return Intl.message('تازولت', name: 'tazoult', desc: '', args: []);
  }

  /// `ثنية العابد`
  String get tenietElAbed {
    return Intl.message(
      'ثنية العابد',
      name: 'tenietElAbed',
      desc: '',
      args: [],
    );
  }

  /// `تيمقاد`
  String get timgad {
    return Intl.message('تيمقاد', name: 'timgad', desc: '', args: []);
  }

  /// `تكوت`
  String get tkout {
    return Intl.message('تكوت', name: 'tkout', desc: '', args: []);
  }

  /// `بجاية`
  String get bejaia {
    return Intl.message('بجاية', name: 'bejaia', desc: '', args: []);
  }

  /// `أدكار`
  String get adekar {
    return Intl.message('أدكار', name: 'adekar', desc: '', args: []);
  }

  /// `أقبو`
  String get akbou {
    return Intl.message('أقبو', name: 'akbou', desc: '', args: []);
  }

  /// `أميزور`
  String get amizour {
    return Intl.message('أميزور', name: 'amizour', desc: '', args: []);
  }

  /// `أوقاس`
  String get aokas {
    return Intl.message('أوقاس', name: 'aokas', desc: '', args: []);
  }

  /// `برباشة`
  String get barbacha {
    return Intl.message('برباشة', name: 'barbacha', desc: '', args: []);
  }

  /// `بني معوش`
  String get beniMaouche {
    return Intl.message('بني معوش', name: 'beniMaouche', desc: '', args: []);
  }

  /// `شميني`
  String get chemini {
    return Intl.message('شميني', name: 'chemini', desc: '', args: []);
  }

  /// `درقينة`
  String get darguina {
    return Intl.message('درقينة', name: 'darguina', desc: '', args: []);
  }

  /// `القصر`
  String get elKseur {
    return Intl.message('القصر', name: 'elKseur', desc: '', args: []);
  }

  /// `إغيل علي`
  String get ighilAli {
    return Intl.message('إغيل علي', name: 'ighilAli', desc: '', args: []);
  }

  /// `خراطة`
  String get kherrata {
    return Intl.message('خراطة', name: 'kherrata', desc: '', args: []);
  }

  /// `أوزلاقن`
  String get ouzellaguen {
    return Intl.message('أوزلاقن', name: 'ouzellaguen', desc: '', args: []);
  }

  /// `صدوق`
  String get seddouk {
    return Intl.message('صدوق', name: 'seddouk', desc: '', args: []);
  }

  /// `سيدي عيش`
  String get sidiAich {
    return Intl.message('سيدي عيش', name: 'sidiAich', desc: '', args: []);
  }

  /// `سوق الإثنين`
  String get soukElTenine {
    return Intl.message(
      'سوق الإثنين',
      name: 'soukElTenine',
      desc: '',
      args: [],
    );
  }

  /// `تازمالت`
  String get tazmalt {
    return Intl.message('تازمالت', name: 'tazmalt', desc: '', args: []);
  }

  /// `تيشي`
  String get tichy {
    return Intl.message('تيشي', name: 'tichy', desc: '', args: []);
  }

  /// `تيمزريت`
  String get timezrit {
    return Intl.message('تيمزريت', name: 'timezrit', desc: '', args: []);
  }

  /// `بسكرة`
  String get biskra {
    return Intl.message('بسكرة', name: 'biskra', desc: '', args: []);
  }

  /// `جمورة`
  String get djemorah {
    return Intl.message('جمورة', name: 'djemorah', desc: '', args: []);
  }

  /// `القنطرة`
  String get elKantara {
    return Intl.message('القنطرة', name: 'elKantara', desc: '', args: []);
  }

  /// `مشونش`
  String get mChouneche {
    return Intl.message('مشونش', name: 'mChouneche', desc: '', args: []);
  }

  /// `سيدي عقبة`
  String get sidiOkba {
    return Intl.message('سيدي عقبة', name: 'sidiOkba', desc: '', args: []);
  }

  /// `زريبة الوادي`
  String get zeribetElOued {
    return Intl.message(
      'زريبة الوادي',
      name: 'zeribetElOued',
      desc: '',
      args: [],
    );
  }

  /// `أورلال`
  String get ourlal {
    return Intl.message('أورلال', name: 'ourlal', desc: '', args: []);
  }

  /// `طولقة`
  String get tolga {
    return Intl.message('طولقة', name: 'tolga', desc: '', args: []);
  }

  /// `سيدي خالد`
  String get sidiKhaled {
    return Intl.message('سيدي خالد', name: 'sidiKhaled', desc: '', args: []);
  }

  /// `فوغالة`
  String get foughala {
    return Intl.message('فوغالة', name: 'foughala', desc: '', args: []);
  }

  /// `الوطاية`
  String get elOutaya {
    return Intl.message('الوطاية', name: 'elOutaya', desc: '', args: []);
  }

  /// `بشار`
  String get bechar {
    return Intl.message('بشار', name: 'bechar', desc: '', args: []);
  }

  /// `بني ونيف`
  String get beniOunif {
    return Intl.message('بني ونيف', name: 'beniOunif', desc: '', args: []);
  }

  /// `لحمر`
  String get lahmar {
    return Intl.message('لحمر', name: 'lahmar', desc: '', args: []);
  }

  /// `القنادسة`
  String get kenadsa {
    return Intl.message('القنادسة', name: 'kenadsa', desc: '', args: []);
  }

  /// `تاغيت`
  String get taghit {
    return Intl.message('تاغيت', name: 'taghit', desc: '', args: []);
  }

  /// `العبادلة`
  String get abadla {
    return Intl.message('العبادلة', name: 'abadla', desc: '', args: []);
  }

  /// `تبلبالة`
  String get tabelbala {
    return Intl.message('تبلبالة', name: 'tabelbala', desc: '', args: []);
  }

  /// `إقلي`
  String get igli {
    return Intl.message('إقلي', name: 'igli', desc: '', args: []);
  }

  /// `بني عباس`
  String get beniAbbes {
    return Intl.message('بني عباس', name: 'beniAbbes', desc: '', args: []);
  }

  /// `الواتة`
  String get elOuata {
    return Intl.message('الواتة', name: 'elOuata', desc: '', args: []);
  }

  /// `أولاد خضير`
  String get ouledKhoudir {
    return Intl.message('أولاد خضير', name: 'ouledKhoudir', desc: '', args: []);
  }

  /// `البليدة`
  String get blida {
    return Intl.message('البليدة', name: 'blida', desc: '', args: []);
  }

  /// `بوفاريك`
  String get boufarik {
    return Intl.message('بوفاريك', name: 'boufarik', desc: '', args: []);
  }

  /// `بوقرة`
  String get bougara {
    return Intl.message('بوقرة', name: 'bougara', desc: '', args: []);
  }

  /// `بوعينان`
  String get bouinan {
    return Intl.message('بوعينان', name: 'bouinan', desc: '', args: []);
  }

  /// `العفرون`
  String get elAffroun {
    return Intl.message('العفرون', name: 'elAffroun', desc: '', args: []);
  }

  /// `الأربعاء`
  String get larbaa {
    return Intl.message('الأربعاء', name: 'larbaa', desc: '', args: []);
  }

  /// `مفتاح`
  String get meftah {
    return Intl.message('مفتاح', name: 'meftah', desc: '', args: []);
  }

  /// `موزاية`
  String get mouzaia {
    return Intl.message('موزاية', name: 'mouzaia', desc: '', args: []);
  }

  /// `وادي العلايق`
  String get ouedAlleug {
    return Intl.message('وادي العلايق', name: 'ouedAlleug', desc: '', args: []);
  }

  /// `أولاد يعيش`
  String get ouledYaich {
    return Intl.message('أولاد يعيش', name: 'ouledYaich', desc: '', args: []);
  }

  /// `البويرة`
  String get bouira {
    return Intl.message('البويرة', name: 'bouira', desc: '', args: []);
  }

  /// `الحيزر`
  String get haizer {
    return Intl.message('الحيزر', name: 'haizer', desc: '', args: []);
  }

  /// `بشلول`
  String get bechloul {
    return Intl.message('بشلول', name: 'bechloul', desc: '', args: []);
  }

  /// `مشدالله`
  String get mChedallah {
    return Intl.message('مشدالله', name: 'mChedallah', desc: '', args: []);
  }

  /// `القادرية`
  String get kadiria {
    return Intl.message('القادرية', name: 'kadiria', desc: '', args: []);
  }

  /// `الأخضرية`
  String get lakhdaria {
    return Intl.message('الأخضرية', name: 'lakhdaria', desc: '', args: []);
  }

  /// `بئر غبالو`
  String get birGhbalou {
    return Intl.message('بئر غبالو', name: 'birGhbalou', desc: '', args: []);
  }

  /// `عين بسام`
  String get ainBessam {
    return Intl.message('عين بسام', name: 'ainBessam', desc: '', args: []);
  }

  /// `سوق الخميس`
  String get soukElKhemis {
    return Intl.message('سوق الخميس', name: 'soukElKhemis', desc: '', args: []);
  }

  /// `الهاشمية`
  String get elHachimia {
    return Intl.message('الهاشمية', name: 'elHachimia', desc: '', args: []);
  }

  /// `سور الغزلان`
  String get sourElGhozlane {
    return Intl.message(
      'سور الغزلان',
      name: 'sourElGhozlane',
      desc: '',
      args: [],
    );
  }

  /// `برج أوخريص`
  String get bordjOkhriss {
    return Intl.message('برج أوخريص', name: 'bordjOkhriss', desc: '', args: []);
  }

  /// `تمنراست`
  String get tamanrasset {
    return Intl.message('تمنراست', name: 'tamanrasset', desc: '', args: []);
  }

  /// `أبلسة`
  String get abalessa {
    return Intl.message('أبلسة', name: 'abalessa', desc: '', args: []);
  }

  /// `عين غار`
  String get inGhar {
    return Intl.message('عين غار', name: 'inGhar', desc: '', args: []);
  }

  /// `تازروك`
  String get tazrouk {
    return Intl.message('تازروك', name: 'tazrouk', desc: '', args: []);
  }

  /// `تين زواتين`
  String get tinzaouten {
    return Intl.message('تين زواتين', name: 'tinzaouten', desc: '', args: []);
  }

  /// `تبسة`
  String get tebessa {
    return Intl.message('تبسة', name: 'tebessa', desc: '', args: []);
  }

  /// `الكويف`
  String get elKouif {
    return Intl.message('الكويف', name: 'elKouif', desc: '', args: []);
  }

  /// `مرسط`
  String get morsott {
    return Intl.message('مرسط', name: 'morsott', desc: '', args: []);
  }

  /// `الماء الأبيض`
  String get elMaLabiodh {
    return Intl.message(
      'الماء الأبيض',
      name: 'elMaLabiodh',
      desc: '',
      args: [],
    );
  }

  /// `العوينات`
  String get elAouinet {
    return Intl.message('العوينات', name: 'elAouinet', desc: '', args: []);
  }

  /// `الونزة`
  String get ouenza {
    return Intl.message('الونزة', name: 'ouenza', desc: '', args: []);
  }

  /// `بئر مقدم`
  String get birMokkadem {
    return Intl.message('بئر مقدم', name: 'birMokkadem', desc: '', args: []);
  }

  /// `بئر العاتر`
  String get birElAter {
    return Intl.message('بئر العاتر', name: 'birElAter', desc: '', args: []);
  }

  /// `العقلة`
  String get elOgla {
    return Intl.message('العقلة', name: 'elOgla', desc: '', args: []);
  }

  /// `أم علي`
  String get oumAli {
    return Intl.message('أم علي', name: 'oumAli', desc: '', args: []);
  }

  /// `نقرين`
  String get negrine {
    return Intl.message('نقرين', name: 'negrine', desc: '', args: []);
  }

  /// `الشريعة`
  String get cheria {
    return Intl.message('الشريعة', name: 'cheria', desc: '', args: []);
  }

  /// `تلمسان`
  String get tlemcen {
    return Intl.message('تلمسان', name: 'tlemcen', desc: '', args: []);
  }

  /// `عين تالوت`
  String get ainTallout {
    return Intl.message('عين تالوت', name: 'ainTallout', desc: '', args: []);
  }

  /// `باب العسة`
  String get babElAssa {
    return Intl.message('باب العسة', name: 'babElAssa', desc: '', args: []);
  }

  /// `بني بوسعيد`
  String get beniBoussaid {
    return Intl.message('بني بوسعيد', name: 'beniBoussaid', desc: '', args: []);
  }

  /// `بني سنوس`
  String get beniSnous {
    return Intl.message('بني سنوس', name: 'beniSnous', desc: '', args: []);
  }

  /// `بن سكران`
  String get bensekrane {
    return Intl.message('بن سكران', name: 'bensekrane', desc: '', args: []);
  }

  /// `شتوان`
  String get chetouane {
    return Intl.message('شتوان', name: 'chetouane', desc: '', args: []);
  }

  /// `العريشة`
  String get elAricha {
    return Intl.message('العريشة', name: 'elAricha', desc: '', args: []);
  }

  /// `فلاوسن`
  String get fellaoucene {
    return Intl.message('فلاوسن', name: 'fellaoucene', desc: '', args: []);
  }

  /// `الغزوات`
  String get ghazaouet {
    return Intl.message('الغزوات', name: 'ghazaouet', desc: '', args: []);
  }

  /// `الحناية`
  String get hennaya {
    return Intl.message('الحناية', name: 'hennaya', desc: '', args: []);
  }

  /// `هنين`
  String get honaine {
    return Intl.message('هنين', name: 'honaine', desc: '', args: []);
  }

  /// `مغنية`
  String get maghnia {
    return Intl.message('مغنية', name: 'maghnia', desc: '', args: []);
  }

  /// `منصورة`
  String get mansourah {
    return Intl.message('منصورة', name: 'mansourah', desc: '', args: []);
  }

  /// `مرسى بن مهيدي`
  String get marsaBenMHidi {
    return Intl.message(
      'مرسى بن مهيدي',
      name: 'marsaBenMHidi',
      desc: '',
      args: [],
    );
  }

  /// `ندرومة`
  String get nedroma {
    return Intl.message('ندرومة', name: 'nedroma', desc: '', args: []);
  }

  /// `أولاد ميمون`
  String get ouledMimoun {
    return Intl.message('أولاد ميمون', name: 'ouledMimoun', desc: '', args: []);
  }

  /// `الرمشي`
  String get remchi {
    return Intl.message('الرمشي', name: 'remchi', desc: '', args: []);
  }

  /// `صبرة`
  String get sabra {
    return Intl.message('صبرة', name: 'sabra', desc: '', args: []);
  }

  /// `سبدو`
  String get sebdou {
    return Intl.message('سبدو', name: 'sebdou', desc: '', args: []);
  }

  /// `سيدي الجيلالي`
  String get sidiDjillali {
    return Intl.message(
      'سيدي الجيلالي',
      name: 'sidiDjillali',
      desc: '',
      args: [],
    );
  }

  /// `تيارت`
  String get tiaret {
    return Intl.message('تيارت', name: 'tiaret', desc: '', args: []);
  }

  /// `السوقر`
  String get sougueur {
    return Intl.message('السوقر', name: 'sougueur', desc: '', args: []);
  }

  /// `عين الذهب`
  String get ainDeheb {
    return Intl.message('عين الذهب', name: 'ainDeheb', desc: '', args: []);
  }

  /// `عين كرمس`
  String get ainKermes {
    return Intl.message('عين كرمس', name: 'ainKermes', desc: '', args: []);
  }

  /// `فرندة`
  String get frenda {
    return Intl.message('فرندة', name: 'frenda', desc: '', args: []);
  }

  /// `دحموني`
  String get dahmouni {
    return Intl.message('دحموني', name: 'dahmouni', desc: '', args: []);
  }

  /// `مهدية`
  String get mahdia {
    return Intl.message('مهدية', name: 'mahdia', desc: '', args: []);
  }

  /// `حمادية`
  String get hamadia {
    return Intl.message('حمادية', name: 'hamadia', desc: '', args: []);
  }

  /// `قصر الشلالة`
  String get ksarChellala {
    return Intl.message(
      'قصر الشلالة',
      name: 'ksarChellala',
      desc: '',
      args: [],
    );
  }

  /// `مدروسة`
  String get medroussa {
    return Intl.message('مدروسة', name: 'medroussa', desc: '', args: []);
  }

  /// `مشرع الصفا`
  String get mechraSafa {
    return Intl.message('مشرع الصفا', name: 'mechraSafa', desc: '', args: []);
  }

  /// `الرحوية`
  String get rahouia {
    return Intl.message('الرحوية', name: 'rahouia', desc: '', args: []);
  }

  /// `وادي ليلي`
  String get ouedLilli {
    return Intl.message('وادي ليلي', name: 'ouedLilli', desc: '', args: []);
  }

  /// `مغيلة`
  String get meghila {
    return Intl.message('مغيلة', name: 'meghila', desc: '', args: []);
  }

  /// `تيزي وزو`
  String get tiziOuzou {
    return Intl.message('تيزي وزو', name: 'tiziOuzou', desc: '', args: []);
  }

  /// `عين الحمام`
  String get ainElHammam {
    return Intl.message('عين الحمام', name: 'ainElHammam', desc: '', args: []);
  }

  /// `عزازقة`
  String get azazga {
    return Intl.message('عزازقة', name: 'azazga', desc: '', args: []);
  }

  /// `أزفون`
  String get azeffoun {
    return Intl.message('أزفون', name: 'azeffoun', desc: '', args: []);
  }

  /// `بني دوالة`
  String get beniDouala {
    return Intl.message('بني دوالة', name: 'beniDouala', desc: '', args: []);
  }

  /// `بني يني`
  String get beniYenni {
    return Intl.message('بني يني', name: 'beniYenni', desc: '', args: []);
  }

  /// `بوغني`
  String get boghni {
    return Intl.message('بوغني', name: 'boghni', desc: '', args: []);
  }

  /// `بوزقن`
  String get bouzguen {
    return Intl.message('بوزقن', name: 'bouzguen', desc: '', args: []);
  }

  /// `ذراع بن خدة`
  String get draaBenKhedda {
    return Intl.message(
      'ذراع بن خدة',
      name: 'draaBenKhedda',
      desc: '',
      args: [],
    );
  }

  /// `ذراع الميزان`
  String get draaElMizan {
    return Intl.message(
      'ذراع الميزان',
      name: 'draaElMizan',
      desc: '',
      args: [],
    );
  }

  /// `إفرحونن`
  String get iferhounen {
    return Intl.message('إفرحونن', name: 'iferhounen', desc: '', args: []);
  }

  /// `الأربعاء ناث إيراثن`
  String get larbaaNathIrathen {
    return Intl.message(
      'الأربعاء ناث إيراثن',
      name: 'larbaaNathIrathen',
      desc: '',
      args: [],
    );
  }

  /// `معاتقة`
  String get maatkas {
    return Intl.message('معاتقة', name: 'maatkas', desc: '', args: []);
  }

  /// `ماكودة`
  String get makouda {
    return Intl.message('ماكودة', name: 'makouda', desc: '', args: []);
  }

  /// `مقلع`
  String get mekla {
    return Intl.message('مقلع', name: 'mekla', desc: '', args: []);
  }

  /// `واسيف`
  String get ouacif {
    return Intl.message('واسيف', name: 'ouacif', desc: '', args: []);
  }

  /// `واضية`
  String get ouadhia {
    return Intl.message('واضية', name: 'ouadhia', desc: '', args: []);
  }

  /// `واقنون`
  String get ouaguenoun {
    return Intl.message('واقنون', name: 'ouaguenoun', desc: '', args: []);
  }

  /// `تيقزيرت`
  String get tigzirt {
    return Intl.message('تيقزيرت', name: 'tigzirt', desc: '', args: []);
  }

  /// `تيزي غنيف`
  String get tiziGheniff {
    return Intl.message('تيزي غنيف', name: 'tiziGheniff', desc: '', args: []);
  }

  /// `تيزي راشد`
  String get tiziRached {
    return Intl.message('تيزي راشد', name: 'tiziRached', desc: '', args: []);
  }

  /// `الجزائر`
  String get alger {
    return Intl.message('الجزائر', name: 'alger', desc: '', args: []);
  }

  /// `زرالدة`
  String get zeralda {
    return Intl.message('زرالدة', name: 'zeralda', desc: '', args: []);
  }

  /// `الشراقة`
  String get cheraga {
    return Intl.message('الشراقة', name: 'cheraga', desc: '', args: []);
  }

  /// `الدرارية`
  String get draria {
    return Intl.message('الدرارية', name: 'draria', desc: '', args: []);
  }

  /// `بئر مراد رايس`
  String get birMouradRais {
    return Intl.message(
      'بئر مراد رايس',
      name: 'birMouradRais',
      desc: '',
      args: [],
    );
  }

  /// `بئر توتة`
  String get birtouta {
    return Intl.message('بئر توتة', name: 'birtouta', desc: '', args: []);
  }

  /// `بوزريعة`
  String get bouzareah {
    return Intl.message('بوزريعة', name: 'bouzareah', desc: '', args: []);
  }

  /// `باب الوادي`
  String get babElOued {
    return Intl.message('باب الوادي', name: 'babElOued', desc: '', args: []);
  }

  /// `سيدي امحمد`
  String get sidiMHamed {
    return Intl.message('سيدي امحمد', name: 'sidiMHamed', desc: '', args: []);
  }

  /// `حسين داي`
  String get husseinDey {
    return Intl.message('حسين داي', name: 'husseinDey', desc: '', args: []);
  }

  /// `الحراش`
  String get elHarrach {
    return Intl.message('الحراش', name: 'elHarrach', desc: '', args: []);
  }

  /// `براقي`
  String get baraki {
    return Intl.message('براقي', name: 'baraki', desc: '', args: []);
  }

  /// `الدار البيضاء`
  String get darElBeida {
    return Intl.message(
      'الدار البيضاء',
      name: 'darElBeida',
      desc: '',
      args: [],
    );
  }

  /// `الرويبة`
  String get rouiba {
    return Intl.message('الرويبة', name: 'rouiba', desc: '', args: []);
  }

  /// `الجلفة`
  String get djelfa {
    return Intl.message('الجلفة', name: 'djelfa', desc: '', args: []);
  }

  /// `عين الإبل`
  String get ainElIbel {
    return Intl.message('عين الإبل', name: 'ainElIbel', desc: '', args: []);
  }

  /// `عين وسارة`
  String get ainOussara {
    return Intl.message('عين وسارة', name: 'ainOussara', desc: '', args: []);
  }

  /// `بيرين`
  String get birine {
    return Intl.message('بيرين', name: 'birine', desc: '', args: []);
  }

  /// `الشارف`
  String get charef {
    return Intl.message('الشارف', name: 'charef', desc: '', args: []);
  }

  /// `دار الشيوخ`
  String get darChioukh {
    return Intl.message('دار الشيوخ', name: 'darChioukh', desc: '', args: []);
  }

  /// `الإدريسية`
  String get elIdrissia {
    return Intl.message('الإدريسية', name: 'elIdrissia', desc: '', args: []);
  }

  /// `فيض البطمة`
  String get faidhElBotma {
    return Intl.message('فيض البطمة', name: 'faidhElBotma', desc: '', args: []);
  }

  /// `حد الصحاري`
  String get hadSahary {
    return Intl.message('حد الصحاري', name: 'hadSahary', desc: '', args: []);
  }

  /// `حاسي بحبح`
  String get hassiBahbah {
    return Intl.message('حاسي بحبح', name: 'hassiBahbah', desc: '', args: []);
  }

  /// `سيدي لعجال`
  String get sidiLadjel {
    return Intl.message('سيدي لعجال', name: 'sidiLadjel', desc: '', args: []);
  }

  /// `مسعد`
  String get messaad {
    return Intl.message('مسعد', name: 'messaad', desc: '', args: []);
  }

  /// `جيجل`
  String get jijel {
    return Intl.message('جيجل', name: 'jijel', desc: '', args: []);
  }

  /// `الشقفة`
  String get chekfa {
    return Intl.message('الشقفة', name: 'chekfa', desc: '', args: []);
  }

  /// `جيملة`
  String get djimla {
    return Intl.message('جيملة', name: 'djimla', desc: '', args: []);
  }

  /// `العنصر`
  String get elAncer {
    return Intl.message('العنصر', name: 'elAncer', desc: '', args: []);
  }

  /// `العوانة`
  String get elAouana {
    return Intl.message('العوانة', name: 'elAouana', desc: '', args: []);
  }

  /// `الميلية`
  String get elMilia {
    return Intl.message('الميلية', name: 'elMilia', desc: '', args: []);
  }

  /// `السطارة`
  String get settara {
    return Intl.message('السطارة', name: 'settara', desc: '', args: []);
  }

  /// `سيدي معروف`
  String get sidiMaarouf {
    return Intl.message('سيدي معروف', name: 'sidiMaarouf', desc: '', args: []);
  }

  /// `الطاهير`
  String get taher {
    return Intl.message('الطاهير', name: 'taher', desc: '', args: []);
  }

  /// `تاكسنة`
  String get texenna {
    return Intl.message('تاكسنة', name: 'texenna', desc: '', args: []);
  }

  /// `زيامة منصورية`
  String get ziamaMansouriah {
    return Intl.message(
      'زيامة منصورية',
      name: 'ziamaMansouriah',
      desc: '',
      args: [],
    );
  }

  /// `سطيف`
  String get setif {
    return Intl.message('سطيف', name: 'setif', desc: '', args: []);
  }

  /// `عين أرنات`
  String get ainArnat {
    return Intl.message('عين أرنات', name: 'ainArnat', desc: '', args: []);
  }

  /// `عين آزال`
  String get ainAzel {
    return Intl.message('عين آزال', name: 'ainAzel', desc: '', args: []);
  }

  /// `عين الكبيرة`
  String get ainElKebira {
    return Intl.message('عين الكبيرة', name: 'ainElKebira', desc: '', args: []);
  }

  /// `عين ولمان`
  String get ainOulmene {
    return Intl.message('عين ولمان', name: 'ainOulmene', desc: '', args: []);
  }

  /// `عموشة`
  String get amoucha {
    return Intl.message('عموشة', name: 'amoucha', desc: '', args: []);
  }

  /// `بابور`
  String get babor {
    return Intl.message('بابور', name: 'babor', desc: '', args: []);
  }

  /// `بني عزيز`
  String get beniAziz {
    return Intl.message('بني عزيز', name: 'beniAziz', desc: '', args: []);
  }

  /// `بني ورتيلان`
  String get beniOurtilane {
    return Intl.message(
      'بني ورتيلان',
      name: 'beniOurtilane',
      desc: '',
      args: [],
    );
  }

  /// `بئر العرش`
  String get birElArch {
    return Intl.message('بئر العرش', name: 'birElArch', desc: '', args: []);
  }

  /// `بوعنداس`
  String get bouandas {
    return Intl.message('بوعنداس', name: 'bouandas', desc: '', args: []);
  }

  /// `بوقاعة`
  String get bougaa {
    return Intl.message('بوقاعة', name: 'bougaa', desc: '', args: []);
  }

  /// `جميلة`
  String get djemila {
    return Intl.message('جميلة', name: 'djemila', desc: '', args: []);
  }

  /// `العلمة`
  String get elEulma {
    return Intl.message('العلمة', name: 'elEulma', desc: '', args: []);
  }

  /// `قيجل`
  String get guidjel {
    return Intl.message('قيجل', name: 'guidjel', desc: '', args: []);
  }

  /// `قنزات`
  String get guenzet {
    return Intl.message('قنزات', name: 'guenzet', desc: '', args: []);
  }

  /// `حمام قرقور`
  String get hammamGuergour {
    return Intl.message(
      'حمام قرقور',
      name: 'hammamGuergour',
      desc: '',
      args: [],
    );
  }

  /// `حمام السخنة`
  String get hammamSoukhna {
    return Intl.message(
      'حمام السخنة',
      name: 'hammamSoukhna',
      desc: '',
      args: [],
    );
  }

  /// `ماوكلان`
  String get maoklane {
    return Intl.message('ماوكلان', name: 'maoklane', desc: '', args: []);
  }

  /// `صالح باي`
  String get salahBey {
    return Intl.message('صالح باي', name: 'salahBey', desc: '', args: []);
  }

  /// `سعيدة`
  String get saida {
    return Intl.message('سعيدة', name: 'saida', desc: '', args: []);
  }

  /// `عين الحجر`
  String get ainElHadjar {
    return Intl.message('عين الحجر', name: 'ainElHadjar', desc: '', args: []);
  }

  /// `سيدي بوبكر`
  String get sidiBoubekeur {
    return Intl.message(
      'سيدي بوبكر',
      name: 'sidiBoubekeur',
      desc: '',
      args: [],
    );
  }

  /// `الحساسنة`
  String get elHassasna {
    return Intl.message('الحساسنة', name: 'elHassasna', desc: '', args: []);
  }

  /// `أولاد إبراهيم`
  String get ouledBrahim {
    return Intl.message(
      'أولاد إبراهيم',
      name: 'ouledBrahim',
      desc: '',
      args: [],
    );
  }

  /// `يوب`
  String get youb {
    return Intl.message('يوب', name: 'youb', desc: '', args: []);
  }

  /// `سكيكدة`
  String get skikda {
    return Intl.message('سكيكدة', name: 'skikda', desc: '', args: []);
  }

  /// `عزابة`
  String get azzaba {
    return Intl.message('عزابة', name: 'azzaba', desc: '', args: []);
  }

  /// `عين قشرة`
  String get ainKechra {
    return Intl.message('عين قشرة', name: 'ainKechra', desc: '', args: []);
  }

  /// `بن عزوز`
  String get benAzzouz {
    return Intl.message('بن عزوز', name: 'benAzzouz', desc: '', args: []);
  }

  /// `القل`
  String get collo {
    return Intl.message('القل', name: 'collo', desc: '', args: []);
  }

  /// `الحدائق`
  String get elHadaiek {
    return Intl.message('الحدائق', name: 'elHadaiek', desc: '', args: []);
  }

  /// `الحروش`
  String get elHarrouch {
    return Intl.message('الحروش', name: 'elHarrouch', desc: '', args: []);
  }

  /// `أولاد عطية`
  String get ouledAttia {
    return Intl.message('أولاد عطية', name: 'ouledAttia', desc: '', args: []);
  }

  /// `أم الطوب`
  String get oumToub {
    return Intl.message('أم الطوب', name: 'oumToub', desc: '', args: []);
  }

  /// `رمضان جمال`
  String get ramdaneDjamel {
    return Intl.message(
      'رمضان جمال',
      name: 'ramdaneDjamel',
      desc: '',
      args: [],
    );
  }

  /// `سيدي مزغيش`
  String get sidiMezghiche {
    return Intl.message(
      'سيدي مزغيش',
      name: 'sidiMezghiche',
      desc: '',
      args: [],
    );
  }

  /// `تمالوس`
  String get tamalous {
    return Intl.message('تمالوس', name: 'tamalous', desc: '', args: []);
  }

  /// `الزيتونة`
  String get zitouna {
    return Intl.message('الزيتونة', name: 'zitouna', desc: '', args: []);
  }

  /// `سيدي بلعباس`
  String get sidiBelAbbes {
    return Intl.message(
      'سيدي بلعباس',
      name: 'sidiBelAbbes',
      desc: '',
      args: [],
    );
  }

  /// `عين البرد`
  String get ainElBerd {
    return Intl.message('عين البرد', name: 'ainElBerd', desc: '', args: []);
  }

  /// `بن باديس`
  String get benBadis {
    return Intl.message('بن باديس', name: 'benBadis', desc: '', args: []);
  }

  /// `مرحوم`
  String get marhoum {
    return Intl.message('مرحوم', name: 'marhoum', desc: '', args: []);
  }

  /// `مرين`
  String get merine {
    return Intl.message('مرين', name: 'merine', desc: '', args: []);
  }

  /// `مصطفى بن إبراهيم`
  String get mostefaBenBrahim {
    return Intl.message(
      'مصطفى بن إبراهيم',
      name: 'mostefaBenBrahim',
      desc: '',
      args: [],
    );
  }

  /// `مولاي سليسن`
  String get moulaySlissen {
    return Intl.message(
      'مولاي سليسن',
      name: 'moulaySlissen',
      desc: '',
      args: [],
    );
  }

  /// `رأس الماء`
  String get rasElMa {
    return Intl.message('رأس الماء', name: 'rasElMa', desc: '', args: []);
  }

  /// `سفيزف`
  String get sfisef {
    return Intl.message('سفيزف', name: 'sfisef', desc: '', args: []);
  }

  /// `سيدي علي بن يوب`
  String get sidiAliBenyoub {
    return Intl.message(
      'سيدي علي بن يوب',
      name: 'sidiAliBenyoub',
      desc: '',
      args: [],
    );
  }

  /// `سيدي علي بوسيدي`
  String get sidiAliBoussidi {
    return Intl.message(
      'سيدي علي بوسيدي',
      name: 'sidiAliBoussidi',
      desc: '',
      args: [],
    );
  }

  /// `سيدي لحسن`
  String get sidiLahcene {
    return Intl.message('سيدي لحسن', name: 'sidiLahcene', desc: '', args: []);
  }

  /// `تلاغ`
  String get telagh {
    return Intl.message('تلاغ', name: 'telagh', desc: '', args: []);
  }

  /// `تنيرة`
  String get tenira {
    return Intl.message('تنيرة', name: 'tenira', desc: '', args: []);
  }

  /// `تسالة`
  String get tessala {
    return Intl.message('تسالة', name: 'tessala', desc: '', args: []);
  }

  /// `عنابة`
  String get annaba {
    return Intl.message('عنابة', name: 'annaba', desc: '', args: []);
  }

  /// `عين الباردة`
  String get ainBerda {
    return Intl.message('عين الباردة', name: 'ainBerda', desc: '', args: []);
  }

  /// `الحجار`
  String get elHadjar {
    return Intl.message('الحجار', name: 'elHadjar', desc: '', args: []);
  }

  /// `برحال`
  String get berrahal {
    return Intl.message('برحال', name: 'berrahal', desc: '', args: []);
  }

  /// `شطايبي`
  String get chetaibi {
    return Intl.message('شطايبي', name: 'chetaibi', desc: '', args: []);
  }

  /// `البوني`
  String get elBouni {
    return Intl.message('البوني', name: 'elBouni', desc: '', args: []);
  }

  /// `قالمة`
  String get guelma {
    return Intl.message('قالمة', name: 'guelma', desc: '', args: []);
  }

  /// `عين مخلوف`
  String get ainMakhlouf {
    return Intl.message('عين مخلوف', name: 'ainMakhlouf', desc: '', args: []);
  }

  /// `بوشقوف`
  String get bouchegouf {
    return Intl.message('بوشقوف', name: 'bouchegouf', desc: '', args: []);
  }

  /// `قلعة بوصبع`
  String get guelaatBouSbaa {
    return Intl.message(
      'قلعة بوصبع',
      name: 'guelaatBouSbaa',
      desc: '',
      args: [],
    );
  }

  /// `حمام دباغ`
  String get hammamDebagh {
    return Intl.message('حمام دباغ', name: 'hammamDebagh', desc: '', args: []);
  }

  /// `حمام النبايل`
  String get hammamNBails {
    return Intl.message(
      'حمام النبايل',
      name: 'hammamNBails',
      desc: '',
      args: [],
    );
  }

  /// `هيليوبوليس`
  String get heliopolis {
    return Intl.message('هيليوبوليس', name: 'heliopolis', desc: '', args: []);
  }

  /// `هواري بومدين`
  String get houariBoumediene {
    return Intl.message(
      'هواري بومدين',
      name: 'houariBoumediene',
      desc: '',
      args: [],
    );
  }

  /// `خزارة`
  String get khezarra {
    return Intl.message('خزارة', name: 'khezarra', desc: '', args: []);
  }

  /// `وادي الزناتي`
  String get ouedZenati {
    return Intl.message('وادي الزناتي', name: 'ouedZenati', desc: '', args: []);
  }

  /// `قسنطينة`
  String get constantine {
    return Intl.message('قسنطينة', name: 'constantine', desc: '', args: []);
  }

  /// `الخروب`
  String get elKhroub {
    return Intl.message('الخروب', name: 'elKhroub', desc: '', args: []);
  }

  /// `عين عبيد`
  String get ainAbid {
    return Intl.message('عين عبيد', name: 'ainAbid', desc: '', args: []);
  }

  /// `زيغود يوسف`
  String get zighoudYoucef {
    return Intl.message(
      'زيغود يوسف',
      name: 'zighoudYoucef',
      desc: '',
      args: [],
    );
  }

  /// `حامة بوزيان`
  String get hammaBouziane {
    return Intl.message(
      'حامة بوزيان',
      name: 'hammaBouziane',
      desc: '',
      args: [],
    );
  }

  /// `ابن زياد`
  String get ibnZiad {
    return Intl.message('ابن زياد', name: 'ibnZiad', desc: '', args: []);
  }

  /// `المدية`
  String get medea {
    return Intl.message('المدية', name: 'medea', desc: '', args: []);
  }

  /// `عين بوسيف`
  String get ainBoucif {
    return Intl.message('عين بوسيف', name: 'ainBoucif', desc: '', args: []);
  }

  /// `عزيز`
  String get aziz {
    return Intl.message('عزيز', name: 'aziz', desc: '', args: []);
  }

  /// `بني سليمان`
  String get beniSlimane {
    return Intl.message('بني سليمان', name: 'beniSlimane', desc: '', args: []);
  }

  /// `البرواقية`
  String get berrouaghia {
    return Intl.message('البرواقية', name: 'berrouaghia', desc: '', args: []);
  }

  /// `شهبونية`
  String get chahbounia {
    return Intl.message('شهبونية', name: 'chahbounia', desc: '', args: []);
  }

  /// `شلالة العذاورة`
  String get chellalettElAdhaoura {
    return Intl.message(
      'شلالة العذاورة',
      name: 'chellalettElAdhaoura',
      desc: '',
      args: [],
    );
  }

  /// `العزيزية`
  String get elAzizia {
    return Intl.message('العزيزية', name: 'elAzizia', desc: '', args: []);
  }

  /// `القلب الكبير`
  String get elGuelbElKebir {
    return Intl.message(
      'القلب الكبير',
      name: 'elGuelbElKebir',
      desc: '',
      args: [],
    );
  }

  /// `العمارية`
  String get elOmaria {
    return Intl.message('العمارية', name: 'elOmaria', desc: '', args: []);
  }

  /// `قصر البخاري`
  String get ksarBoukhari {
    return Intl.message(
      'قصر البخاري',
      name: 'ksarBoukhari',
      desc: '',
      args: [],
    );
  }

  /// `وامري`
  String get ouamri {
    return Intl.message('وامري', name: 'ouamri', desc: '', args: []);
  }

  /// `أولاد عنتر`
  String get ouledAntar {
    return Intl.message('أولاد عنتر', name: 'ouledAntar', desc: '', args: []);
  }

  /// `وزرة`
  String get ouzera {
    return Intl.message('وزرة', name: 'ouzera', desc: '', args: []);
  }

  /// `السغوان`
  String get seghouane {
    return Intl.message('السغوان', name: 'seghouane', desc: '', args: []);
  }

  /// `سيدي نعمان`
  String get sidiNaamane {
    return Intl.message('سيدي نعمان', name: 'sidiNaamane', desc: '', args: []);
  }

  /// `سي المحجوب`
  String get siMahdjoub {
    return Intl.message('سي المحجوب', name: 'siMahdjoub', desc: '', args: []);
  }

  /// `السواقي`
  String get souagui {
    return Intl.message('السواقي', name: 'souagui', desc: '', args: []);
  }

  /// `تابلاط`
  String get tablat {
    return Intl.message('تابلاط', name: 'tablat', desc: '', args: []);
  }

  /// `مستغانم`
  String get mostaganem {
    return Intl.message('مستغانم', name: 'mostaganem', desc: '', args: []);
  }

  /// `عشعاشة`
  String get achaacha {
    return Intl.message('عشعاشة', name: 'achaacha', desc: '', args: []);
  }

  /// `عين نويسي`
  String get ainNouissi {
    return Intl.message('عين نويسي', name: 'ainNouissi', desc: '', args: []);
  }

  /// `عين تادلس`
  String get ainTadles {
    return Intl.message('عين تادلس', name: 'ainTadles', desc: '', args: []);
  }

  /// `بوقيراط`
  String get bouguirat {
    return Intl.message('بوقيراط', name: 'bouguirat', desc: '', args: []);
  }

  /// `حاسي مماش`
  String get hassiMameche {
    return Intl.message('حاسي مماش', name: 'hassiMameche', desc: '', args: []);
  }

  /// `خير الدين`
  String get kheireddine {
    return Intl.message('خير الدين', name: 'kheireddine', desc: '', args: []);
  }

  /// `ماسرة`
  String get mesra {
    return Intl.message('ماسرة', name: 'mesra', desc: '', args: []);
  }

  /// `سيدي علي`
  String get sidiAli {
    return Intl.message('سيدي علي', name: 'sidiAli', desc: '', args: []);
  }

  /// `سيدي لخضر`
  String get sidiLakhdar {
    return Intl.message('سيدي لخضر', name: 'sidiLakhdar', desc: '', args: []);
  }

  /// `المسيلة`
  String get mSila {
    return Intl.message('المسيلة', name: 'mSila', desc: '', args: []);
  }

  /// `حمام الضلعة`
  String get hammamDalaa {
    return Intl.message('حمام الضلعة', name: 'hammamDalaa', desc: '', args: []);
  }

  /// `أولاد دراج`
  String get ouledDerradj {
    return Intl.message('أولاد دراج', name: 'ouledDerradj', desc: '', args: []);
  }

  /// `سيدي عيسى`
  String get sidiAissa {
    return Intl.message('سيدي عيسى', name: 'sidiAissa', desc: '', args: []);
  }

  /// `عين الملح`
  String get ainElMelh {
    return Intl.message('عين الملح', name: 'ainElMelh', desc: '', args: []);
  }

  /// `بن سرور`
  String get benSrour {
    return Intl.message('بن سرور', name: 'benSrour', desc: '', args: []);
  }

  /// `بوسعادة`
  String get bouSaada {
    return Intl.message('بوسعادة', name: 'bouSaada', desc: '', args: []);
  }

  /// `أولاد سيدي إبراهيم`
  String get ouledSidiBrahim {
    return Intl.message(
      'أولاد سيدي إبراهيم',
      name: 'ouledSidiBrahim',
      desc: '',
      args: [],
    );
  }

  /// `سيدي عامر`
  String get sidiAmeur {
    return Intl.message('سيدي عامر', name: 'sidiAmeur', desc: '', args: []);
  }

  /// `مقرة`
  String get magra {
    return Intl.message('مقرة', name: 'magra', desc: '', args: []);
  }

  /// `شلال`
  String get chellal {
    return Intl.message('شلال', name: 'chellal', desc: '', args: []);
  }

  /// `خبانة`
  String get khoubana {
    return Intl.message('خبانة', name: 'khoubana', desc: '', args: []);
  }

  /// `مجدل`
  String get medjedel {
    return Intl.message('مجدل', name: 'medjedel', desc: '', args: []);
  }

  /// `عين الحجل`
  String get ainElHadjel {
    return Intl.message('عين الحجل', name: 'ainElHadjel', desc: '', args: []);
  }

  /// `جبل مساعد`
  String get djebelMessaad {
    return Intl.message('جبل مساعد', name: 'djebelMessaad', desc: '', args: []);
  }

  /// `معسكر`
  String get mascara {
    return Intl.message('معسكر', name: 'mascara', desc: '', args: []);
  }

  /// `عين فارس`
  String get ainFares {
    return Intl.message('عين فارس', name: 'ainFares', desc: '', args: []);
  }

  /// `عين فكان`
  String get ainFekan {
    return Intl.message('عين فكان', name: 'ainFekan', desc: '', args: []);
  }

  /// `عوف`
  String get aouf {
    return Intl.message('عوف', name: 'aouf', desc: '', args: []);
  }

  /// `بوحنيفية`
  String get bouHanifia {
    return Intl.message('بوحنيفية', name: 'bouHanifia', desc: '', args: []);
  }

  /// `البرج`
  String get elBordj {
    return Intl.message('البرج', name: 'elBordj', desc: '', args: []);
  }

  /// `غريس`
  String get ghriss {
    return Intl.message('غريس', name: 'ghriss', desc: '', args: []);
  }

  /// `الحشم`
  String get hachem {
    return Intl.message('الحشم', name: 'hachem', desc: '', args: []);
  }

  /// `المحمدية`
  String get mohammadia {
    return Intl.message('المحمدية', name: 'mohammadia', desc: '', args: []);
  }

  /// `عقاز`
  String get oggaz {
    return Intl.message('عقاز', name: 'oggaz', desc: '', args: []);
  }

  /// `وادي الأبطال`
  String get ouedElAbtal {
    return Intl.message(
      'وادي الأبطال',
      name: 'ouedElAbtal',
      desc: '',
      args: [],
    );
  }

  /// `وادي التاغية`
  String get ouedTaria {
    return Intl.message('وادي التاغية', name: 'ouedTaria', desc: '', args: []);
  }

  /// `سيق`
  String get sig {
    return Intl.message('سيق', name: 'sig', desc: '', args: []);
  }

  /// `تيغنيف`
  String get tighennif {
    return Intl.message('تيغنيف', name: 'tighennif', desc: '', args: []);
  }

  /// `تيزي`
  String get tizi {
    return Intl.message('تيزي', name: 'tizi', desc: '', args: []);
  }

  /// `زهانة`
  String get zahana {
    return Intl.message('زهانة', name: 'zahana', desc: '', args: []);
  }

  /// `ورقلة`
  String get ouargla {
    return Intl.message('ورقلة', name: 'ouargla', desc: '', args: []);
  }

  /// `البرمة`
  String get elBorma {
    return Intl.message('البرمة', name: 'elBorma', desc: '', args: []);
  }

  /// `حاسي مسعود`
  String get hassiMessaoud {
    return Intl.message(
      'حاسي مسعود',
      name: 'hassiMessaoud',
      desc: '',
      args: [],
    );
  }

  /// `نقوسة`
  String get nGoussa {
    return Intl.message('نقوسة', name: 'nGoussa', desc: '', args: []);
  }

  /// `سيدي خويلد`
  String get sidiKhouiled {
    return Intl.message('سيدي خويلد', name: 'sidiKhouiled', desc: '', args: []);
  }

  /// `وهران`
  String get oran {
    return Intl.message('وهران', name: 'oran', desc: '', args: []);
  }

  /// `عين الترك`
  String get ainElTurk {
    return Intl.message('عين الترك', name: 'ainElTurk', desc: '', args: []);
  }

  /// `أرزيو`
  String get arzew {
    return Intl.message('أرزيو', name: 'arzew', desc: '', args: []);
  }

  /// `بطيوة`
  String get bethioua {
    return Intl.message('بطيوة', name: 'bethioua', desc: '', args: []);
  }

  /// `السانية`
  String get esSenia {
    return Intl.message('السانية', name: 'esSenia', desc: '', args: []);
  }

  /// `بئر الجير`
  String get birElDjir {
    return Intl.message('بئر الجير', name: 'birElDjir', desc: '', args: []);
  }

  /// `بوتليليس`
  String get boutlelis {
    return Intl.message('بوتليليس', name: 'boutlelis', desc: '', args: []);
  }

  /// `وادي تليلات`
  String get ouedTlelat {
    return Intl.message('وادي تليلات', name: 'ouedTlelat', desc: '', args: []);
  }

  /// `قديل`
  String get gdyel {
    return Intl.message('قديل', name: 'gdyel', desc: '', args: []);
  }

  /// `البيض`
  String get elBayadh {
    return Intl.message('البيض', name: 'elBayadh', desc: '', args: []);
  }

  /// `رقاصة`
  String get rogassa {
    return Intl.message('رقاصة', name: 'rogassa', desc: '', args: []);
  }

  /// `بريزينة`
  String get brezina {
    return Intl.message('بريزينة', name: 'brezina', desc: '', args: []);
  }

  /// `الأبيض سيدي الشيخ`
  String get elAbiodhSidiCheikh {
    return Intl.message(
      'الأبيض سيدي الشيخ',
      name: 'elAbiodhSidiCheikh',
      desc: '',
      args: [],
    );
  }

  /// `بوقطب`
  String get bougtoub {
    return Intl.message('بوقطب', name: 'bougtoub', desc: '', args: []);
  }

  /// `شلالة`
  String get chellala {
    return Intl.message('شلالة', name: 'chellala', desc: '', args: []);
  }

  /// `بوسمغون`
  String get boussemghoun {
    return Intl.message('بوسمغون', name: 'boussemghoun', desc: '', args: []);
  }

  /// `بوعلام`
  String get boualem {
    return Intl.message('بوعلام', name: 'boualem', desc: '', args: []);
  }

  /// `إليزي`
  String get illizi {
    return Intl.message('إليزي', name: 'illizi', desc: '', args: []);
  }

  /// `عين أمناس`
  String get inAmenas {
    return Intl.message('عين أمناس', name: 'inAmenas', desc: '', args: []);
  }

  /// `برج بوعريريج`
  String get bordjBouArreridj {
    return Intl.message(
      'برج بوعريريج',
      name: 'bordjBouArreridj',
      desc: '',
      args: [],
    );
  }

  /// `عين تاغروت`
  String get ainTaghrout {
    return Intl.message('عين تاغروت', name: 'ainTaghrout', desc: '', args: []);
  }

  /// `رأس الوادي`
  String get rasElOued {
    return Intl.message('رأس الوادي', name: 'rasElOued', desc: '', args: []);
  }

  /// `برج الغدير`
  String get bordjGhedir {
    return Intl.message('برج الغدير', name: 'bordjGhedir', desc: '', args: []);
  }

  /// `بئر قاصد علي`
  String get birKasdali {
    return Intl.message('بئر قاصد علي', name: 'birKasdali', desc: '', args: []);
  }

  /// `الحمادية`
  String get elHamadia {
    return Intl.message('الحمادية', name: 'elHamadia', desc: '', args: []);
  }

  /// `مجانة`
  String get medjana {
    return Intl.message('مجانة', name: 'medjana', desc: '', args: []);
  }

  /// `برج زمورة`
  String get bordjZemoura {
    return Intl.message('برج زمورة', name: 'bordjZemoura', desc: '', args: []);
  }

  /// `جعافرة`
  String get djaafra {
    return Intl.message('جعافرة', name: 'djaafra', desc: '', args: []);
  }

  /// `بومرداس`
  String get boumerdes {
    return Intl.message('بومرداس', name: 'boumerdes', desc: '', args: []);
  }

  /// `بغلية`
  String get baghlia {
    return Intl.message('بغلية', name: 'baghlia', desc: '', args: []);
  }

  /// `بودواو`
  String get boudouaou {
    return Intl.message('بودواو', name: 'boudouaou', desc: '', args: []);
  }

  /// `برج منايل`
  String get bordjMenaiel {
    return Intl.message('برج منايل', name: 'bordjMenaiel', desc: '', args: []);
  }

  /// `دلس`
  String get dellys {
    return Intl.message('دلس', name: 'dellys', desc: '', args: []);
  }

  /// `خميس الخشنة`
  String get khemisElKechna {
    return Intl.message(
      'خميس الخشنة',
      name: 'khemisElKechna',
      desc: '',
      args: [],
    );
  }

  /// `يسر`
  String get isser {
    return Intl.message('يسر', name: 'isser', desc: '', args: []);
  }

  /// `الناصرية`
  String get naciria {
    return Intl.message('الناصرية', name: 'naciria', desc: '', args: []);
  }

  /// `الثنية`
  String get thenia {
    return Intl.message('الثنية', name: 'thenia', desc: '', args: []);
  }

  /// `الطارف`
  String get elTarf {
    return Intl.message('الطارف', name: 'elTarf', desc: '', args: []);
  }

  /// `القالة`
  String get elKala {
    return Intl.message('القالة', name: 'elKala', desc: '', args: []);
  }

  /// `بن مهيدي`
  String get benMhidi {
    return Intl.message('بن مهيدي', name: 'benMhidi', desc: '', args: []);
  }

  /// `البسباس`
  String get besbes {
    return Intl.message('البسباس', name: 'besbes', desc: '', args: []);
  }

  /// `الذرعان`
  String get drean {
    return Intl.message('الذرعان', name: 'drean', desc: '', args: []);
  }

  /// `بوحجار`
  String get bouhadjar {
    return Intl.message('بوحجار', name: 'bouhadjar', desc: '', args: []);
  }

  /// `بوثلجة`
  String get bouteldja {
    return Intl.message('بوثلجة', name: 'bouteldja', desc: '', args: []);
  }

  /// `تندوف`
  String get tindouf {
    return Intl.message('تندوف', name: 'tindouf', desc: '', args: []);
  }

  /// `تيسمسيلت`
  String get tissemsilt {
    return Intl.message('تيسمسيلت', name: 'tissemsilt', desc: '', args: []);
  }

  /// `عماري`
  String get ammari {
    return Intl.message('عماري', name: 'ammari', desc: '', args: []);
  }

  /// `برج بونعامة`
  String get bordjBouNaama {
    return Intl.message(
      'برج بونعامة',
      name: 'bordjBouNaama',
      desc: '',
      args: [],
    );
  }

  /// `برج الأمير عبد القادر`
  String get bordjElEmirAbdelkader {
    return Intl.message(
      'برج الأمير عبد القادر',
      name: 'bordjElEmirAbdelkader',
      desc: '',
      args: [],
    );
  }

  /// `خميستي`
  String get khemisti {
    return Intl.message('خميستي', name: 'khemisti', desc: '', args: []);
  }

  /// `لرجام`
  String get lardjem {
    return Intl.message('لرجام', name: 'lardjem', desc: '', args: []);
  }

  /// `الأزهرية`
  String get lazharia {
    return Intl.message('الأزهرية', name: 'lazharia', desc: '', args: []);
  }

  /// `ثنية الأحد`
  String get thenietElHad {
    return Intl.message('ثنية الأحد', name: 'thenietElHad', desc: '', args: []);
  }

  /// `الوادي`
  String get elOued {
    return Intl.message('الوادي', name: 'elOued', desc: '', args: []);
  }

  /// `البياضة`
  String get bayadha {
    return Intl.message('البياضة', name: 'bayadha', desc: '', args: []);
  }

  /// `الدبيلة`
  String get debila {
    return Intl.message('الدبيلة', name: 'debila', desc: '', args: []);
  }

  /// `قمار`
  String get guemar {
    return Intl.message('قمار', name: 'guemar', desc: '', args: []);
  }

  /// `حاسي خليفة`
  String get hassiKhalifa {
    return Intl.message('حاسي خليفة', name: 'hassiKhalifa', desc: '', args: []);
  }

  /// `المقرن`
  String get magrane {
    return Intl.message('المقرن', name: 'magrane', desc: '', args: []);
  }

  /// `اميه وانسة`
  String get mihOuensa {
    return Intl.message('اميه وانسة', name: 'mihOuensa', desc: '', args: []);
  }

  /// `الرقيبة`
  String get reguiba {
    return Intl.message('الرقيبة', name: 'reguiba', desc: '', args: []);
  }

  /// `الرباح`
  String get robbah {
    return Intl.message('الرباح', name: 'robbah', desc: '', args: []);
  }

  /// `الطالب العربي`
  String get talebLarbi {
    return Intl.message(
      'الطالب العربي',
      name: 'talebLarbi',
      desc: '',
      args: [],
    );
  }

  /// `خنشلة`
  String get khenchela {
    return Intl.message('خنشلة', name: 'khenchela', desc: '', args: []);
  }

  /// `بابار`
  String get babar {
    return Intl.message('بابار', name: 'babar', desc: '', args: []);
  }

  /// `بوحمامة`
  String get bouhmama {
    return Intl.message('بوحمامة', name: 'bouhmama', desc: '', args: []);
  }

  /// `ششار`
  String get chechar {
    return Intl.message('ششار', name: 'chechar', desc: '', args: []);
  }

  /// `الحامة`
  String get elHamma {
    return Intl.message('الحامة', name: 'elHamma', desc: '', args: []);
  }

  /// `قايس`
  String get kais {
    return Intl.message('قايس', name: 'kais', desc: '', args: []);
  }

  /// `أولاد رشاش`
  String get ouledRechache {
    return Intl.message(
      'أولاد رشاش',
      name: 'ouledRechache',
      desc: '',
      args: [],
    );
  }

  /// `عين الطويلة`
  String get ainTouila {
    return Intl.message('عين الطويلة', name: 'ainTouila', desc: '', args: []);
  }

  /// `سوق أهراس`
  String get soukAhras {
    return Intl.message('سوق أهراس', name: 'soukAhras', desc: '', args: []);
  }

  /// `بئر بوحوش`
  String get birBouHaouch {
    return Intl.message('بئر بوحوش', name: 'birBouHaouch', desc: '', args: []);
  }

  /// `الحدادة`
  String get heddada {
    return Intl.message('الحدادة', name: 'heddada', desc: '', args: []);
  }

  /// `مداوروش`
  String get mdaourouch {
    return Intl.message('مداوروش', name: 'mdaourouch', desc: '', args: []);
  }

  /// `المشروحة`
  String get mechroha {
    return Intl.message('المشروحة', name: 'mechroha', desc: '', args: []);
  }

  /// `المراهنة`
  String get merahna {
    return Intl.message('المراهنة', name: 'merahna', desc: '', args: []);
  }

  /// `أولاد إدريس`
  String get ouledDriss {
    return Intl.message('أولاد إدريس', name: 'ouledDriss', desc: '', args: []);
  }

  /// `أم العظايم`
  String get oumElAdhaim {
    return Intl.message('أم العظايم', name: 'oumElAdhaim', desc: '', args: []);
  }

  /// `سدراتة`
  String get sedrata {
    return Intl.message('سدراتة', name: 'sedrata', desc: '', args: []);
  }

  /// `تاورة`
  String get taoura {
    return Intl.message('تاورة', name: 'taoura', desc: '', args: []);
  }

  /// `تيبازة`
  String get tipaza {
    return Intl.message('تيبازة', name: 'tipaza', desc: '', args: []);
  }

  /// `أحمر العين`
  String get ahmarElAin {
    return Intl.message('أحمر العين', name: 'ahmarElAin', desc: '', args: []);
  }

  /// `بواسماعيل`
  String get bouIsmail {
    return Intl.message('بواسماعيل', name: 'bouIsmail', desc: '', args: []);
  }

  /// `شرشال`
  String get cherchell {
    return Intl.message('شرشال', name: 'cherchell', desc: '', args: []);
  }

  /// `الداموس`
  String get damous {
    return Intl.message('الداموس', name: 'damous', desc: '', args: []);
  }

  /// `فوكة`
  String get fouka {
    return Intl.message('فوكة', name: 'fouka', desc: '', args: []);
  }

  /// `قوراية`
  String get gouraya {
    return Intl.message('قوراية', name: 'gouraya', desc: '', args: []);
  }

  /// `حجوط`
  String get hadjout {
    return Intl.message('حجوط', name: 'hadjout', desc: '', args: []);
  }

  /// `القليعة`
  String get kolea {
    return Intl.message('القليعة', name: 'kolea', desc: '', args: []);
  }

  /// `سيدي عمار`
  String get sidiAmar {
    return Intl.message('سيدي عمار', name: 'sidiAmar', desc: '', args: []);
  }

  /// `ميلة`
  String get mila {
    return Intl.message('ميلة', name: 'mila', desc: '', args: []);
  }

  /// `شلغوم العيد`
  String get chelghoumLaid {
    return Intl.message(
      'شلغوم العيد',
      name: 'chelghoumLaid',
      desc: '',
      args: [],
    );
  }

  /// `فرجيوة`
  String get ferdjioua {
    return Intl.message('فرجيوة', name: 'ferdjioua', desc: '', args: []);
  }

  /// `قرارم قوقة`
  String get graremGouga {
    return Intl.message('قرارم قوقة', name: 'graremGouga', desc: '', args: []);
  }

  /// `واد النجاء`
  String get ouedEndja {
    return Intl.message('واد النجاء', name: 'ouedEndja', desc: '', args: []);
  }

  /// `الرواشد`
  String get rouached {
    return Intl.message('الرواشد', name: 'rouached', desc: '', args: []);
  }

  /// `ترعي باينان`
  String get terraiBainen {
    return Intl.message(
      'ترعي باينان',
      name: 'terraiBainen',
      desc: '',
      args: [],
    );
  }

  /// `تسدان حدادة`
  String get tassadaneHaddada {
    return Intl.message(
      'تسدان حدادة',
      name: 'tassadaneHaddada',
      desc: '',
      args: [],
    );
  }

  /// `عين البيضاء حريش`
  String get ainBeidaHarriche {
    return Intl.message(
      'عين البيضاء حريش',
      name: 'ainBeidaHarriche',
      desc: '',
      args: [],
    );
  }

  /// `سيدي مروان`
  String get sidiMerouane {
    return Intl.message('سيدي مروان', name: 'sidiMerouane', desc: '', args: []);
  }

  /// `تلاغمة`
  String get teleghma {
    return Intl.message('تلاغمة', name: 'teleghma', desc: '', args: []);
  }

  /// `بوحاتم`
  String get bouhatem {
    return Intl.message('بوحاتم', name: 'bouhatem', desc: '', args: []);
  }

  /// `تاجنانت`
  String get tadjenanet {
    return Intl.message('تاجنانت', name: 'tadjenanet', desc: '', args: []);
  }

  /// `عين الدفلى`
  String get ainDefla {
    return Intl.message('عين الدفلى', name: 'ainDefla', desc: '', args: []);
  }

  /// `عين الاشياخ`
  String get ainLechiekh {
    return Intl.message('عين الاشياخ', name: 'ainLechiekh', desc: '', args: []);
  }

  /// `بطحية`
  String get bathia {
    return Intl.message('بطحية', name: 'bathia', desc: '', args: []);
  }

  /// `برج الأمير خالد`
  String get bordjEmirKhaled {
    return Intl.message(
      'برج الأمير خالد',
      name: 'bordjEmirKhaled',
      desc: '',
      args: [],
    );
  }

  /// `بومدفع`
  String get boumedfaa {
    return Intl.message('بومدفع', name: 'boumedfaa', desc: '', args: []);
  }

  /// `جليدة`
  String get djelida {
    return Intl.message('جليدة', name: 'djelida', desc: '', args: []);
  }

  /// `جندل`
  String get djendel {
    return Intl.message('جندل', name: 'djendel', desc: '', args: []);
  }

  /// `العبادية`
  String get elAbadia {
    return Intl.message('العبادية', name: 'elAbadia', desc: '', args: []);
  }

  /// `العامرة`
  String get elAmra {
    return Intl.message('العامرة', name: 'elAmra', desc: '', args: []);
  }

  /// `العطاف`
  String get elAttaf {
    return Intl.message('العطاف', name: 'elAttaf', desc: '', args: []);
  }

  /// `حمام ريغة`
  String get hammamRigha {
    return Intl.message('حمام ريغة', name: 'hammamRigha', desc: '', args: []);
  }

  /// `خميس مليانة`
  String get khemisMiliana {
    return Intl.message(
      'خميس مليانة',
      name: 'khemisMiliana',
      desc: '',
      args: [],
    );
  }

  /// `مليانة`
  String get miliana {
    return Intl.message('مليانة', name: 'miliana', desc: '', args: []);
  }

  /// `الروينة`
  String get rouina {
    return Intl.message('الروينة', name: 'rouina', desc: '', args: []);
  }

  /// `النعامة`
  String get naama {
    return Intl.message('النعامة', name: 'naama', desc: '', args: []);
  }

  /// `عين الصفراء`
  String get ainSefra {
    return Intl.message('عين الصفراء', name: 'ainSefra', desc: '', args: []);
  }

  /// `عسلة`
  String get assela {
    return Intl.message('عسلة', name: 'assela', desc: '', args: []);
  }

  /// `مكمن بن عامر`
  String get makmanBenAmer {
    return Intl.message(
      'مكمن بن عامر',
      name: 'makmanBenAmer',
      desc: '',
      args: [],
    );
  }

  /// `المشرية`
  String get mecheria {
    return Intl.message('المشرية', name: 'mecheria', desc: '', args: []);
  }

  /// `مغرار`
  String get moghrar {
    return Intl.message('مغرار', name: 'moghrar', desc: '', args: []);
  }

  /// `صفيصيفة`
  String get sfissifa {
    return Intl.message('صفيصيفة', name: 'sfissifa', desc: '', args: []);
  }

  /// `عين الأربعاء`
  String get ainElArbaa {
    return Intl.message('عين الأربعاء', name: 'ainElArbaa', desc: '', args: []);
  }

  /// `عين الكيحل`
  String get ainKihal {
    return Intl.message('عين الكيحل', name: 'ainKihal', desc: '', args: []);
  }

  /// `عين تموشنت`
  String get ainTemouchent {
    return Intl.message(
      'عين تموشنت',
      name: 'ainTemouchent',
      desc: '',
      args: [],
    );
  }

  /// `بني صاف`
  String get beniSaf {
    return Intl.message('بني صاف', name: 'beniSaf', desc: '', args: []);
  }

  /// `العامرية`
  String get elAmria {
    return Intl.message('العامرية', name: 'elAmria', desc: '', args: []);
  }

  /// `المالح`
  String get elMalah {
    return Intl.message('المالح', name: 'elMalah', desc: '', args: []);
  }

  /// `حمام بوحجر`
  String get hammamBouHadjar {
    return Intl.message(
      'حمام بوحجر',
      name: 'hammamBouHadjar',
      desc: '',
      args: [],
    );
  }

  /// `أولحاسة الغرابة`
  String get oulhacaElGheraba {
    return Intl.message(
      'أولحاسة الغرابة',
      name: 'oulhacaElGheraba',
      desc: '',
      args: [],
    );
  }

  /// `غرداية`
  String get ghardaia {
    return Intl.message('غرداية', name: 'ghardaia', desc: '', args: []);
  }

  /// `المنيعة`
  String get elMeniaa {
    return Intl.message('المنيعة', name: 'elMeniaa', desc: '', args: []);
  }

  /// `متليلي`
  String get metlili {
    return Intl.message('متليلي', name: 'metlili', desc: '', args: []);
  }

  /// `بريان`
  String get berriane {
    return Intl.message('بريان', name: 'berriane', desc: '', args: []);
  }

  /// `ضاية بن ضحوة`
  String get daiaBenDahoua {
    return Intl.message(
      'ضاية بن ضحوة',
      name: 'daiaBenDahoua',
      desc: '',
      args: [],
    );
  }

  /// `منصورة`
  String get mansoura {
    return Intl.message('منصورة', name: 'mansoura', desc: '', args: []);
  }

  /// `زلفانة`
  String get zelfana {
    return Intl.message('زلفانة', name: 'zelfana', desc: '', args: []);
  }

  /// `القرارة`
  String get guerrara {
    return Intl.message('القرارة', name: 'guerrara', desc: '', args: []);
  }

  /// `بونورة`
  String get bounoura {
    return Intl.message('بونورة', name: 'bounoura', desc: '', args: []);
  }

  /// `عين طارق`
  String get ainTarek {
    return Intl.message('عين طارق', name: 'ainTarek', desc: '', args: []);
  }

  /// `عمي موسى`
  String get ammiMoussa {
    return Intl.message('عمي موسى', name: 'ammiMoussa', desc: '', args: []);
  }

  /// `جديوية`
  String get djidioua {
    return Intl.message('جديوية', name: 'djidioua', desc: '', args: []);
  }

  /// `الحمادنة`
  String get elHamadna {
    return Intl.message('الحمادنة', name: 'elHamadna', desc: '', args: []);
  }

  /// `المطمر`
  String get elMatmar {
    return Intl.message('المطمر', name: 'elMatmar', desc: '', args: []);
  }

  /// `مازونة`
  String get mazouna {
    return Intl.message('مازونة', name: 'mazouna', desc: '', args: []);
  }

  /// `منداس`
  String get mendes {
    return Intl.message('منداس', name: 'mendes', desc: '', args: []);
  }

  /// `وادي رهيو`
  String get ouedRhiou {
    return Intl.message('وادي رهيو', name: 'ouedRhiou', desc: '', args: []);
  }

  /// `الرمكة`
  String get ramka {
    return Intl.message('الرمكة', name: 'ramka', desc: '', args: []);
  }

  /// `غليزان`
  String get relizane {
    return Intl.message('غليزان', name: 'relizane', desc: '', args: []);
  }

  /// `سيدي امحمد بن علي`
  String get sidiMHamedBenAli {
    return Intl.message(
      'سيدي امحمد بن علي',
      name: 'sidiMHamedBenAli',
      desc: '',
      args: [],
    );
  }

  /// `يلل`
  String get yellel {
    return Intl.message('يلل', name: 'yellel', desc: '', args: []);
  }

  /// `زمورة`
  String get zemmora {
    return Intl.message('زمورة', name: 'zemmora', desc: '', args: []);
  }

  /// `تينركوك`
  String get tinerkouk {
    return Intl.message('تينركوك', name: 'tinerkouk', desc: '', args: []);
  }

  /// `شروين`
  String get charouine {
    return Intl.message('شروين', name: 'charouine', desc: '', args: []);
  }

  /// `برج باجي مختار`
  String get bordjBadjiMokhtar {
    return Intl.message(
      'برج باجي مختار',
      name: 'bordjBadjiMokhtar',
      desc: '',
      args: [],
    );
  }

  /// `أولاد جلال`
  String get ouledDjellal {
    return Intl.message('أولاد جلال', name: 'ouledDjellal', desc: '', args: []);
  }

  /// `كرزاز`
  String get kerzaz {
    return Intl.message('كرزاز', name: 'kerzaz', desc: '', args: []);
  }

  /// `تيمودي`
  String get timoudi {
    return Intl.message('تيمودي', name: 'timoudi', desc: '', args: []);
  }

  /// `عين صالح`
  String get inSalah {
    return Intl.message('عين صالح', name: 'inSalah', desc: '', args: []);
  }

  /// `عين قزام`
  String get inGuezzam {
    return Intl.message('عين قزام', name: 'inGuezzam', desc: '', args: []);
  }

  /// `تين زواتين`
  String get tinZaouatine {
    return Intl.message('تين زواتين', name: 'tinZaouatine', desc: '', args: []);
  }

  /// `الحجيرة`
  String get elHadjira {
    return Intl.message('الحجيرة', name: 'elHadjira', desc: '', args: []);
  }

  /// `المقارين`
  String get megarine {
    return Intl.message('المقارين', name: 'megarine', desc: '', args: []);
  }

  /// `الطيبات`
  String get taibet {
    return Intl.message('الطيبات', name: 'taibet', desc: '', args: []);
  }

  /// `تماسين`
  String get tamacine {
    return Intl.message('تماسين', name: 'tamacine', desc: '', args: []);
  }

  /// `تقرت`
  String get touggourt {
    return Intl.message('تقرت', name: 'touggourt', desc: '', args: []);
  }

  /// `جانت`
  String get djanet {
    return Intl.message('جانت', name: 'djanet', desc: '', args: []);
  }

  /// `المغير`
  String get elMGhair {
    return Intl.message('المغير', name: 'elMGhair', desc: '', args: []);
  }

  /// `جامعة`
  String get djamaa {
    return Intl.message('جامعة', name: 'djamaa', desc: '', args: []);
  }

  /// `يرجى اختيار `
  String get pleaseSelectLabel {
    return Intl.message(
      'يرجى اختيار ',
      name: 'pleaseSelectLabel',
      desc: '',
      args: [],
    );
  }

  /// `الإنجليزية`
  String get languageEnglish {
    return Intl.message(
      'الإنجليزية',
      name: 'languageEnglish',
      desc: '',
      args: [],
    );
  }

  /// `الفرنسية`
  String get languageFrench {
    return Intl.message('الفرنسية', name: 'languageFrench', desc: '', args: []);
  }

  /// `العربية`
  String get languageArabic {
    return Intl.message('العربية', name: 'languageArabic', desc: '', args: []);
  }

  /// `الرجاء إدخال جميع المعلومات`
  String get please_enter_all_info {
    return Intl.message(
      'الرجاء إدخال جميع المعلومات',
      name: 'please_enter_all_info',
      desc: '',
      args: [],
    );
  }

  /// `صيغة البريد الإلكتروني غير صحيحة`
  String get invalid_email_format {
    return Intl.message(
      'صيغة البريد الإلكتروني غير صحيحة',
      name: 'invalid_email_format',
      desc: '',
      args: [],
    );
  }

  /// `صيغة رقم الهاتف غير صحيحة`
  String get invalid_phone_format {
    return Intl.message(
      'صيغة رقم الهاتف غير صحيحة',
      name: 'invalid_phone_format',
      desc: '',
      args: [],
    );
  }

  /// `كلمة المرور يجب أن تكون 6 أحرف على الأقل`
  String get password_min_length {
    return Intl.message(
      'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
      name: 'password_min_length',
      desc: '',
      args: [],
    );
  }

  /// `كلمة المرور غير متطابقة`
  String get passwords_do_not_match {
    return Intl.message(
      'كلمة المرور غير متطابقة',
      name: 'passwords_do_not_match',
      desc: '',
      args: [],
    );
  }

  /// `  !  تبقّى القليل   `
  String get verify_email_title {
    return Intl.message(
      '  !  تبقّى القليل   ',
      name: 'verify_email_title',
      desc: '',
      args: [],
    );
  }

  /// `يرجى التحقق من بريدك الإلكتروني بالنقر على الرابط المرسل إلى`
  String get verify_email_desc {
    return Intl.message(
      'يرجى التحقق من بريدك الإلكتروني بالنقر على الرابط المرسل إلى',
      name: 'verify_email_desc',
      desc: '',
      args: [],
    );
  }

  /// ` ⏳...جاري تسجيل الدخول`
  String get logging_in {
    return Intl.message(
      ' ⏳...جاري تسجيل الدخول',
      name: 'logging_in',
      desc: '',
      args: [],
    );
  }

  /// `❌ لا يوجد مستخدم بهذا البريد الإلكتروني`
  String get error_no_user_found {
    return Intl.message(
      '❌ لا يوجد مستخدم بهذا البريد الإلكتروني',
      name: 'error_no_user_found',
      desc: '',
      args: [],
    );
  }

  /// `🔑 كلمة المرور غير صحيحة`
  String get error_wrong_password {
    return Intl.message(
      '🔑 كلمة المرور غير صحيحة',
      name: 'error_wrong_password',
      desc: '',
      args: [],
    );
  }

  /// `⚠️ حدث خطأ أثناء تسجيل الدخول`
  String get error_login_failed {
    return Intl.message(
      '⚠️ حدث خطأ أثناء تسجيل الدخول',
      name: 'error_login_failed',
      desc: '',
      args: [],
    );
  }

  /// `⚠️ حدث خطأ غير متوقع`
  String get error_unexpected {
    return Intl.message(
      '⚠️ حدث خطأ غير متوقع',
      name: 'error_unexpected',
      desc: '',
      args: [],
    );
  }

  /// `📧 البريد الإلكتروني مسجل مسبقًا`
  String get error_email_already_used {
    return Intl.message(
      '📧 البريد الإلكتروني مسجل مسبقًا',
      name: 'error_email_already_used',
      desc: '',
      args: [],
    );
  }

  /// `⚠️ حدث خطأ غير متوقع أثناء إنشاء الحساب`
  String get error_signup_unexpected {
    return Intl.message(
      '⚠️ حدث خطأ غير متوقع أثناء إنشاء الحساب',
      name: 'error_signup_unexpected',
      desc: '',
      args: [],
    );
  }

  /// `⚠️ حدث خطأ غير متوقع`
  String get error_generic_unexpected {
    return Intl.message(
      '⚠️ حدث خطأ غير متوقع',
      name: 'error_generic_unexpected',
      desc: '',
      args: [],
    );
  }

  /// `❌ يرجى إدخال البريد الإلكتروني`
  String get error_enter_email {
    return Intl.message(
      '❌ يرجى إدخال البريد الإلكتروني',
      name: 'error_enter_email',
      desc: '',
      args: [],
    );
  }

  /// `❌ لا يوجد حساب مرتبط بهذا البريد الإلكتروني`
  String get error_no_account_for_email {
    return Intl.message(
      '❌ لا يوجد حساب مرتبط بهذا البريد الإلكتروني',
      name: 'error_no_account_for_email',
      desc: '',
      args: [],
    );
  }

  /// `⚠️ حدث خطأ أثناء إرسال طلب إعادة تعيين كلمة المرور`
  String get error_reset_password_failed {
    return Intl.message(
      '⚠️ حدث خطأ أثناء إرسال طلب إعادة تعيين كلمة المرور',
      name: 'error_reset_password_failed',
      desc: '',
      args: [],
    );
  }

  /// `🔑 إعادة تعيين كلمة المرور`
  String get password_reset_title {
    return Intl.message(
      '🔑 إعادة تعيين كلمة المرور',
      name: 'password_reset_title',
      desc: '',
      args: [],
    );
  }

  /// `📩 تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني`
  String get password_reset_success_desc {
    return Intl.message(
      '📩 تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني',
      name: 'password_reset_success_desc',
      desc: '',
      args: [],
    );
  }

  /// `⚠️ حدث خطأ أثناء تسجيل الدخول باستخدام جوجل`
  String get error_google_signin {
    return Intl.message(
      '⚠️ حدث خطأ أثناء تسجيل الدخول باستخدام جوجل',
      name: 'error_google_signin',
      desc: '',
      args: [],
    );
  }

  /// `تأكيد الحذف`
  String get confirm_delete_title {
    return Intl.message(
      'تأكيد الحذف',
      name: 'confirm_delete_title',
      desc: '',
      args: [],
    );
  }

  /// `هل أنت متأكد أنك تريد حذف هذا التعليق؟`
  String get confirm_delete_message {
    return Intl.message(
      'هل أنت متأكد أنك تريد حذف هذا التعليق؟',
      name: 'confirm_delete_message',
      desc: '',
      args: [],
    );
  }

  /// `حذف`
  String get delete {
    return Intl.message('حذف', name: 'delete', desc: '', args: []);
  }

  /// `🎉 تهانينا`
  String get congratulations {
    return Intl.message(
      '🎉 تهانينا',
      name: 'congratulations',
      desc: '',
      args: [],
    );
  }

  /// `واو! أنت الآن`
  String get successMessage {
    return Intl.message(
      'واو! أنت الآن',
      name: 'successMessage',
      desc: '',
      args: [],
    );
  }

  /// `⚠️ تنبيه!`
  String get alert {
    return Intl.message('⚠️ تنبيه!', name: 'alert', desc: '', args: []);
  }

  /// `يجب عليك تحميل بعض الملفات .. بعد التحقق ستتلقى إشعارًا`
  String get alertMessage {
    return Intl.message(
      'يجب عليك تحميل بعض الملفات .. بعد التحقق ستتلقى إشعارًا',
      name: 'alertMessage',
      desc: '',
      args: [],
    );
  }

  /// `تبديل الحساب النشط`
  String get switchActiveProfile {
    return Intl.message(
      'تبديل الحساب النشط',
      name: 'switchActiveProfile',
      desc: '',
      args: [],
    );
  }

  /// `تنبيه`
  String get alertTitle {
    return Intl.message('تنبيه', name: 'alertTitle', desc: '', args: []);
  }

  /// `هذا النوع غير مفعل من طرف الإدارة`
  String get alertContent {
    return Intl.message(
      'هذا النوع غير مفعل من طرف الإدارة',
      name: 'alertContent',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
