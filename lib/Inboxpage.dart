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

class ChatDetailPage extends StatefulWidget {
  final String doctorEmail;

  const ChatDetailPage({Key? key, required this.doctorEmail}) : super(key: key);

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  late String doctorFirstName;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Extract the first part of the doctorEmail (before the first '_')
    doctorFirstName = widget.doctorEmail.split('_')[0];
  }

  // Method to send a new message
  void _sendMessage() async {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      // Get the current user's email (patient's email)
      String patientEmail =
          FirebaseAuth.instance.currentUser?.email?.split('@')[0] ?? '';

      // Use doctorEmail as docId for the chat document
      String docId = widget.doctorEmail;

      // Create the message map
      Map<String, dynamic> messageData = {
        'messages': FieldValue.arrayUnion([
          {
            'message': message,
            'senderEmail': patientEmail,
            'timestamp': FieldValue.serverTimestamp()
          },
        ]),
      };

      // Store the message in the Firestore collection with doctorEmail as docId
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(docId)
          .set(messageData, SetOptions(merge: true));

      // Clear the message input
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Chat - $doctorFirstName'), // Only show the first part of the doctorEmail
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.doctorEmail)
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
          List<dynamic> messages = chatData['messages'] ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (messages.isEmpty)
                  const Text('No messages available')
                else
                  ...messages.map((messageData) {
                    String message = messageData['message'] ?? 'No message';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        message,
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  }).toList(),
                const SizedBox(height: 20),
                Expanded(
                    child:
                        Container()), // Empty space to push the text field to the bottom
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            labelText: 'Enter your message',
                            border: OutlineInputBorder(),
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
        },
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
