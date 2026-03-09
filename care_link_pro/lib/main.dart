import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

      // ✅ Apply Poppins font globally
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primaryTextTheme: GoogleFonts.poppinsTextTheme(),
      ),

      // 👇 Navigator observer
      navigatorObservers: [routeObserver],

      home: FutureBuilder<String?>(
        future: SharedPreferencesHelper.getString('login_successfull'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for async data
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (snapshot.hasData && snapshot.data != null) {
              // ✅ User already logged in → go to Dashboard
              return const Dashboard(userDetails: null);
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