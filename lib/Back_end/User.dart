import 'package:agriplant/Back_end/Products.dart';
import 'package:agriplant/Front_end/Authentication/LoginPage.dart';
import 'package:agriplant/Front_end/Authentication/ProfilePicturePage.dart';
import 'package:agriplant/Front_end/Profile/Edit_profile_page.dart';
import 'package:agriplant/generated/l10n.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Users {
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

  bool checkInfo_signup(
    BuildContext context,
    String first_name,
    String last_name,
    String phone,
    String email,
    bool verify,
    String password,
    String confirmationpassword,
  ) {
    if (email.isEmpty ||
        password.isEmpty ||
        first_name.isEmpty ||
        last_name.isEmpty ||
        phone.isEmpty) {
      showErrorDialog(context, S.of(context).please_enter_all_info);
      return false;
    }

    if (!isEmailValid(email)) {
      showErrorDialog(context, S.of(context).invalid_email_format);
      return false;
    }
    if (!isPhoneValid(phone)) {
      showErrorDialog(context, S.of(context).invalid_phone_format);
      return false;
    }

    if (!isPasswordValid(password)) {
      showErrorDialog(context, S.of(context).password_min_length);
      return false;
    }
    if (password != confirmationpassword) {
      showErrorDialog(context, S.of(context).passwords_do_not_match);
      return false;
    }

    return true;
  }

  bool checkInfo_login(BuildContext context, String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      showErrorDialog(context, S.of(context).please_enter_all_info);
      return false;
    }
    if (!isEmailValid(email)) {
      showErrorDialog(context, S.of(context).invalid_email_format);
      return false;
    }
    if (!isPasswordValid(password)) {
      showErrorDialog(context, S.of(context).password_min_length);
      return false;
    }

    return true;
  }

  static Future<bool> checkEmailVerification(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      if (!user.emailVerified) {
        await user.sendEmailVerification();

        await AwesomeDialog(
          context: context,
          dialogBackgroundColor:
              Theme.of(context).colorScheme.secondaryContainer,
          animType: AnimType.scale,
          // Remove dialogType
          customHeader: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 55,
            child: Icon(
              Icons.info_outline,
              color: Color.fromARGB(255, 247, 234, 117),
              size: 80,
            ),
          ),
          title: S.of(context).verify_email_title,
          titleTextStyle: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black),

          desc:
              '${S.of(context).verify_email_desc} ${user.email}\n\n${S.of(context).after_verification_login}',
          descTextStyle: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black),
          btnOkOnPress: () {},
          btnOkText: S.of(context).ok,
          buttonsTextStyle: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black),
          btnOkColor: Color.fromARGB(255, 247, 234, 117),
        ).show();

        FirebaseAuth.instance.signOut();
        return false;
      }

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .update({'Verify': true});

      return true;
    }

    return false;
  }

