import 'package:chat_help_project/components/chat_main.dart';
import 'package:chat_help_project/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({super.key});

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String activeChatDocumentId = ''; // Add this variable

  @override
  void initState() {
    super.initState();
    // getCollection();
  }

  String generateChatDocumentId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();
    return ids.join('_');
  }

  Future<void> setDocumentSelect(UserModel user) async {
    bool chatExists;
    CollectionReference chatSessions =
        FirebaseFirestore.instance.collection('chats');
    if (activeChatDocumentId.isEmpty) {
      DocumentReference newSessionRef = chatSessions.doc();
      // String newChatDocumentId = newSessionRef.id; // Store the generated document ID
      activeChatDocumentId =
          newSessionRef.id; // Store the generated document ID
    }
    DocumentSnapshot getDocumentSnapshot = await FirebaseFirestore.instance
        .collection('chats')
        // .doc(generateChatDocumentId(user.id, auth.currentUser!.uid))
        .doc(activeChatDocumentId)
        .get();
    chatExists = getDocumentSnapshot.exists;

    if (chatExists == false) {
      await FirebaseFirestore.instance
          .collection('chats')
          // .doc(generateChatDocumentId(user.id, auth.currentUser!.uid))
          .doc(activeChatDocumentId)
          .set({
        "sessionId": activeChatDocumentId,
        "createdAt": DateTime.now(),
        "endedAt": null,
        "messages": []
      });
      // activeChatDocumentId = newChatDocumentId;
      print("aaaaaaa>>>>$activeChatDocumentId");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                style: TextStyle(fontSize: 16), "Need help? Chat with us."),
            const SizedBox(height: 8),
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error : ${snapshot.error}");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final userList = snapshot.data?.docs
                      .where((element) =>
                          element.id != auth.currentUser?.uid &&
                          element["role"] == "admin")
                      .map((doc) => UserModel(
                          id: doc.get('uid'),
                          username: doc.get('username'),
                          email: doc.get('email')))
                      .toList();

                  return Center(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: userList?.length,
                        itemBuilder: (BuildContext context, int idx) {
                          final user = userList?[idx];
                          return Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                setDocumentSelect(user);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatMain(
                                            user: user,
                                            auth: auth,
                                            combinedId: activeChatDocumentId,
                                          )),
                                );
                              },
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.purple),
                                  child: Text(
                                    user!.username,
                                    style: const TextStyle(color: Colors.white),
                                  )),
                            ),
                          ));
                        }),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
