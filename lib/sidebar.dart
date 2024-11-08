import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health/printdetails.dart';

import 'login.dart';
import 'ProfileDetailsPage.dart'; // Import the ProfileDetailsPage
import 'medication.dart';         // Import the Medication Page
import 'consultation.dart';       // Import the Consultation Page

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 15, 172, 196),
            ),
            child: Text(
              'HealthPulse',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile Details'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Printdetails(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_services),
            title: const Text('Medication'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MedicationPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Consultation'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConsultationPage(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
