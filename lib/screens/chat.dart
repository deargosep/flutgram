import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutgram/components/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends HookWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = Get.parameters['name'].toString();
    final id = Get.parameters['id'].toString();
    final uid = Get.parameters['uid'].toString();
    print(uid);
    print(title);
    final Stream<QuerySnapshot> _chatStream = FirebaseFirestore.instance
        .collection('Chats')
        .doc(id)
        .collection('messages')
        .orderBy('at', descending: false)
        .snapshots();

    final messageController = useTextEditingController();
    final ScrollController _scrollController = ScrollController();

    void send() {
      final displayName = FirebaseAuth.instance.currentUser?.displayName;
      final email = FirebaseAuth.instance.currentUser?.email;
      final userId = FirebaseAuth.instance.currentUser?.uid;
      FirebaseFirestore.instance
          .collection('Chats')
          .doc(id)
          .collection('messages')
          .add({
        "at": Timestamp.now(),
        "text": messageController.value.text,
        "author": displayName ?? email,
        "authorId": userId
      });
      messageController.value = TextEditingValue.empty;
    }

    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                }

                return ListView(
                  // controller: _scrollController,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    String id = document.id;

                    if (data['name'] == '') {
                      return Container();
                    }

                    var params = {"id": id, "name": data['name'].toString()};
                    // return Container(
                    //   child: Text(data['text']),
                    //   // title: Text(data['text']),
                    //   // subtitle: Text(data['author']),
                    // );
                    // _scrollController.animateTo(
                    //   0.0,
                    //   curve: Curves.easeOut,
                    //   duration: const Duration(milliseconds: 300),
                    // );

                    return Message(
                      text: data['text'].toString(),
                      author: data['author'].toString(),
                      authorId: data['authorId'].toString(),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.fromLTRB(10, 8, 0, GetPlatform.isIOS ? 30 : 8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    autofocus: true,
                    onFieldSubmitted: (text) {
                      send();
                    },
                  ),
                ),
                IconButton(
                    onPressed: send,
                    icon: Icon(
                      Icons.send,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