// عرض مؤشر التحميل
  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // منع الإغلاق أثناء التحميل
      builder: (context) {
        return Dialog(
          backgroundColor:
              Theme.of(context).colorScheme.secondaryContainer, // لون الخلفية
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)), // تدوير الحواف
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 20),
                Text(S.of(context).logging_in,
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> signInWithHandling({
    required BuildContext context,
    required String email,
    required String password,
    required Widget homePage,
  }) async {
    if (!checkInfo_login(context, email, password)) return;

    try {
      showLoadingDialog(context); // عرض مؤشر الانتظار

      // ✅ Delete anonymous user before creating a new one
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && currentUser.isAnonymous) {
        try {
          await currentUser.delete();
          print("✅ Anonymous user deleted before sign-up.");
        } catch (e) {
          print("⚠️ Failed to delete anonymous user: $e");
        }
      }

      // تسجيل الدخول
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        // التحقق من البريد الإلكتروني
        bool isEmailVerified = await checkEmailVerification(context);
        if (!isEmailVerified) {
          return; // إذا لم يتم التحقق من البريد الإلكتروني، التوقف هنا
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
      Navigator.popUntil(context, (route) => route.isFirst);

      if (!await checkIfEmailExists(email)) {
        showErrorDialog(context, S.of(context).error_no_user_found);
      } else if (e.code == 'wrong-password') {
        showErrorDialog(context, S.of(context).error_wrong_password);
      } else {
        showErrorDialog(context, S.of(context).error_login_failed);
      }
    } catch (e) {
      Navigator.popUntil(context, (route) => route.isFirst);
      showErrorDialog(context, S.of(context).error_unexpected);
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
      showLoadingDialog(context);

      if (await checkIfEmailExists(email)) {
        // User exists
        print("User with email already exists in Firestore.");
        Navigator.pop(context);
        showErrorDialog(context, S.of(context).error_email_already_used);
        return;
      } else {
        // ✅ Delete anonymous user before creating a new one
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null && currentUser.isAnonymous) {
          try {
            await currentUser.delete();
            print("✅ Anonymous user deleted before sign-up.");
          } catch (e) {
            print("⚠️ Failed to delete anonymous user: $e");
          }
        }

        // Step 1: Create user in Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // Do NOT send verification email here. Already handled in ProfilePicturePage
        String uid = userCredential.user!.uid;

        //get the token
        final token = await FirebaseMessaging.instance.getToken();

        // Step 2: Add user details to Firestore
        await FirebaseFirestore.instance.collection('Users').doc(uid).set({
          'first_name': first_name,
          'last_name': last_name,
          'phone': phone,
          'fcmToken': token,
          'photo': "",
          'following': [],
          'followers': [],
          'email': email,
          'password': password,
          'userType': {},
          'activeType': 'عميل',
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
      Navigator.pop(context);
      if (e.code == 'email-already-in-use') {
        showErrorDialog(context, S.of(context).error_email_already_used);
      } else {
        showErrorDialog(context, S.of(context).error_signup_unexpected);
      }
    } catch (e) {
      Navigator.pop(context);
      showErrorDialog(context, S.of(context).error_generic_unexpected);
    }
  }

//resete password

  Future<void> resetPassword({
    required BuildContext context,
    required String email,
  }) async {
    if (email.isEmpty) {
      showErrorDialog(context, S.of(context).error_enter_email);
      return;
    }
    if (!await checkIfEmailExists(email)) {
      showErrorDialog(context, S.of(context).error_no_account_for_email);
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: S.of(context).password_reset_title,
        desc: S.of(context).password_reset_success_desc,
        btnOkOnPress: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(frompage: 'ProfilPicture'),
            ),
          );
        },
      ).show();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showErrorDialog(context, S.of(context).error_no_account_for_email);
      } else {
        showErrorDialog(context, S.of(context).error_reset_password_failed);
      }
    } catch (e) {
      showErrorDialog(context, S.of(context).error_generic_unexpected);
    }
  }

