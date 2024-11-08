import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart'; // Make sure to import your LoginPage

class Printdetails extends StatelessWidget {
  const Printdetails({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Details"),
        backgroundColor: const Color.fromARGB(255, 110, 198, 216), // Change AppBar color to amber
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 244, 247, 247), // Background color remains unchanged
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Patients')
            .doc(user!.uid)
            .get(), // Fetch the profile details from Firestore
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                "No profile information available.",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            );
          }

          // Extract patient data from the snapshot
          var patientData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 18, 17, 17),
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextBoxRow('Name', patientData['name'] ?? 'N/A'),
                const SizedBox(height: 10),
                _buildTextBoxRow('Age', patientData['age'] ?? 'N/A'),
                const SizedBox(height: 10),
                _buildTextBoxRow('Gender', patientData['gender'] ?? 'N/A'),
                const SizedBox(height: 10),
                _buildTextBoxRow('Weight', patientData['weight'] ?? 'N/A'),
                const SizedBox(height: 10),
                _buildTextBoxRow('Height', patientData['height'] ?? 'N/A'),
              ],
            ),
          );
        },
      ),
    );
  }

  // A method to create a row with a label and corresponding text in a read-only box
  static Widget _buildTextBoxRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 20, 18, 18)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: TextField(
            controller: TextEditingController(text: value),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            readOnly: true, // Read-only as it's user profile information
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  // Logout method
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(), // Redirect to login page
      ),
    );
  }
}
