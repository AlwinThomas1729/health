import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddSymptomsPage extends StatefulWidget {
  const AddSymptomsPage({super.key});

  @override
  _AddSymptomsPageState createState() => _AddSymptomsPageState();
}

class _AddSymptomsPageState extends State<AddSymptomsPage> {
  final TextEditingController _symptomsController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Symptoms"),
        backgroundColor: const Color.fromARGB(255, 98, 225, 239),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please enter your symptoms:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _symptomsController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Symptoms',
                hintText: 'Enter symptoms here...',
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitSymptoms,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: const Color.fromARGB(255, 98, 225, 239),
                ),
                child: const Text('Submit Symptoms'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to submit symptoms to Firestore
  Future<void> _submitSymptoms() async {
    if (_symptomsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your symptoms.')),
      );
      return;
    }

    // Prepare data to save
    final symptomsData = {
      'email': user?.email, // Save patient's email
      'symptoms': _symptomsController.text, // Save submitted symptoms
      'timestamp': FieldValue.serverTimestamp(), // Optional: add a timestamp
    };

    try {
      // Save to Firestore in the Symptoms collection
      await FirebaseFirestore.instance.collection('Symptoms').add(symptomsData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Symptoms added successfully!')),
      );
      Navigator.pop(context); // Navigate back after saving
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add symptoms.')),
      );
    }
  }
}
