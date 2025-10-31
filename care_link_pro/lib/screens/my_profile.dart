import 'package:flutter/material.dart';
// Assuming Login screen is defined in main.dart, located one directory up.
// This line needs to be adjusted based on your actual file structure.
import '../helper/helper.dart';
import '../main.dart';
import 'login.dart';

// Define a custom blue color (must be defined in every file if not using a theme/constants file)
const Color kPrimaryBlue = Color(0xFF1976D2);

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  // Helper function to show logout confirmation popup
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
              onPressed: () {

                 SharedPreferencesHelper.deleteString('login_successfull');

                // Dismiss popup
                Navigator.of(dialogContext).pop();

                // Navigate back to the Login screen and remove all other routes
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

  // Helper widget for profile menu items
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
                if (title != 'Logout') // Optional: show arrow for navigation items
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
    // Placeholder image URL
    const String profileImageUrl =
        "https://placehold.co/120x120/000000/ffffff?text=JM";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the Dashboard
          },
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
          // Notification icon placeholder (matches Dashboard)
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
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  // In a real app, this would use CachedNetworkImage or a local asset
                  image: DecorationImage(
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

            // Profile Options Menu
            _buildProfileOption(
              context: context,
              icon: Icons.person_outline,
              title: 'Personal Information',
              onTap: () {
                print('Navigate to Personal Information');
              },
              showDivider: true,
            ),
            _buildProfileOption(
              context: context,
              icon: Icons.vpn_key_outlined,
              title: 'Change Password',
              onTap: () {
                print('Navigate to Change Password');
              },
              showDivider: true,
            ),
            _buildProfileOption(
              context: context,
              icon: Icons.logout,
              title: 'Logout',
              onTap: () => _showLogoutConfirmation(context),
              showDivider: false, // Last item usually doesn't need a divider
            ),
          ],
        ),
      ),
    );
  }
}
