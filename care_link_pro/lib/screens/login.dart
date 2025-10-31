import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Import the NetworkManager file
import '../helper/helper.dart';
import '../helper/network/network_manager.dart'; // UPDATED IMPORT PATH
// Import the Dashboard Screen
import 'dashboard.dart';

// Define a custom blue color that closely matches the screenshot's primary color
const Color kPrimaryBlue = Color(0xFF1976D2);
// Define both login URLs
const String _fnfLoginUrl = "http://dev-reentry.tetrus.dev/core/mobile/account/fnf/login";
const String _participantLoginUrl = "http://dev-reentry.tetrus.dev/core/mobile/account/inmate/login";

void main() {
  // Ensure the top status bar icons (time, battery) are dark for better contrast
  // against the light background, matching the screenshot.
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareLink Sign In',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Set the primary color for widgets like radio buttons and buttons
        primaryColor: kPrimaryBlue,
        colorScheme: ColorScheme.light(primary: kPrimaryBlue),
        scaffoldBackgroundColor: Colors.white,
        // UPDATED: Changed font family to Poppins
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controllers to capture text input
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State variables for interactive elements
  String _userType = 'Participant';
  bool _rememberMe = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // New helper function to show error popup
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
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // API Call function
  void _signIn() async {
    // Basic input validation
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorPopup('Please enter both username and password.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String url;
    Map<String, dynamic> loginBody;

    // Determine URL and Body based on user type
    if (_userType == 'Participant') {
      url = _participantLoginUrl;
      loginBody = {
        "login": _usernameController.text, // Key changed to 'login'
        "password": _passwordController.text,
        "accept": true, // Added 'accept: true'
      };
    } else {
      // Family/Friends (default behavior)
      url = _fnfLoginUrl;
      loginBody = {
        "username": _usernameController.text, // Key remains 'username'
        "password": _passwordController.text,
      };
    }

    final result = await NetworkManager.post(url, loginBody);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (result.isSuccess) {
        // --- START OF NAVIGATION CHANGE ---
        print('Login Successful! Navigating to Dashboard.');
        SharedPreferencesHelper.saveString('login_successfull', _usernameController.text);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
        );
        // --- END OF NAVIGATION CHANGE ---
      } else {
        // Handle login failure
        String message;

        if (result.error is String) {
          // Case 1: error is a simple string (e.g., network error from NetworkManager)
          message = result.error as String;
        } else if (result.error is Map) {
          // Case 2: error is a Map (server error object)
          final errorMap = result.error as Map;

          // Prioritize 'message', then look for 'errors' array, then fall back to status.
          String? extractedMessage = errorMap['message']?.toString();

          if (extractedMessage == null && errorMap['errors'] is List) {
            // If 'message' is null, check 'errors' list
            extractedMessage = (errorMap['errors'] as List).join(', ');
          }

          // Assign the final message, defaulting to a comprehensive error if both are null
          message = extractedMessage ?? 'Login failed with status: ${result.status}';

        } else if (result.error != null) {
          // Case 3: error is a raw Exception object or unexpected dynamic type.
          // Use toString() defensively to ensure it is always a string.
          message = result.error.toString();
        } else {
          // Case 4: result.error is null (shouldn't happen with isSuccess:false, but safe to check)
          message = 'Unknown login error occurred. Status: ${result.status}';
        }

        // Show error message in a popup
        _showErrorPopup(message);

        print('Login Failed: $message');
        print('Raw Error Object: ${result.error}');
      }
    }
  }

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

  Widget _buildSettingsIcon() {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: const Icon(Icons.settings_outlined, color: Colors.grey, size: 28),
        onPressed: () {
          // Placeholder for settings action
        },
      ),
    );
  }

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
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Sign in to your Account',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

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

  Widget _buildRoleRadio(String title) {
    return InkWell(
      onTap: () {
        setState(() {
          _userType = title;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: title,
            groupValue: _userType,
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  _userType = value;
                });
              }
            },
            activeColor: kPrimaryBlue,
          ),
          Text(title, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  // Linked to _usernameController
  Widget _buildUsernameField() {
    // The placeholder text will dynamically change based on the login field name for clarity.
    //final hintText = _userType == 'Participant' ? 'Login ID' : 'Username';
    final hintText = 'Username';

    return TextField(
      controller: _usernameController,
      decoration: InputDecoration(
        labelText: hintText,
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      ),
    );
  }

  // Linked to _passwordController
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
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }

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
                onChanged: (bool? value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
                activeColor: kPrimaryBlue,
              ),
            ),
            const SizedBox(width: 8),
            const Text('Remember Me', style: TextStyle(fontSize: 14)),
          ],
        ),
        TextButton(
          onPressed: () {
            // Placeholder for navigation to Forgot Password screen
          },
          child: const Text(
            'Forgot Password?',
            style: TextStyle(
              color: kPrimaryBlue,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  // Calls the _signIn function
  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _signIn, // Disable button while loading
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryBlue,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
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
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

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
              // Placeholder for navigation to Sign Up screen
            },
            child: const Text(
              'Signup',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kPrimaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
