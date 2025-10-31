import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Import custom helper and network utilities
import '../helper/helper.dart';
import '../helper/network/network_manager.dart';
import '../models/login.dart';

// Import the Dashboard Screen (navigated after successful login)
import 'dashboard.dart';

/// Primary theme color (used throughout UI)
const Color kPrimaryBlue = Color(0xFF1976D2);

/// Base API endpoints for different user types
const String _fnfLoginUrl = "http://dev-reentry.tetrus.dev/core/mobile/account/fnf/login";
const String _participantLoginUrl = "http://dev-reentry.tetrus.dev/core/mobile/account/inmate/login";

/// The root entry point of the Flutter app.
/// Sets the system UI theme and runs the [MyApp] widget.
void main() {
  // Ensure top status bar icons are dark for better contrast
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

///
/// Root widget for the entire app.
///
/// Defines global theme, color scheme, and base screen ([Login]).
///
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareLink Sign In',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryBlue,
        colorScheme: ColorScheme.light(primary: kPrimaryBlue),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const Login(),
    );
  }
}

///
/// Main Login Screen for CareLink.
///
/// This screen allows two types of users to log in:
/// - Participant
/// - Family/Friends (FnF)
///
/// Features:
/// - Username & Password input
/// - Role selection toggle
/// - "Remember Me" checkbox
/// - "Forgot Password" link
/// - Error dialogs for invalid login attempts
/// - API integration with NetworkManager
/// - Navigation to [Dashboard] on success
///
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  /// Controllers for capturing input values.
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// Tracks which type of user is currently selected.
  String _userType = 'Participant';

  /// Local state variables for UI interactivity.
  bool _rememberMe = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // 🧩 UI HELPER METHODS
  // ===========================================================================

  /// Displays a popup dialog showing an error message.
  /// Called when login fails due to validation or API error.
  void _showErrorPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  /// Handles the login API call based on user type.
  ///
  /// Steps:
  /// 1. Validates that both username and password are entered.
  /// 2. Builds the correct request body based on user type.
  /// 3. Calls `NetworkManager.post` with login credentials.
  /// 4. Saves session info if login is successful.
  /// 5. Displays popup and debug logs if login fails.
  Future<void> _signIn() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorPopup('Please enter both username and password.');
      return;
    }

    setState(() => _isLoading = true);

    String url;
    Map<String, dynamic> loginBody;

    // Determine API endpoint & body structure
    if (_userType == 'Participant') {
      url = _participantLoginUrl;
      loginBody = {
        "login": _usernameController.text,
        "password": _passwordController.text,
        "accept": true,
      };
    } else {
      url = _fnfLoginUrl;
      loginBody = {
        "username": _usernameController.text,
        "password": _passwordController.text,
      };
    }

    // Perform POST request
    final result = await NetworkManager.post(url, loginBody);

    if (mounted) {
      setState(() => _isLoading = false);

      if (result.isSuccess) {

        var loginDetails = LoginDetails.fromJson(result.data);

        SharedPreferencesHelper.saveString('token',loginDetails.idToken);
        SharedPreferencesHelper.saveString('refresh_token',loginDetails.refreshToken);

        print(loginDetails.idToken);

        // Login successful — navigate to Dashboard
        print(result.data.toString());
        print('✅ Login Successful! Navigating to Dashboard...');
        SharedPreferencesHelper.saveString('login_successfull', _usernameController.text);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(loginDetails: loginDetails),
          ),
        );
      } else {
        // Handle structured or unstructured error responses
        String message;
        if (result.error is String) {
          message = result.error as String;
        } else if (result.error is Map) {
          final errorMap = result.error as Map;
          String? extractedMessage = errorMap['message']?.toString();

          if (extractedMessage == null && errorMap['errors'] is List) {
            extractedMessage = (errorMap['errors'] as List).join(', ');
          }

          message = extractedMessage ?? 'Login failed with status: ${result.status}';
        } else {
          message = result.error?.toString() ?? 'Unknown login error occurred.';
        }

        _showErrorPopup(message);
        print('❌ Login Failed: $message');
      }
    }
  }

  // ===========================================================================
  // 🧱 WIDGET BUILDERS
  // ===========================================================================

  /// Builds the entire login screen layout.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildSettingsIcon(),
              const SizedBox(height: 48),
              _buildLogoAndTitle(),
              const SizedBox(height: 32),
              _buildRoleSelection(),
              const SizedBox(height: 32),
              _buildUsernameField(),
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 16),
              _buildOptionsRow(),
              const SizedBox(height: 32),
              _buildSignInButton(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildFooter(context),
    );
  }

  /// Builds the top-right settings icon (currently a placeholder).
  Widget _buildSettingsIcon() {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: const Icon(Icons.settings_outlined, color: Colors.grey, size: 28),
        onPressed: () {
          // TODO: Add Settings navigation in future release
        },
      ),
    );
  }

  /// Builds the app logo and screen title ("CareLink" + "Sign in to your Account").
  Widget _buildLogoAndTitle() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.link, color: kPrimaryBlue, size: 28),
            const SizedBox(width: 2),
            Icon(Icons.favorite, color: Colors.red.shade700, size: 20),
            const SizedBox(width: 4),
            const Text(
              'CareLink',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Sign in to your Account',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
      ],
    );
  }

  /// Builds a toggle row with radio buttons for selecting user type.
  Widget _buildRoleSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildRoleRadio('Participant'),
        const SizedBox(width: 24),
        _buildRoleRadio('Family/Friends'),
      ],
    );
  }

  /// Creates an individual radio button for [title].
  Widget _buildRoleRadio(String title) {
    return InkWell(
      onTap: () => setState(() => _userType = title),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: title,
            groupValue: _userType,
            onChanged: (String? value) => setState(() => _userType = value ?? 'Participant'),
            activeColor: kPrimaryBlue,
          ),
          Text(title, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  /// Text field for entering username/login ID.
  Widget _buildUsernameField() {
    return TextField(
      controller: _usernameController,
      decoration: InputDecoration(
        labelText: 'Username',
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      ),
    );
  }

  /// Text field for entering password, with toggle visibility button.
  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black54,
          ),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
      ),
    );
  }

  /// Builds the row containing the "Remember Me" checkbox and "Forgot Password" link.
  Widget _buildOptionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (bool? value) => setState(() => _rememberMe = value ?? false),
                activeColor: kPrimaryBlue,
              ),
            ),
            const SizedBox(width: 8),
            const Text('Remember Me', style: TextStyle(fontSize: 14)),
          ],
        ),
        TextButton(
          onPressed: () {
            // TODO: Implement forgot password navigation
          },
          child: const Text(
            'Forgot Password?',
            style: TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
      ],
    );
  }

  /// Builds the primary "Sign In" button.
  /// Triggers the [_signIn] method when pressed.
  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _signIn,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryBlue,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 0,
      ),
      child: _isLoading
          ? const SizedBox(
        height: 24.0,
        width: 24.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 2.5,
        ),
      )
          : const Text(
        'Sign in',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  /// Builds footer with signup link displayed at the bottom of the login page.
  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Don't have an account?",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement signup navigation
            },
            child: const Text(
              'Signup',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kPrimaryBlue),
            ),
          ),
        ],
      ),
    );
  }
}
