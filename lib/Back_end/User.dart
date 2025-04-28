import 'package:agriplant/Back_end/Products/Product.dart';
import 'package:agriplant/Back_end/Products/ProductAgri.dart';
import 'package:agriplant/Back_end/Products/ProductElev.dart';
import 'package:agriplant/Back_end/ServicesB/Service.dart';
import 'package:agriplant/Front_end/Authentication/LoginPage.dart';
import 'package:agriplant/Front_end/Authentication/ProfilePicturePage.dart';
import 'package:agriplant/Front_end/Profile/Edit_profile_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Users {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //continue as guest
  Future<void> signInAnonymously(BuildContext context, Widget homePage) async {
    try {
      await _auth.signInAnonymously();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => homePage),
      );
    } catch (e) {
      print('Error during anonymous sign-in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: const Text('Failed to continue as guest')),
      );
    }
  }

//to verify user is a guest
  static bool isGuestUser() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null && user.isAnonymous;
  }

  // التحقق من صحة البريد الإلكتروني
  bool isEmailValid(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
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

      return query
          .docs.isNotEmpty; // ✅ إرجاع `true` إذا وجدنا مستخدمًا بهذا البريد
    } catch (e) {
      print("⚠️ خطأ أثناء التحقق من البريد الإلكتروني: $e");
      return false; // ❌ في حالة وجود خطأ، نعيد `false` لتجنب تعطل التطبيق
    }
  }

  // sign upالتحقق من إدخال البيانات
  bool checkInfo_signup(
      BuildContext context,
      String first_name,
      String last_name,
      String phone,
      String email,
      bool verify,
      String password,
      String confirmationpassword) {
    if (email.isEmpty ||
        password.isEmpty ||
        first_name.isEmpty ||
        last_name.isEmpty ||
        phone.isEmpty) {
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
    if (password != confirmationpassword) {
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
  bool Verificationemail(BuildContext context, User user) {
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

// عرض مؤشر التحميل
  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // منع الإغلاق أثناء التحميل
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white, // لون الخلفية
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)), // تدوير الحواف
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

  // تسجيل الدخول مع إدارة الأخطاء

  Future<void> signInWithHandling({
    required BuildContext context,
    required String email,
    required String password,
    required Widget homePage,
  }) async {
    if (!checkInfo_login(context, email, password)) return;
    try {
      showLoadingDialog(context);
      // عرض مؤشر الانتظار
      // تسجيل الدخول
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        if (!Verificationemail(context, user)) {
          return;
        }
      }
      // ✅ تحديث كلمة المرور في Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .update({
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
        Navigator.popUntil(context, (route) => route.isFirst);
        showErrorDialog(context, '❌ لا يوجد مستخدم بهذا البريد الإلكتروني.');
      } else if (e.code == 'wrong-password') {
        Navigator.popUntil(context, (route) => route.isFirst);
        showErrorDialog(context, '🔑 كلمة المرور غير صحيحة.');
      } else {
        Navigator.popUntil(context, (route) => route.isFirst);
        showErrorDialog(context, '⚠️ حدث خطأ أثناء تسجيل الدخول.');
      }
    } catch (e) {
      Navigator.popUntil(context, (route) => route.isFirst);
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
    required String daira,
    required bool verify,
  }) async {
    if (!checkInfo_signup(context, first_name, last_name, phone, email, verify,
        password, confirmationpassword)) {
      return;
    }

    try {
      print("🔄 Attempting to close dialog...");
      // showLoadingDialog(context); // عرض مؤشر الانتظار
      showLoadingDialog(context);

      if (await checkIfEmailExists(email)) {
        // User exists
        print("User with email $email exists in Firestore.");
        Navigator.pop(context);
        showErrorDialog(context, 'البريد الإلكتروني مسجل مسبقًا.');
        return;
      } else {
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
          'photo': "",
          'following': [],
          'followers': [],
          'email': email,
          'password': password,
          'userType': {},
          'activeType': 'Client',
          'createdAt': FieldValue.serverTimestamp(),
          'Verify': verify,
          'wilaya': wilaya,
          'daira': daira,
        });
        print('User registered successfully');
        Navigator.pop(context);

        // ✅ Navigate to the profile picture page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ProfilePicturePage(userId: uid),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Navigator.pop(context);
        showErrorDialog(context, 'البريد الإلكتروني مسجل مسبقًا.');
      } else {
        Navigator.pop(context);
        showErrorDialog(context, 'حدث خطأ غير متوقع أثناء إنشاء الحساب.');
      }
    } catch (e) {
      Navigator.pop(context);
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

    if (!await checkIfEmailExists(email)) {
      // ✅ تم تصحيح الشرط
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
            MaterialPageRoute(
                builder: (context) => const LoginPage()), // 🔥 تحسين إضافي
          );
        },
      ).show();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showErrorDialog(
            context, "❌ لا يوجد حساب مرتبط بهذا البريد الإلكتروني.");
      } else {
        showErrorDialog(
            context, "⚠️ حدث خطأ أثناء إرسال طلب إعادة تعيين كلمة المرور.");
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
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // تسجيل الدخول إلى Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(googleCredential);
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // مرجع إلى Firestore
        final userRef = FirebaseFirestore.instance
            .collection("Users")
            .doc(firebaseUser.uid);

        // التحقق مما إذا كان المستخدم موجود مسبقًا
        final doc = await userRef.get();

        if (!doc.exists) {
          // تقسيم الاسم إلى اسم أول واسم أخير
          List<String> nameParts =
              googleUser.displayName?.split(" ") ?? ["", ""];
          String firstName = nameParts.isNotEmpty ? nameParts[0] : "";
          String lastName =
              nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";

          // حفظ بيانات المستخدم الجديدة فقط إذا لم تكن موجودة
          await userRef.set({
            "email": firebaseUser.email,
            "Verify": false,
            "first_name": firstName,
            "last_name": lastName,
            "phone": firebaseUser.phoneNumber ?? "",
            "password": "signed with google",
            "photo": firebaseUser.photoURL ?? "",
            "userType": {},
            'activeType': 'Client',
            "following": [],
            "followers": [],
            "wilaya": '',
            "daira": '',
            "created_at": FieldValue.serverTimestamp(),
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => EditProfilePage(frompage: 'login')),
          );
        } else {
          print(" المستخدم موجود مسبقًا ${doc.get('Verify')}");
          if (doc.get('Verify') == false) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => EditProfilePage(frompage: 'login')),
            );
          } else {
            Navigator.pop(context); // إغلاق مؤشر التحميل

            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setInt('lastPageIndex', 0);

            // الانتقال إلى الصفحة الرئيسية
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => homePage),
            );
          }
        }
      }
    } catch (e) {
      Navigator.pop(context); // تأكد من إغلاق التحميل قبل إظهار الخطأ
      print("⚠️ خطأ أثناء تسجيل الدخول باستخدام Google: $e");
      showErrorDialog(context, "⚠️ حدث خطأ أثناء تسجيل الدخول بواسطة Google.");
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      List<Product> allProducts = [];

      // جلب منتجات الزراعة
      QuerySnapshot agricolSnapshot = await FirebaseFirestore.instance
          .collection('Products')
          .doc('Agricol_products')
          .collection('Agricol_products')
          .get();

      List<Product> agricolProducts = agricolSnapshot.docs.map((doc) {
        return Productagri.fromFirestore(doc);
      }).toList();
      allProducts.addAll(agricolProducts);

      // جلب منتجات المربين
      QuerySnapshot eleveurSnapshot = await FirebaseFirestore.instance
          .collection('Products')
          .doc('Eleveur_products')
          .collection('Eleveur_products')
          .get();

      List<Product> eleveurProducts = eleveurSnapshot.docs.map((doc) {
        return ProductElev.fromFirestore(doc);
      }).toList();

      allProducts.addAll(eleveurProducts);

      // تصفية المنتجات بناءً على الاسم
      List<Product> matchedProducts = allProducts
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return matchedProducts;
    } catch (e) {
      print("❌ حدث خطأ أثناء البحث: $e");
      return [];
    }
  }

  void likeItem(dynamic item) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "guest";

    String collection;
    String docPath;

    if (item is Product) {
      collection = item.typeProduct == "AgricolProduct"
          ? "Agricol_products"
          : "Eleveur_products";
      docPath = "Products";
    } else if (item is Service) {
      collection = item.typeService;
      docPath = "Services";
    } else {
      print("❌ Unknown item type");
      return;
    }

    DocumentReference ref = FirebaseFirestore.instance
        .collection(docPath)
        .doc(collection)
        .collection(collection)
        .doc(item.id);

    try {
      DocumentSnapshot doc = await ref.get();
      if (doc.exists) {
        List<String> likedUsers = List<String>.from(doc.get("liked") ?? []);

        if (likedUsers.contains(userId)) {
          await ref.update({
            'liked': FieldValue.arrayRemove([userId])
          });
          print("👎 Removed like from item ${item.id}");
        } else {
          await ref.update({
            'liked': FieldValue.arrayUnion([userId]),
            'disliked': FieldValue.arrayRemove([userId]),
          });
          print("👍 Liked item ${item.id}");
        }
      }
    } catch (e) {
      print("❌ Failed to like item: $e");
    }
  }

  void dislikeItem(dynamic item) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "guest";

    String collection;
    String docPath;

    if (item is Product) {
      collection = item.typeProduct == "AgricolProduct"
          ? "Agricol_products"
          : "Eleveur_products";
      docPath = "Products";
    } else if (item is Service) {
      collection = item.typeService;
      docPath = "Services";
    } else {
      print("❌ Unknown item type");
      return;
    }

    DocumentReference ref = FirebaseFirestore.instance
        .collection(docPath)
        .doc(collection)
        .collection(collection)
        .doc(item.id);

    try {
      DocumentSnapshot doc = await ref.get();
      if (doc.exists) {
        List<String> dislikedUsers =
            List<String>.from(doc.get("disliked") ?? []);
        if (dislikedUsers.contains(userId)) {
          await ref.update({
            'disliked': FieldValue.arrayRemove([userId])
          });
          print("👎 Removed dislike from item ${item.id}");
        } else {
          await ref.update({
            'disliked': FieldValue.arrayUnion([userId]),
            'liked': FieldValue.arrayRemove([userId]),
          });
          print("👎 Disliked item ${item.id}");
        }
      }
    } catch (e) {
      print("❌ Failed to dislike item: $e");
    }
  }

  Future<void> addComment(
    String itemId,
    String userId,
    String text,
    dynamic item, // Product or Service
  ) async {
    try {
      String docPath;
      String rootCollection;

      // Determine whether it's a Product or a Service
      if (item is Product) {
        switch (item.typeProduct) {
          case "AgricolProduct":
            docPath = "Agricol_products";
            break;
          case "EleveurProduct":
            docPath = "Eleveur_products";
            break;
          default:
            throw Exception("❌ Unknown product type: ${item.typeProduct}");
        }
        rootCollection = "Products";
      } else if (item is Service) {
        switch (item.typeService) {
          case "Transportation":
            docPath = "Transportation";
            break;
          case "Expertise":
            docPath = "Expertise";
            break;
          case "Repairs":
            docPath = "Repairs";
            break;
          default:
            throw Exception("❌ Unknown service type: ${item.typeService}");
        }
        rootCollection = "Services";
      } else {
        throw Exception("❌ Unknown item type!");
      }

      // Firestore document reference
      DocumentReference ref = FirebaseFirestore.instance
          .collection(rootCollection)
          .doc(docPath)
          .collection(docPath)
          .doc(itemId);

      // Create a new comment map
      Map<String, String> newComment = {
        "userId": userId,
        "text": text,
      };

      // Check if document exists
      DocumentSnapshot docSnapshot = await ref.get();

      if (!docSnapshot.exists) {
        // If the document does not exist, create it and add the comment
        await ref.set({
          "comments": [
            newComment
          ] // Initialize the comments field with the first comment
        });
        print("✅ Document created and comment added successfully.");
      } else {
        // If the document exists, update the comments array
        await ref.update({
          "comments": FieldValue.arrayUnion([newComment]),
        });
        print("✅ Comment added successfully.");
      }
    } catch (e) {
      print("⚠️ Error adding comment: $e");
    }
  }

  Future<void> deleteComment(
    String itemId,
    String userId,
    String text,
    dynamic item, // Product or Service
  ) async {
    try {
      String docPath;
      String rootCollection;

      if (item is Product) {
        switch (item.typeProduct) {
          case "AgricolProduct":
            docPath = "Agricol_products";
            break;
          case "EleveurProduct":
            docPath = "Eleveur_products";
            break;
          default:
            throw Exception("❌ نوع منتوج غير معروف: ${item.typeProduct}");
        }
        rootCollection = "Products";
      } else if (item is Service) {
        switch (item.typeService) {
          case "Transportation":
            docPath = "Transportation";
            break;
          case "Expertise":
            docPath = "Expertise";
            break;
          case "Repairs":
            docPath = "Repairs";
            break;
          default:
            throw Exception("❌ نوع الخدمة غير معروف: ${item.typeService}");
        }
        rootCollection = "Services";
      } else {
        throw Exception("❌ العنصر غير معروف!");
      }

      DocumentReference ref = FirebaseFirestore.instance
          .collection(rootCollection)
          .doc(docPath)
          .collection(docPath)
          .doc(itemId);

      await ref.update({
        'comments': FieldValue.arrayRemove([
          {'userId': userId, 'text': text}
        ]),
      });

      print("✅ تم حذف التعليق بنجاح.");
    } catch (e) {
      print("⚠️ خطأ أثناء حذف التعليق: $e");
    }
  }

  void showDeleteConfirmationDialog(
    BuildContext context, {
    required String itemId,
    required String userId,
    required String text,
    required dynamic item, // Product or Service
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("تأكيد الحذف"),
          content: const Text("هل أنت متأكد أنك تريد حذف هذا التعليق؟"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("إلغاء", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                deleteComment(
                  itemId,
                  userId,
                  text,
                  item,
                );
                Navigator.of(context).pop();
              },
              child: const Text("حذف", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
