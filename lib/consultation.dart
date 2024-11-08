// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'ChatPage.dart';

// class ConsultationPage extends StatelessWidget {
//   const ConsultationPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Consultation'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No doctors available.'));
//           }

//           final doctors = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: doctors.length,
//             itemBuilder: (context, index) {
//               final doctorData = doctors[index];
//               return ListTile(
//                 title: Text(doctorData['name'] ?? 'Unknown Doctor'),
//                 subtitle: Text(doctorData['specialty'] ?? 'Specialty not available'),
//                 onTap: () async {
//                   final patientId = FirebaseAuth.instance.currentUser?.uid;

//                   if (patientId != null) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ChatPage(
//                           doctorId: doctorData.id,
//                           patientId: patientId,
//                           doctorName: doctorData['name'],
//                         ),
//                       ),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Error: Patient is not logged in.'),
//                       ),
//                     );
//                   }
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'ChatPage.dart';

// class ConsultationPage extends StatelessWidget {
//   const ConsultationPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chat with your doctor'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No doctors available.'));
//           }

//           final doctors = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: doctors.length,
//             itemBuilder: (context, index) {
//               final doctorData = doctors[index];

//               return Card(
//                 margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: ListTile(
//                   title: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Name: ${doctorData['name'] ?? 'Unknown Doctor'}'),
//                       Text('Specialty: ${doctorData['specialty'] ?? 'Specialty not available'}'),
//                      // Text('Email: ${doctorData['email'] ?? 'Email not available'}'),
//                     ],
//                   ),
//                   onTap: () async {
//                     final patientId = FirebaseAuth.instance.currentUser?.uid;

//                     if (patientId != null) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ChatPage(
//                             doctorId: doctorData.id,
//                             patientId: patientId,
//                             doctorName: doctorData['name'],
//                           ),
//                         ),
//                       );
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Error: Patient is not logged in.'),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ChatPage.dart';

class ConsultationPage extends StatelessWidget {
  const ConsultationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultation'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No doctors available.'));
          }

          final doctors = snapshot.data!.docs;

          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctorData = doctors[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${doctorData['name'] ?? 'Unknown Doctor'}'),
                      Text('Specialty: ${doctorData['specialty'] ?? 'Specialty not available'}'),
                      Text('Email: ${doctorData['email'] ?? 'Email not available'}'),
                    ],
                  ),
                  onTap: () async {
                    final patientId = FirebaseAuth.instance.currentUser?.uid;

                    if (patientId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            doctorId: doctorData.id,
                            patientId: patientId,
                            doctorName: doctorData['name'],
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error: Patient is not logged in.'),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