//sign in with google

  Future<void> signInWithGoogle(BuildContext context, Widget homePage) async {
    try {
      showLoadingDialog(context); // Show loading indicator

      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Ensure user is logged out before trying to sign in
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        Navigator.pop(context); // Close loading indicator
        print("❌ User canceled the sign-in");
        return;
      }

      print("✅ Google Sign-In successful: ${googleUser.email}");
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with Google credentials
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(googleCredential);
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Reference to Firestore
        final userRef = FirebaseFirestore.instance
            .collection("Users")
            .doc(firebaseUser.uid);

        // Check if the user already exists
        final doc = await userRef.get();

        if (!doc.exists) {
          // Split name into first and last name
          List<String> nameParts =
              googleUser.displayName?.split(" ") ?? ["", ""];
          String firstName = nameParts.isNotEmpty ? nameParts[0] : "";
          String lastName =
              nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";
          final token = await FirebaseMessaging.instance.getToken();

          // Save new user data if not already present
          await userRef.set({
            "email": firebaseUser.email,
            "Verify": false,
            "first_name": firstName,
            "last_name": lastName,
            "phone": firebaseUser.phoneNumber ?? "",
            "password": "Signed with Google",
            "photo": firebaseUser.photoURL ?? "",
            "fcmToken": token,
            "userType": {},
            'activeType': 'عميل',
            "following": [],
            "followers": [],
            "wilaya": '',
            "daira": '',
            "created_at": FieldValue.serverTimestamp(),
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const EditProfilePage(frompage: 'login')),
          );
        } else {
          print("User already exists: ${doc.get('Verify')}");
          if (doc.get('Verify') == false) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const EditProfilePage(frompage: 'login')),
            );
          } else {
            Navigator.pop(context); // Close loading indicator

            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setInt('lastPageIndex', 0);

            // Navigate to home page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => homePage),
            );
          }
        }
      }
    } catch (e) {
      Navigator.pop(
          context); // Ensure the loading indicator is closed before showing the error
      print("⚠️ Error during Google sign-in: $e");
      showErrorDialog(context, S.of(context).error_google_signin);
    }
  }

  Future<List<Products>> searchProducts(String query) async {
    try {
      List<Products> allProducts = [];

      // جلب منتجات الزراعة
      QuerySnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('item')
          .doc('Products')
          .collection('Products')
          .get();

      List<Products> agricolProducts = productSnapshot.docs.map((doc) {
        return Products.fromFirestore(doc);
      }).toList();
      allProducts.addAll(agricolProducts);
      // تصفية المنتجات بناءً على الاسم
      List<Products> matchedProducts = allProducts
          .where((product) =>
              product.product!.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return matchedProducts;
    } catch (e) {
      print("❌ حدث خطأ أثناء البحث: $e");
      return [];
    }
  }

  void likeItem(Products item) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "guest";

    String docPath;

    if (item.SP == "Product") {
      docPath = "Products";
    } else if (item.SP == "Service") {
      docPath = "Services";
    } else {
      print("❌ Unknown item type");
      return;
    }

    DocumentReference ref = FirebaseFirestore.instance
        .collection("item")
        .doc(docPath)
        .collection(docPath)
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

  void dislikeItem(Products item) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "guest";

    String docPath;

    if (item.SP == "Product") {
      docPath = "Products";
    } else if (item.SP == "Service") {
      docPath = "Services";
    } else {
      print("❌ Unknown item type");
      return;
    }

    DocumentReference ref = FirebaseFirestore.instance
        .collection("item")
        .doc(docPath)
        .collection(docPath)
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
    Products item, // Product or Service
  ) async {
    try {
      String docPath;

      // Determine whether it's a Product or a Service
      if (item.SP == "Product") {
        docPath = "Products";
      } else if (item.SP == "Service") {
        docPath = "Services";
      } else {
        throw Exception("❌ Unknown item type!");
      }

      // Firestore document reference
      DocumentReference ref = FirebaseFirestore.instance
          .collection("item")
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
  dynamic item,
) async {
  try {
    String docPath;

    if (item.SP == "Product") {
      docPath = "Products";
    } else if (item.SP == "Service") {
      docPath = "Services";
    } else {
      throw Exception("❌ Unknown item type!");
    }

    DocumentReference ref = FirebaseFirestore.instance
        .collection("item")
        .doc(docPath)
        .collection(docPath)
        .doc(itemId);

    DocumentSnapshot snapshot = await ref.get();

    if (!snapshot.exists) {
      print("❌ المستند غير موجود.");
      return;
    }

    List<dynamic> comments = List.from(snapshot.get('comments') ?? []);

    final commentToDelete = comments.firstWhere(
      (comment) =>
          comment['userId'] == userId &&
          comment['text'] == text,
      orElse: () => null,
    );

    if (commentToDelete != null) {
      await ref.update({
        'comments': FieldValue.arrayRemove([commentToDelete]),
      });
      print("✅ تم حذف التعليق بنجاح.");
    } else {
      print("❌ لم يتم العثور على التعليق.");
    }
  } catch (e) {
    print("⚠️ خطأ أثناء حذف التعليق: $e");
  }
}

  void showDeleteConfirmationDialog(
    BuildContext context, {
    required String itemId,
    required String userId,
    required String text,
    required Products item,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(S.of(context).confirm_delete_title),
          content: Text(S.of(context).confirm_delete_message),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF90D5AE)
                            : const Color(0xFF256C4C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    S.of(context).cancel,
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    print("showDeleteConfirmationDialog :");
                    print(itemId);
                    print(userId);
                    print(text);
                    print(item);
                    deleteComment(itemId, userId, text, item);
                    Navigator.of(context).pop();
                  },
                  child: Text(S.of(context).delete,
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
