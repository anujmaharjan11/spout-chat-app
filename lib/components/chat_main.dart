import 'package:chat_help_project/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMain extends StatefulWidget {
  final UserModel user;
  final FirebaseAuth auth;
  final String combinedId;

  const ChatMain(
      {super.key,
      required this.user,
      required this.auth,
      required this.combinedId});

  @override
  State<ChatMain> createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {
  List? messages;
  late final TextEditingController? _controller = TextEditingController();
  late FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool? isChatEnded = false;
  Timestamp? endedAt;

  void initState() {
    super.initState();
    print("chatDocumentId: ${widget.combinedId.length}");
  }

  Stream<List> fetchMessagesStream() {
    return firestore
        .collection('chats')
        .doc(widget.combinedId)
        .snapshots()
        .map((snapshot) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      endedAt = data['endedAt'];

      return data['messages'] ?? [];
    });
  }

  Future<void> updateChat() async {
    await firestore.collection("chats").doc(widget.combinedId).update({
      "messages": FieldValue.arrayUnion([
        {
          "id": UniqueKey().hashCode.toString(),
          "text": _controller?.text.trim(),
          "senderId": widget.auth.currentUser!.uid,
          "receiverId": widget.user.id,
          "date": DateTime.now()
        }
      ])
    });

    _controller?.clear();
  }

  @override
  void dispose() {
    // Don't forget to dispose of the TextEditingController when the widget is disposed.
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://is1-ssl.mzstatic.com/image/thumb/Purple116/v4/9f/8c/a9/9f8ca9e7-1ced-8fcc-5a02-468eb07379d0/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/1200x630wa.png"),
                    maxRadius: 20,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.user.username,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        return _showDialog(context);
                      }),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.black12,
          child: StreamBuilder<List>(
              stream: fetchMessagesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Or any other loading indicator
                }

                if (snapshot.hasError) {
                  return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      color: Colors.red,
                      child: Text(
                          style: const TextStyle(color: Colors.white),
                          'Error: ${snapshot.error}'));
                }

                if (endedAt != null) {
                  return  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Your chat session has ended.",
                          style: TextStyle(fontSize: 20),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            textStyle: const TextStyle(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('New session'),
                        ),                      ],
                    ),
                  );
                }

                if (snapshot.hasData) {

                  final data = snapshot.data;

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: data?.length ?? 0,
                          // shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.only(
                                  left: 14, right: 14, top: 8, bottom: 8),
                              child: Align(
                                alignment: (data?[index]['senderId'] !=
                                        widget.auth.currentUser!.uid
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight),
                                child: Row(
                                  mainAxisAlignment: data?[index]['senderId'] !=
                                          widget.auth.currentUser!.uid
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        minWidth: 50.0,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: (data?[index]['senderId'] !=
                                                widget.auth.currentUser!.uid
                                            ? Colors.white
                                            : Colors.purple[300]),
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        data?[index]['text'] ?? "No Text",
                                        style: TextStyle(
                                            color: (data?[index]['senderId'] ==
                                                    widget.auth.currentUser!.uid
                                                ? Colors.white
                                                : Colors.black),
                                            fontSize: 15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        height: 60,
                        width: double.infinity,
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.purple[300],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: TextField(
                                maxLines: 5,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                                controller: _controller,
                                decoration: const InputDecoration(
                                    hintText: "Enter message",
                                    hintStyle: TextStyle(color: Colors.black54),
                                    border: InputBorder.none),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            TextButton(
                              onPressed: () {
                                _controller!.text.trim().isNotEmpty
                                    ? updateChat()
                                    : null;
                              },
                              child: Icon(
                                Icons.send,
                                color: Colors.purple[300],
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }
                return const Text("Random else");
              }),
        ));
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Attention'),
          content:  Text(endedAt == null ?
              'Do you want to close this session with Jeevee Admin.' : "Your session with the admin has been already closed."),
          actions: <Widget>[
            endedAt == null ?
            Row(
              children: [
                TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
                TextButton(
                  child: const Text('Confirm'),
                  onPressed: () async {
                    updateSessionId();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ) :const SizedBox.shrink()
          ],
        );
      },
    );
  }

  Future<void> updateSessionId() async {
    await firestore.collection("chats").doc(widget.combinedId).update({
      "endedAt": DateTime.now(),
    });
  }
}
