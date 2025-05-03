import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAppLifecycleObserver extends StatefulWidget {
  final Widget child;
  const MyAppLifecycleObserver({Key? key, required this.child}) : super(key: key);

  @override
  _MyAppLifecycleObserverState createState() => _MyAppLifecycleObserverState();
}

class _MyAppLifecycleObserverState extends State<MyAppLifecycleObserver> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Adding observer to listen to lifecycle changes
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Removing observer when the widget is disposed
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached || state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      final user = FirebaseAuth.instance.currentUser;
      
      if (user != null && user.isAnonymous) {
        try {
          await user.delete(); // Delete anonymous user when app goes to background or is closed
          debugPrint("Guest (anonymous) user deleted.");
        } catch (e) {
          debugPrint("Error deleting guest user: $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
