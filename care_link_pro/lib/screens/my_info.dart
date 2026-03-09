import 'package:flutter/material.dart';
import '../widgets/myinfo_card.dart';

class MyInfoScreen extends StatelessWidget {
  const MyInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
      title: const Text("My Info"),
    ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          /// Profile Circle
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue.shade300,
            child: const Text(
              "JK",
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            "Jonathan Kozak",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          const Text(
            "Participant ID: 000137536",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              children: [

                MyInfoCard(
                  title: "My Plans",
                  icon: Icons.list_alt,
                  onTap: () {
                    print("My Plans clicked");
                  },
                ),

                MyInfoCard(
                  title: "Consent",
                  icon: Icons.verified_user_outlined,
                  onTap: () {
                    print("Consent clicked");
                  },
                ),

                MyInfoCard(
                  title: "Care Team",
                  icon: Icons.volunteer_activism_outlined,
                  onTap: () {
                    print("Care Team clicked");
                  },
                ),

                MyInfoCard(
                  title: "Documents",
                  icon: Icons.description_outlined,
                  onTap: () {
                    print("Documents clicked");
                  },
                ),

                MyInfoCard(
                  title: "Referral",
                  icon: Icons.people_outline,
                  onTap: () {
                    print("Referral clicked");
                  },
                ),

                MyInfoCard(
                  title: "Communication",
                  icon: Icons.chat_bubble_outline,
                  onTap: () {
                    print("Communication clicked");
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}