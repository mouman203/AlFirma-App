
import 'package:agriplant/pages/auth/LoginPage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class auth {

  
  // التحقق من صحة البريد الإلكتروني
  bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool isPhoneValid(String email) {
    RegExp phoneRegex = RegExp(r'^[0-9]{9,10}$');
    return phoneRegex.hasMatch(email);
  }

  // التحقق من صحة كلمة المرور
  bool isPasswordValid(String password) {
    return password.length >= 6;
  }

  // عرض رسالة الخطأ
  void showErrorDialog(BuildContext context, String s) {
    AwesomeDialog(
    context: context,
    dialogType: DialogType.error,
    animType: AnimType.scale,
    title: 'خطأ',
    desc: s,
    btnOkOnPress: () {},
  ).show();
  }

  // التحقق إذا كان البريد الإلكتروني موجودًا في Firebase
Future<bool> checkIfEmailExists(String email) async {
  try {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: email)
        .get();

    return query.docs.isNotEmpty; // ✅ إرجاع `true` إذا وجدنا مستخدمًا بهذا البريد
  } catch (e) {
    print("⚠️ خطأ أثناء التحقق من البريد الإلكتروني: $e");
    return false; // ❌ في حالة وجود خطأ، نعيد `false` لتجنب تعطل التطبيق
  }
}


  // sign upالتحقق من إدخال البيانات
 bool checkInfo_signup(BuildContext context,String first_name,String last_name,String phone, String email,bool verify, String password,String confirmationpassword) {

  if (email.isEmpty || password.isEmpty || first_name.isEmpty || last_name.isEmpty || phone.isEmpty) {
    showErrorDialog(context, 'الرجاء إدخال جميع المعلومات.');
    return false;
  }

  if (!isEmailValid(email)) {
    showErrorDialog(context, 'صيغة البريد الإلكتروني غير صحيحة.');
    return false;
  }
  if (!isPhoneValid(phone)) {
    showErrorDialog(context, 'صيغة رقم الهاتف غير صحيحة.');
    return false;
  }

  if (!isPasswordValid(password)) {
    showErrorDialog(context, 'كلمة المرور يجب أن تكون 6 أحرف على الأقل.');
    return false;
  }
  if(password != confirmationpassword){
    showErrorDialog(context, 'كلمة المرور غير متطابقة.');
    return false;
  }

  return true;
}
 
 
 // sign in التحقق من إدخال البيانات
 bool checkInfo_login(BuildContext context, String email, String password) {
  if (email.isEmpty || password.isEmpty) {
    showErrorDialog(context, 'الرجاء إدخال جميع المعلومات.');
    return false;
  }
  if (!isEmailValid(email)) {
    showErrorDialog(context, 'صيغة البريد الإلكتروني غير صحيحة.');
    return false;
  }
  if (!isPasswordValid(password)) {
    showErrorDialog(context, 'كلمة المرور يجب أن تكون 6 أحرف على الأقل.');
    return false;
  }

  return true;
 }

  // التحقق من البريد الإلكتروني وتحديث Firestore
  bool Verificationemail(BuildContext context, User user){
    // ✅ التحقق مما إذا كان البريد الإلكتروني غير مؤكد
    if (!user.emailVerified) {
       user.sendEmailVerification(); // إعادة إرسال رسالة التحقق
       FirebaseAuth.instance.signOut(); // تسجيل خروج المستخدم
      showErrorDialog(
          context,
          "يرجى تأكيد بريدك الإلكتروني قبل تسجيل الدخول.\n"
          "تم إرسال رسالة تحقق جديدة إلى ${user.email}.");
      return false; // ⛔️ منع المستخدم من المتابعة
    }

    // ✅ تحديث Firestore إذا تم التحقق من البريد الإلكتروني
     FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
      'Verify': true, // تحديث حالة التحقق
       // ✅ السماح للمستخدم بالمتابعة
    });
    return true;
  }

  // تسجيل الدخول مع إدارة الأخطاء

 Future<void> signInWithHandling({
  required BuildContext context,
  required String email,
  required String password,
  required Widget homePage,
}) async {
  if (!checkInfo_login(context, email, password)) return;
  try {
    showLoadingDialog(context); // عرض مؤشر الانتظار
    // تسجيل الدخول
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    User? user = userCredential.user;
    if (user != null) {
      if(!Verificationemail(context, user)){
        return;
      } 
    }
    // ✅ تحديث كلمة المرور في Firestore
      await FirebaseFirestore.instance.collection('Users').doc(user!.uid).update({
        'password': password, // تحديث كلمة المرور الجديدة
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('lastPageIndex', 0);
      Navigator.pop(context);
    // ✅ التوجيه إلى الصفحة الرئيسية
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => homePage),
    );
  } on FirebaseAuthException catch (e) {
    if (!await checkIfEmailExists(email)) {
      showErrorDialog(context, '❌ لا يوجد مستخدم بهذا البريد الإلكتروني.');
    } else if (e.code == 'wrong-password') {
      showErrorDialog(context, '🔑 كلمة المرور غير صحيحة.');
    } else {
      showErrorDialog(context, '⚠️ حدث خطأ أثناء تسجيل الدخول.');
    }
  } catch (e) {
    showErrorDialog(context, '⚠️ حدث خطأ غير متوقع.');
  }
}

  // تسجيل الخروج
  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      showErrorDialog(context, 'حدث خطأ غير متوقع.');
    }
  }

  // إنشاء حساب مع إدارة الأخطاء

