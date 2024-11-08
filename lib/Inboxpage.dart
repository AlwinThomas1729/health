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
  TextEditingController _messageController = TextEditingController();
  String? currentUserEmail;

  @override
  void initState() {
    super.initState();
    // Initialize the currentUserEmail with the logged-in user's email
    currentUserEmail = FirebaseAuth.instance.currentUser?.email;
  }

  // Send message function
  void _sendMessage() async {
    if (_messageController.text.isNotEmpty && currentUserEmail != null) {
      final timestamp = Timestamp.now(); // Get the current timestamp
      final messageData = {
        'senderEmail': currentUserEmail,
        'message': _messageController.text,
        'timestamp': timestamp,
      };

      try {
        // Get the chat document reference using doctorEmail
        DocumentSnapshot chatDoc = await FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.doctorEmail)
            .get();

        if (!chatDoc.exists) {
          // If the chat document doesn't exist, create it with an empty messages array
          await FirebaseFirestore.instance
              .collection('chats')
              .doc(widget.doctorEmail)
              .set({
            'messages': [messageData],
          });
        } else {
          // If document exists, update with new message in the messages array
          await FirebaseFirestore.instance
              .collection('chats')
              .doc(widget.doctorEmail)
              .update({
            'messages': FieldValue.arrayUnion([messageData]),
          });
        }

        _messageController
            .clear(); // Clear the message input field after sending
      } catch (e) {
        // Show an error message if the message fails to send
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String doctorName = widget.doctorEmail.split('_')[0];

    return Scaffold(
      appBar: AppBar(
        title: Text(
            doctorName), // Display only the part before the first underscore
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.doctorEmail)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('No messages yet.'));
                }

                var chatData = snapshot.data!.data() as Map<String, dynamic>;
                List<dynamic> messages = chatData['messages'] ?? [];

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index]['message'];
                    final senderEmail = messages[index]['senderEmail'];

                    bool isCurrentUser = senderEmail == currentUserEmail;

                    return Align(
                      alignment: isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isCurrentUser ? Colors.green : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            message,
                            style: TextStyle(
                              color:
                                  isCurrentUser ? Colors.white : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
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
                      hintText: "Type a message...",
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
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
