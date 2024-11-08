import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'DoctorProfileForm.dart';
import 'login.dart';
import 'InboxPage.dart';

class Doctor extends StatefulWidget {
  const Doctor({super.key});

  @override
  State<Doctor> createState() => _DoctorState();
}

class _DoctorState extends State<Doctor> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _hasProfile = false;

  @override
  void initState() {
    super.initState();
    _checkProfileExists();
  }

  Future<void> _checkProfileExists() async {
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail != null) {
      final doctorDoc = await _firestore.collection('doctors').doc(userEmail).get();
      if (doctorDoc.exists) {
        setState(() {
          _hasProfile = true;
        });
      } else {
        // Redirect to DoctorProfileForm if profile does not exist
        Future.microtask(() => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DoctorProfileForm()),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor"),
        backgroundColor: const Color.fromARGB(255, 88, 232, 222),
        actions: [
          if (_hasProfile)
            IconButton(
              onPressed: () {
                showProfileDialog(context);
              },
              icon: const Icon(Icons.account_circle),
            ),
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(
        child: Text("Welcome to your dashboard"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 85, 217, 231)),
              child: Text('OPTIONS', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: const Text("Schedule"),
              onTap: () {
                Navigator.pop(context);
                showScheduleDialog(context);
              },
            ),
            ListTile(
              title: const Text("Inbox"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  InboxPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // Show doctor's profile dialog
  void showProfileDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Doctor Profile"),
          content: const Text("Profile details will appear here."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  // Show schedule dialog
  void showScheduleDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Schedule"),
          content: const Text("Your schedule details go here."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
