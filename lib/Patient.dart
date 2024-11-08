import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health/printdetails.dart';

import 'login.dart';
import 'ProfileDetailsPage.dart'; 
import 'medication.dart';         
import 'consultation.dart';       
import 'printdetails.dart';
import 'add_symptoms.dart'; // Import the AddSymptomsPage

class Patient extends StatefulWidget {
  const Patient({super.key});

  @override
  State<Patient> createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  User? user;
  bool isProfileComplete = false;
  String? patientName;
  final Set<String> _selectedMedications = {}; // Track selected medications

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _checkIfProfileComplete();
  }

  // Check if the profile details (name, age) are already in Firestore
  Future<void> _checkIfProfileComplete() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('Patients')
        .doc(user!.uid)
        .get();

    if (userDoc.exists && userDoc.data()!['name'] != null && userDoc.data()!['age'] != null) {
      setState(() {
        isProfileComplete = true;
        patientName = userDoc['name'];
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileDetailsPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: patientName == null
            ? const Text("Patient Dashboard")
            : const Text("HEALTHPULSE"),
        backgroundColor: const Color.fromARGB(255, 98, 225, 239),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            patientName == null
                ? const CircularProgressIndicator()
                : Text(
                    'Welcome $patientName',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
            const SizedBox(height: 30),
            const Text(
              'Today',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'View and Confirm your reminders!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Your daily medication routine will appear here when you schedule them in medication.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            // To-do List (Medications fetched from Firestore)
            Expanded(
              child: _buildMedicationList(),
            ),
            const SizedBox(height: 20),
            // Button to navigate to the medication page
            Center(
              child: ElevatedButton(
                onPressed: _selectedMedications.isEmpty ? null : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MedicationPage(), // Navigate to Medication Page
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  backgroundColor: const Color.fromARGB(255, 98, 225, 239),
                ),
                child: const Text('Schedule Medication'),
              ),
            ),
            const SizedBox(height: 20),
            // Add Symptoms Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddSymptomsPage(), // Navigate to Add Symptoms Page
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  backgroundColor: const Color.fromARGB(255, 98, 225, 239),
                ),
                child: const Text('Add Symptoms'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Logout method
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  // Sidebar Drawer with navigation options
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 15, 172, 196),
            ),
            child: Text(
              'OPTIONS',
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
        ],
      ),
    );
  }

  // Widget to build the medication to-do list
  Widget _buildMedicationList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Patients')
          .doc(user!.uid)
          .collection('Medications')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No medications scheduled.'),
          );
        }

        final medications = snapshot.data!.docs;

        return ListView.builder(
          itemCount: medications.length,
          itemBuilder: (context, index) {
            final medication = medications[index];
            final name = medication['name'];
            final dosage = medication['dosage'];
            final time = medication['time'];
            final medicationId = medication.id; // Get the ID of the medication

            return Card(
              child: ListTile(
                title: Text('$name ($dosage mg)'),
                subtitle: Text('Time: $time'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: _selectedMedications.contains(medicationId),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedMedications.add(medicationId);
                          } else {
                            _selectedMedications.remove(medicationId);
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteMedication(medicationId),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Method to delete medication from Firestore
  Future<void> _deleteMedication(String medicationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(user!.uid)
          .collection('Medications')
          .doc(medicationId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medication deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete medication.')),
      );
    }
  }
}