Future<void> signUp({
  required BuildContext context,
  required String first_name,
  required String last_name,
  required String phone,
  required String email,
  required String password,
  required String confirmationpassword,
  required String wilaya,
  required bool verify,
  required Widget destPage,
}) async {
  if (!checkInfo_signup(context,first_name,last_name,phone,email,verify, password,confirmationpassword)) return;

    try {
      showLoadingDialog(context); // عرض مؤشر الانتظار
      // Step 0: Check if email exists
      if (await checkIfEmailExists(email)) {
        // User exists
        print("User with email $email exists in Firestore.");
        showErrorDialog(context, 'البريد الإلكتروني مسجل مسبقًا.');
      } else {
        // User does not exist
        print("User with email $email does not exist in Firestore.");

        // Step 1: Create user in Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // Send verification email
        User? user = userCredential.user;
        if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();
        }
        String uid = userCredential.user!.uid;

        // Step 2: Add user details to Firestore
        await FirebaseFirestore.instance.collection('Users').doc(uid).set({
          'first_name': first_name,
          'last_name': last_name,
          'phone': phone,
          'email': email,
          'password': password,
          'createdAt': FieldValue.serverTimestamp(),
          'Verify': verify,
        });
        print('User registered successfully');
        Navigator.pop(context); // إغلاق مؤشر التحميل
        // ✅ التوجيه إلى الصفحة المقصودة
        Navigator.of(context).pushNamed("login_page");
        AwesomeDialog(
                context: context,
                dialogType: DialogType.info,
                animType: AnimType.scale,
                title: 'Noiiiiice',
                desc:
                    'know you are one of us .. \n last step : plz go to verify your e-mail')
            .show();
        print("Verification E-mail sent successfully");
      }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      showErrorDialog(context, 'البريد الإلكتروني مسجل مسبقًا.');
    } else {
      showErrorDialog(context, 'حدث خطأ غير متوقع أثناء إنشاء الحساب.');
    }
  } catch (e) {
    showErrorDialog(context, 'حدث خطأ غير متوقع.');
  }
}


//resete password

Future<void> resetPassword({
  required BuildContext context,
  required String email,
}) async {
  if (email.isEmpty) {
    showErrorDialog(context, "❌ يرجى إدخال البريد الإلكتروني.");
    return;
  }

  if (!await checkIfEmailExists(email)) { // ✅ تم تصحيح الشرط
    showErrorDialog(context, "❌ لا يوجد حساب مرتبط بهذا البريد الإلكتروني.");
    return;
  }
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: "🔑 إعادة تعيين كلمة المرور",
      desc: "📩 تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني.",
      btnOkOnPress: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()), // 🔥 تحسين إضافي
        );
      },
    ).show();
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      showErrorDialog(context, "❌ لا يوجد حساب مرتبط بهذا البريد الإلكتروني.");
    } else {
      showErrorDialog(context, "⚠️ حدث خطأ أثناء إرسال طلب إعادة تعيين كلمة المرور.");
    }
  } catch (e) {
    showErrorDialog(context, "⚠️ حدث خطأ غير متوقع.");
  }
}

//sign in with google

Future<void> signInWithGoogle(BuildContext context, Widget homePage) async {
  try {
    showLoadingDialog(context); // عرض مؤشر الانتظار

    final GoogleSignIn googleSignIn = GoogleSignIn();
    
    // تأكد من تسجيل الخروج قبل محاولة تسجيل الدخول
    await googleSignIn.signOut();  
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    
    if (googleUser == null) {
      Navigator.pop(context); // إغلاق مؤشر التحميل
      print("❌ تم إلغاء تسجيل الدخول");
      return;
    }
    
    print("✅ تسجيل الدخول ناجح: ${googleUser.email}");
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final OAuthCredential googleCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // تسجيل الدخول إلى Firebase
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(googleCredential);
    User? firebaseUser = userCredential.user;

    if (firebaseUser != null) {
      // تقسيم الاسم إلى اسم أول واسم أخير
      List<String> nameParts = googleUser.displayName?.split(" ") ?? ["", ""];
      String firstName = nameParts.isNotEmpty ? nameParts[0] : "";
      String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";

      // مرجع إلى Firestore
      final userRef = FirebaseFirestore.instance.collection("Users").doc(firebaseUser.uid);

      // حفظ أو تحديث بيانات المستخدم في Firestore
      await userRef.set({
        "email": firebaseUser.email,
        "verify": true,
        "first_name": firstName,
        "last_name": lastName,
        "phone": firebaseUser.phoneNumber ?? "",
        "password": "", // يجب أن يضبط المستخدم كلمة المرور يدويًا إذا لزم الأمر
        "created_at": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // ✅ دمج البيانات بدلاً من استبدالها بالكامل
    }

    Navigator.pop(context); // إغلاق مؤشر التحميل

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastPageIndex', 0);
    // الانتقال إلى الصفحة الرئيسية
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => homePage),
    );
  } catch (e) {
    Navigator.pop(context); // تأكد من إغلاق التحميل قبل إظهار الخطأ
    print("⚠️ خطأ أثناء تسجيل الدخول باستخدام Google: $e");
    showErrorDialog(context, "⚠️ حدث خطأ أثناء تسجيل الدخول بواسطة Google.");
  }
}
// عرض مؤشر التحميل
void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // منع الإغلاق أثناء التحميل
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white, // لون الخلفية
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // تدوير الحواف
        child: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("جاري تسجيل الدخول...", style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    },
  );
}




}