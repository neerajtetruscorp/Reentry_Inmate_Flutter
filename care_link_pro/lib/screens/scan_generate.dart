import 'package:flutter/material.dart';

class ScanAndGenerateScreen extends StatelessWidget {
  final VoidCallback onBackToHome; // ✅ Callback to switch back to home tab

  const ScanAndGenerateScreen({Key? key, required this.onBackToHome})
      : super(key: key);

  void onTileTap(String title) {
    debugPrint("Clicked on: $title");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ Transparent AppBar without color overlay
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: onBackToHome, // ✅ Calls dashboard callback
              ),
              const Expanded(
                child: Text(
                  "Scan & Generate",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            buildTile(
              icon: Icons.qr_code_scanner,
              title: "eSign",
              borderColor: Colors.deepOrange,
              iconColor: Colors.deepOrange,
              onTap: () => onTileTap("eSign"),
            ),
            const SizedBox(height: 20),
            buildTile(
              icon: Icons.qr_code_2,
              title: "GENERATE QR CODE",
              borderColor: Colors.green,
              iconColor: Colors.green,
              onTap: () => onTileTap("GENERATE QR CODE"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTile({
    required IconData icon,
    required String title,
    required Color borderColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      splashColor: borderColor.withOpacity(0.2),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          color: Colors.white,
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Icon(icon, color: iconColor, size: 40),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
