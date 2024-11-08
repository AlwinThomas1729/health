// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import 'login.dart'; // Make sure to import your LoginPage

// class ProfileDetailsPage extends StatelessWidget {
//   const ProfileDetailsPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final User? user = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Profile Details"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               _logout(context);
//             },
//           ),
//         ],
//       ),
//       backgroundColor: const Color.fromARGB(255, 15, 172, 196),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: FirebaseFirestore.instance
//             .collection('Patients')
//             .doc(user!.uid)
//             .get(), // Fetch the profile details from Firestore
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(
//               child: Text(
//                 "No profile information available.",
//                 style: TextStyle(fontSize: 20, color: Colors.white),
//               ),
//             );
//           }

//           // Extract patient data from the snapshot
//           var patientData = snapshot.data!.data() as Map<String, dynamic>;

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Profile",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 _buildTextBoxRow('Name', patientData['name'] ?? 'N/A'),
//                 const SizedBox(height: 10),
//                 _buildTextBoxRow('Age', patientData['age'] ?? 'N/A'),
//                 const SizedBox(height: 10),
//                 _buildTextBoxRow('Gender', patientData['gender'] ?? 'N/A'),
//                 const SizedBox(height: 10),
//                 _buildTextBoxRow('Weight', patientData['weight'] ?? 'N/A'),
//                 const SizedBox(height: 10),
//                 _buildTextBoxRow('Height', patientData['height'] ?? 'N/A'),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // A method to create a row with a label and corresponding text in a read-only box
//   static Widget _buildTextBoxRow(String label, String value) {
//     return Row(
//       children: [
//         Expanded(
//           flex: 1,
//           child: Text(
//             label,
//             style: const TextStyle(fontSize: 18, color: Colors.white),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           flex: 2,
//           child: TextField(
//             controller: TextEditingController(text: value),
//             decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//               filled: true,
//               fillColor: Colors.white,
//             ),
//             readOnly: true, // Read-only as it's user profile information
//             style: const TextStyle(fontSize: 18),
//           ),
//         ),
//       ],
//     );
//   }

//   // Logout method
//   Future<void> _logout(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const LoginPage(), // Redirect to login page
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input filtering
import 'patient.dart'; // Import Patient dashboard

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  _ProfileDetailsPageState createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String? _gender;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (value.length != 10) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: ['Male', 'Female', 'Other']
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _heightController,
                  decoration: const InputDecoration(labelText: 'Height (cm)'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your height';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your weight';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitProfileDetails,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Save profile details (name, age, gender, etc.) to Firestore
  Future<void> _submitProfileDetails() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance.collection('Patients').doc(user.uid).set({
          'name': _nameController.text,
          'age': _ageController.text,
          'phone': _phoneController.text,
          'gender': _gender,
          'height': _heightController.text,
          'weight': _weightController.text,
          'email': user.email, // Add the user's email explicitly
        });

        // Navigate back to the Patient dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Patient(),
          ),
        );
      }
    } else {
      // Show an error message if validation fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the details correctly.')),
      );
    }
  }
}
