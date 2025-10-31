import 'package:flutter/material.dart';

/// Define app-wide constants
const Color kPrimaryBlue = Color(0xFF1976D2);

/// MoreScreen — Displays additional features and quick links like job search,
/// provider services, consent requests, etc. The screen supports a callback
/// for returning to the home screen instead of manual pop navigation.
class MoreScreen extends StatelessWidget {
  final int selectedIndex;
  final VoidCallback onBackToHome; // ✅ Callback to go back to home tab

  const MoreScreen({
    super.key,
    this.selectedIndex = 3,
    required this.onBackToHome,
  });

  /// Data model for list items displayed in the More screen
  final List<Map<String, dynamic>> menuItems = const [
    {
      'title': 'Job Search',
      'icon': Icons.search,
      'color': Colors.grey,
      'subtitle': 'Search for available job openings',
    },
    {
      'title': 'Provider Services',
      'icon': Icons.person_add_alt_1,
      'color': Colors.blue,
      'subtitle': 'Manage your service providers',
    },
    {
      'title': 'Consent Request(s)',
      'icon': Icons.description,
      'color': Colors.blueGrey,
      'subtitle': 'View and manage consent forms',
    },
    {
      'title': 'Documents',
      'icon': Icons.file_copy,
      'color': Colors.blueGrey,
      'subtitle': 'Access important documents',
    },
  ];

  /// When a user taps a menu item
  void _onItemTapped(BuildContext context, String title) {
    debugPrint('Tapped on: $title');
    // You can later navigate to the respective screen here
    // Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(title: title)));
  }

  /// Helper method to build each list item
  Widget _buildListItem(BuildContext context, Map<String, dynamic> item) {
    return InkWell(
      onTap: () => _onItemTapped(context, item['title']),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(item['icon'] as IconData, color: Colors.black54, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item['title'] as String,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  /// Custom AppBar with back button and notifications
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          tooltip: 'Back to Home',
          onPressed: onBackToHome, // ✅ Use callback instead of Navigator.pop()
        ),
      ),
      title: const Text(
        'More',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black87, size: 28),
              onPressed: () {
                // Future: open notifications screen
              },
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: const BoxConstraints(
                  minWidth: 14,
                  minHeight: 14,
                ),
                child: const Text(
                  '25', // Mock count
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 9,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              return _buildListItem(context, menuItems[index]);
            },
          ),
        ),
      ),
      // ❌ No bottomNavigationBar here — handled by parent Dashboard/Home screen
    );
  }
}
