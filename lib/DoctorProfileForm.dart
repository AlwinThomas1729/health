import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'doctor.dart';

class DoctorProfileForm extends StatefulWidget {
  const DoctorProfileForm({Key? key}) : super(key: key);

  @override
  _DoctorProfileFormState createState() => _DoctorProfileFormState();
}

class _DoctorProfileFormState extends State<DoctorProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _submitProfile() async {
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (_formKey.currentState!.validate() && userEmail != null) {
      await _firestore.collection('doctors').doc(userEmail).set({
        'name': _nameController.text,
        'specialty': _specialtyController.text,
        'phone': _phoneController.text,
        'email': userEmail,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Doctor()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _specialtyController,
                decoration: const InputDecoration(labelText: 'Specialty'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your specialty';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitProfile,
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
