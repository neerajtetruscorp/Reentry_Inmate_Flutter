import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/dashboard.dart';
import 'helper/helper.dart'; // ✅ fixed path

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareLink Pro',
      debugShowCheckedModeBanner: false,

      // 👇 Add navigatorObservers here — at MaterialApp level
      navigatorObservers: [routeObserver],

      home: FutureBuilder<String?>(
        future: SharedPreferencesHelper.getString('login_successfull'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for async data
            return const Center(child: CircularProgressIndicator());
          } else {
            // After the future completes
            if (snapshot.hasData && snapshot.data != null) {
              // ✅ User already logged in → go to Dashboard
              return const Dashboard(loginDetails: null);
            } else {
              // 🚪 No saved login → go to Login screen
              return const Login();
            }
          }
        },
      ),
    );
  }
}
