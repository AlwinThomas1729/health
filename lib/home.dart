import 'package:flutter/material.dart';

// Assuming you have PatientPage and DoctorPage widgets
import 'Patient.dart'; // Import your PatientPage widget
import 'Doctor.dart'; // Import your DoctorPage widget

class HomePage extends StatefulWidget {
  final String userRole; // 'patient' or 'doctor'

  const HomePage({super.key, required this.userRole});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnRole();
  }

  void _navigateBasedOnRole() {
    if (widget.userRole == 'Patient') {
      // Navigate to PatientPage
      Future.microtask(() => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Patient())));
    } else if (widget.userRole == 'Doctor') {
      // Navigate to DoctorPage
      Future.microtask(() => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Doctor())));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Corrected method signature
    // You can return a temporary placeholder widget while routing happens.
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
      ),
      body: const Center(
        child: CircularProgressIndicator(), // Loading indicator while routing
      ),
    );
  }
}
