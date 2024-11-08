// // import 'package:flutter/material.dart';

// // class InboxPage extends StatefulWidget {
// //   const InboxPage({Key? key}) : super(key: key);

// //   @override
// //   _InboxPageState createState() => _InboxPageState();
// // }

// // class _InboxPageState extends State<InboxPage> {
// //   final TextEditingController _messageController = TextEditingController();

// //   void _sendMessage() {
// //     final message = _messageController.text;
// //     if (message.isNotEmpty) {
// //       // This is where you would integrate with Firestore to send the message
// //       // Example: Firestore integration to send message
// //       // FirebaseFirestore.instance.collection('chats').doc('your_doc_id').set({
// //       //   'message': message,
// //       //   'timestamp': FieldValue.serverTimestamp(),
// //       // });

// //       print("Message sent: $message"); // For debugging

// //       // Clear the text field
// //       _messageController.clear();
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Inbox"),
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: Center(
// //               child: const Text(
// //                 "Hello World", // This will later be replaced with messages display
// //                 style: TextStyle(fontSize: 24),
// //               ),
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: TextField(
// //                     controller: _messageController,
// //                     decoration: const InputDecoration(
// //                       hintText: "Enter your message",
// //                       border: OutlineInputBorder(),
// //                     ),
// //                   ),
// //                 ),
// //                 IconButton(
// //                   icon: const Icon(Icons.send),
// //                   onPressed: _sendMessage,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _messageController.dispose();
// //     super.dispose();
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class InboxPage extends StatefulWidget {
//   const InboxPage({Key? key}) : super(key: key);

//   @override
//   _InboxPageState createState() => _InboxPageState();
// }

// class _InboxPageState extends State<InboxPage> {
//   // Fetch the current user's email and remove the domain part
//   late String doctorEmail;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the doctorEmail variable with the current user's email
//     doctorEmail = FirebaseAuth.instance.currentUser?.email?.split('@')[0] ?? '';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Inbox"),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('chats').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text("No messages found"));
//           }

//           final documents = snapshot.data!.docs;

//           return ListView.builder(
//             padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//             itemCount: documents.length,
//             itemBuilder: (context, index) {
//               // Extract the part of the document name before and after the first underscore
//               final docName = documents[index].id.split('_')[0];
//               final doctorName = documents[index]
//                   .id
//                   .split('_')[1]; // The part after the underscore

//               // Display data only if doctorName matches the current user's email
//               if (emailPart == doctorEmail) {
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 6),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 2,
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: Colors.blueAccent,
//                       child: Text(
//                         docName.isNotEmpty ? docName[0].toUpperCase() : '?',
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                     ),
//                     title: Text(
//                       docName,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     subtitle: const Text("Tap to view details"),
//                     trailing: const Icon(Icons.chevron_right),
//                     onTap: () {
//                       // Define an action when the item is tapped, if needed
//                       print("Tapped on $docName");
//                     },
//                   ),
//                 );
//               } else {
//                 // Return an empty container or nothing for documents that don't match
//                 return Container();
//               }
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

class InboxPage extends StatefulWidget {
  const InboxPage({Key? key}) : super(key: key);

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  // Fetch the current user's email and remove the domain part
  late String doctorEmail;

  @override
  void initState() {
    super.initState();
    // Initialize the doctorEmail variable with the current user's email (without @gmail.com)
    doctorEmail = FirebaseAuth.instance.currentUser?.email?.split('@')[0] ?? '';
  }

  // Method to navigate to the chat details page
  void _showChatDetails(String doctorEmail) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailPage(doctorEmail: doctorEmail),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inbox"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No messages found"));
          }

          final documents = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              // Extract the part of the document name before and after the first underscore
              final patientName = documents[index].id.split('_')[0];
              final doctorName = documents[index]
                  .id
                  .split('_')[1]; // The part after the underscore

              // Display data only if doctorName matches the current user's email
              if (doctorName == doctorEmail) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        patientName.isNotEmpty
                            ? patientName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      patientName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text("Tap to view details"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // When the tile is tapped, fetch and display chat data
                      _showChatDetails(
                          patientName + '_' + doctorName + '_chat');
                    },
                  ),
                );
              } else {
                // Return an empty container or nothing for documents that don't match
                return Container();
              }
            },
          );
        },
      ),
    );
  }
}

class ChatDetailPage extends StatelessWidget {
  final String doctorEmail;

  const ChatDetailPage({Key? key, required this.doctorEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Details - $doctorEmail'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('chats')
            .doc(doctorEmail)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No chat found for this doctor"));
          }

          var chatData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chat Details',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  'Message: ${chatData['messages'] ?? 'No message available'}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                /* Text(
                  'Timestamp: ${chatData['timestamp'] ?? 'No timestamp available'}',
                  style: const TextStyle(fontSize: 18),
                ),*/
              ],
            ),
          );
        },
      ),
    );
  }
}
