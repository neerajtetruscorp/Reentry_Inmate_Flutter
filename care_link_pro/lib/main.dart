import 'package:flutter/material.dart';
import 'screens/login.dart';
import '../helper/helper.dart';
import 'screens/dashboard.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<String?>(
        future: SharedPreferencesHelper.getString('login_successfull'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the future to complete, you can show a loading indicator or splash screen.
            return CircularProgressIndicator();
          } else {
            // Once the future completes, check if the token is retrieved.
            if (snapshot.hasData && snapshot.data != null) {
              // Token is retrieved, navigate to DashboardPage
              return Dashboard();
            } else {
              // Token is not retrieved, navigate to LoginPage
              return Login();
            }
          }
        },
      ),
    );
  }
}
