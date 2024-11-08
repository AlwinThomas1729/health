import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For accessing the user's ID

class MedicationPage extends StatefulWidget {
  const MedicationPage({super.key});

  @override
  State<MedicationPage> createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final User? user = FirebaseAuth.instance.currentUser; // Get the current user

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt); // Format the time using intl
  }

  // Method to save medication to Firestore
  Future<void> _saveMedication(String name, String dosage, String time, String days) async {
    // Get the user's unique ID
    final String? userId = user?.uid;

    // Ensure the user is logged in
    if (userId != null) {
      // Reference to the Medications collection in Firestore
      CollectionReference medicationsRef = FirebaseFirestore.instance
          .collection('Patients')
          .doc(userId)
          .collection('Medications');

      // Add the medication details to the Firestore collection
      await medicationsRef.add({
        'name': name,
        'dosage': dosage,
        'time': time,
        'days': days,
        'timestamp': FieldValue.serverTimestamp(), // Store the time of entry
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Medicine Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the medicine name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dosageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Dosage (mg)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the dosage';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Time: ${_formatTime(_selectedTime)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: const Text('Select Time'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _daysController, // Input for number of days
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number of Days',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of days';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid number of days';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final String name = _nameController.text;
                    final String dosage = _dosageController.text;
                    final String time = _formatTime(_selectedTime);
                    final String days = _daysController.text; // Get number of days

                    // Save medication to Firestore
                    _saveMedication(name, dosage, time, days).then((_) {
                      // Show success dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Medication Added'),
                            content: Text(
                                'Name: $name\nDosage: $dosage mg\nTime: $time\nDays: $days'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.pop(context); // Go back to the previous screen
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    });
                  }
                },
                child: const Text('Add Medication'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
