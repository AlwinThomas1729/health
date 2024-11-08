// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ChatPage extends StatefulWidget {
//   final String doctorId;      // Doctor's email ID
//   final String patientId;     // Patient's document ID in the Patients collection
//   final String doctorName;

//   const ChatPage({
//     super.key,
//     required this.doctorId,
//     required this.patientId,
//     required this.doctorName,
//   });

//   @override
//   _ChatPageState createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
//   String? patientEmail; // To hold the fetched patient email
//   late DocumentReference chatDocument;

//   @override
//   void initState() {
//     super.initState();
//     _fetchPatientEmail(); // Fetch patient email when the chat page loads
//   }

//   /// Fetch the patient's email from the Patients collection
//   Future<void> _fetchPatientEmail() async {
//     final patientDoc = await FirebaseFirestore.instance
//         .collection('Patients')
//         .doc(widget.patientId)
//         .get();

//     if (patientDoc.exists) {
//       setState(() {
//         patientEmail = patientDoc.data()?['email']; // Fetch email from document

//         // Create chat document using patient_name_doctor_name as the document ID
//         final chatKey = '${patientEmail}_${widget.doctorId}_chat';
//         chatDocument = FirebaseFirestore.instance
//             .collection('chats')
//             .doc(chatKey); // Use patient_name_doctor_name as the document ID
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Error: Patient data not found.')),
//       );
//     }
//   }

//   /// Send a message and include doctorId, patientEmail, and receiverId fields
//   void _sendMessage() async {
//     if (_messageController.text.isNotEmpty && patientEmail != null) {
//       final timestamp = Timestamp.now(); // Generate timestamp
//       final messageData = {
//         'senderEmail': currentUserEmail,
//         'message': _messageController.text,
//         'timestamp': timestamp, // Timestamp added here
//       };

//       try {
//         // Check if the document already exists
//         DocumentSnapshot chatDoc = await chatDocument.get();
//         if (!chatDoc.exists) {
//           // If chat document doesn't exist, create it with an empty 'messages' field
//           await chatDocument.set({
//             'messages': [messageData],
//           });
//         } else {
//           // If chat document exists, update with the new message in the array
//           await chatDocument.update({
//             'messages': FieldValue.arrayUnion([messageData]),
//           });
//         }

//         _messageController.clear();
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to send message: $e')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a message.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat with Dr. ${widget.doctorName}'),
//       ),
//       body: patientEmail == null
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Expanded(
//                   child: StreamBuilder<DocumentSnapshot>(
//                     stream: chatDocument.snapshots(),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) {
//                         return const Center(child: CircularProgressIndicator());
//                       }

//                       // Safely check if data is available before casting
//                       final chatData = snapshot.data!;
//                       final chatMap = chatData.data() as Map<String, dynamic>?;
//                       final messages = chatMap?['messages'] ?? [];

//                       return ListView.builder(
//                         reverse: true,
//                         itemCount: messages.length,
//                         itemBuilder: (context, index) {
//                           final message = messages[index];
//                           final isSentByMe = message['senderEmail'] == currentUserEmail;

//                           return Align(
//                             alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
//                             child: Container(
//                               margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: isSentByMe ? Colors.blue[300] : Colors.grey[300],
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Text(message['message']),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: _messageController,
//                           decoration: const InputDecoration(
//                             hintText: 'Enter your message',
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.send),
//                         onPressed: _sendMessage,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  final String doctorId;      // Doctor's email ID
  final String patientId;     // Patient's document ID in the Patients collection
  final String doctorName;

  const ChatPage({
    super.key,
    required this.doctorId,
    required this.patientId,
    required this.doctorName,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
  String? patientEmail; // To hold the fetched patient email
  late DocumentReference chatDocument;

  @override
  void initState() {
    super.initState();
    _fetchPatientEmail(); // Fetch patient email when the chat page loads
  }

  /// Fetch the patient's email from the Patients collection
  Future<void> _fetchPatientEmail() async {
    final patientDoc = await FirebaseFirestore.instance
        .collection('Patients')
        .doc(widget.patientId)
        .get();

    if (patientDoc.exists) {
      setState(() {
        patientEmail = patientDoc.data()?['email']; // Fetch email from document

        // Remove '@' and '.com' from the emails for document naming
        final strippedDoctorEmail = widget.doctorId.replaceAll('@gmail.com', '');
        final strippedPatientEmail = patientEmail!.replaceAll('@gmail.com', '');
        final chatKey = '${strippedPatientEmail}_${strippedDoctorEmail}_chat';

        // Create chat document using patient_name_doctor_name as the document ID
        chatDocument = FirebaseFirestore.instance
            .collection('chats')
            .doc(chatKey); // Use patient_name_doctor_name as the document ID
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Patient data not found.')),
      );
    }
  }

  /// Send a message and include doctorId, patientEmail, and receiverId fields
  void _sendMessage() async {
    if (_messageController.text.isNotEmpty && patientEmail != null) {
      final timestamp = Timestamp.now(); // Generate timestamp
      final messageData = {
        'senderEmail': currentUserEmail,
        'message': _messageController.text,
        'timestamp': timestamp, // Timestamp added here
      };

      try {
        // Check if the document already exists
        DocumentSnapshot chatDoc = await chatDocument.get();
        if (!chatDoc.exists) {
          // If chat document doesn't exist, create it with an empty 'messages' field
          await chatDocument.set({
            'messages': [messageData],
          });
        } else {
          // If chat document exists, update with the new message in the array
          await chatDocument.update({
            'messages': FieldValue.arrayUnion([messageData]),
          });
        }

        _messageController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a message.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Dr. ${widget.doctorName}'),
      ),
      body: patientEmail == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: chatDocument.snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // Safely check if data is available before casting
                      final chatData = snapshot.data!;
                      final chatMap = chatData.data() as Map<String, dynamic>?;
                      final messages = chatMap?['messages'] ?? [];

                      // Sort the messages by timestamp (ascending order)
                      final sortedMessages = List.from(messages)
                        ..sort((a, b) => (a['timestamp'] as Timestamp)
                            .compareTo(b['timestamp']));

                      // Do not reverse the list as Firestore is already sorted by timestamp
                      return ListView.builder(
                        reverse: false, // No reversing, to show latest messages at bottom
                        itemCount: sortedMessages.length,
                        itemBuilder: (context, index) {
                          final message = sortedMessages[index];
                          final isSentByMe = message['senderEmail'] == currentUserEmail;

                          return Align(
                            alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSentByMe ? Colors.blue[300] : Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(message['message']),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your message',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
