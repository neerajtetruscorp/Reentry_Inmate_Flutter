import 'package:flutter/material.dart';
import '../helper/helper.dart';
import '../main.dart';
import 'login.dart';

/// Define a custom blue color for consistent styling
const Color kPrimaryBlue = Color(0xFF1976D2);

/// MyProfileScreen — Displays the user's profile details and account settings.
class MyProfileScreen extends StatelessWidget {
  final VoidCallback onBackToHome; // ✅ Callback to switch back to home tab



  const MyProfileScreen({super.key, required this.onBackToHome});


  /// Show a logout confirmation dialog
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'Logout',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          actions: <Widget>[
            // NO button
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss popup
              },
              child: const Text(
                'No',
                style: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
              ),
            ),
            // YES button
            TextButton(
              onPressed: () async {
                // Remove login flag
                await SharedPreferencesHelper.deleteString('login_successfull');

                Navigator.of(dialogContext).pop(); // Close dialog

                // Navigate to Login screen and clear all routes
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                      (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                'Yes',
                style: TextStyle(fontFamily: 'Poppins', color: kPrimaryBlue),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Widget builder for a single profile option
  Widget _buildProfileOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                Icon(icon, color: kPrimaryBlue, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                if (title != 'Logout')
                  const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: Colors.grey.shade300),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Temporary profile image (replace with real user photo later)
    const String profileImageUrl =
        "https://placehold.co/120x120/000000/ffffff?text=JM";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // No background color
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          tooltip: 'Back to Home',
          onPressed: () => onBackToHome(),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: const [
          // Notification bell (optional)
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Stack(
              children: [
                Icon(Icons.notifications_none, color: Colors.black, size: 28),
                Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 32),

            // Profile Picture
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  image: const DecorationImage(
                    image: NetworkImage(profileImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // User Name
            const Center(
              child: Text(
                'Jonathan',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 48),

            // Profile Options
            _buildProfileOption(
              context: context,
              icon: Icons.person_outline,
              title: 'Personal Information',
              onTap: () {
                debugPrint('Navigate to Personal Information');
              },
            ),
            _buildProfileOption(
              context: context,
              icon: Icons.vpn_key_outlined,
              title: 'Change Password',
              onTap: () {
                debugPrint('Navigate to Change Password');
              },
            ),
            _buildProfileOption(
              context: context,
              icon: Icons.logout,
              title: 'Logout',
              onTap: () => _showLogoutConfirmation(context),
              showDivider: false,
            ),
          ],
        ),
      ),
    );
  }
}
