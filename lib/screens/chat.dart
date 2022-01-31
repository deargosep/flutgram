import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutgram/components/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class ChatScreen extends HookWidget {
  const ChatScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final messageController = TextEditingController();
    final ScrollController _scrollController = ScrollController();

    final typing = useState(false);

    final title = Get.parameters['name'].toString();
    final id = Get.parameters['id'].toString();
    // final uid = Get.parameters['uid'].toString();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final isPrivate = Get.parameters['isPrivate'].toString();

    Future<bool> getTyping() async {
      final typing =
          await FirebaseFirestore.instance.collection('Chats').doc(id).get();
      if (typing.data()!.containsKey('key') && typing.data()!['typing']) {
        return true;
      } else {
        return false;
      }
    }

    Stream typingStream = getTyping().asStream();

    typingStream.listen((event) {
      typing.value = event;
    });
    Timer searchOnStoppedTyping = Timer(Duration.zero, () {});

    search(value) {
      print('hello world from search . the value is $value');
    }

    _onChangeHandler(value) {
      const duration = Duration(
          milliseconds:
              800); // set the duration that you want call search() after that.
      if (searchOnStoppedTyping != null) {
        searchOnStoppedTyping.cancel(); // clear timer
        FirebaseFirestore.instance
            .collection('Chats')
            .doc(id)
            .update({"typing": true, "typer": uid});
      }

      searchOnStoppedTyping = new Timer(duration, () => search(value));
      FirebaseFirestore.instance
          .collection('Chats')
          .doc(id)
          .update({"typing": false});
    }

    // void subscribe() async {
    //   await FirebaseMessaging.instance.subscribeToTopic(id);
    // http.post(Uri.parse('localhost:3000/'), body: {"topic": id});
    // }

    final Stream<QuerySnapshot> _chatStream = FirebaseFirestore.instance
        .collection('Chats')
        .doc(id)
        .collection('messages')
        .orderBy('at', descending: true)
        .snapshots();

    final Stream<DocumentSnapshot> _chatDocStream =
        FirebaseFirestore.instance.collection('Chats').doc(id).snapshots();

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
        "text": messageController.text,
        "author": displayName ?? email,
        "authorId": userId
      });
      messageController.clear();
    }

    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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

                return GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  onHorizontalDragEnd: (details) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: ListView(
                    reverse: true,
                    shrinkWrap: true,
                    controller: _scrollController,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      // String id = document.id;

                      final Timestamp timestamp = data['at'] as Timestamp;
                      final DateTime dateTime = timestamp.toDate();
                      final dateString = DateFormat('H:mm').format(dateTime);

                      if (data['name'] == '') {
                        return Container();
                      }

                      // var params = {"id": id, "name": data['name'].toString()};
                      // return Container(
                      //   child: Text(data['text']),
                      //   // title: Text(data['text']),
                      //   // subtitle: Text(data['author']),
                      // );
                      // try {
                      //   _scrollController.animateTo(
                      //     0.0,
                      //     curve: Curves.easeOut,
                      //     duration: const Duration(milliseconds: 300),
                      //   );
                      // } catch (e) {}

                      return Message(
                          text: data['text'].toString(),
                          author: data['author'].toString(),
                          authorId: data['authorId'].toString(),
                          time: dateString,
                          isPrivate: isPrivate == 'true' ? true : false);
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          StreamBuilder<DocumentSnapshot>(
              stream: _chatDocStream,
              builder: (context, snapshot) {
                final data = snapshot.data;
                Map<String, dynamic> json =
                    data?.data() as Map<String, dynamic>;
                if (json['typing'] != null &&
                    json['typing'] &&
                    json['typer'] != uid) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Typing...',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.fromLTRB(10, 8, 0, GetPlatform.isIOS ? 20 : 8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    controller: messageController,
                    autofocus: true,
                    onChanged: _onChangeHandler,
                    onFieldSubmitted: (text) => send(),
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
