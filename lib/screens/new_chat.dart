import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

class NewChatScreen extends HookWidget {
  const NewChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = useTextEditingController();
    final description = useTextEditingController();
    void submit() {
      final ownerId = FirebaseAuth.instance.currentUser?.uid;
      final ownerName = FirebaseAuth.instance.currentUser?.displayName;
      final data = {
        "name": name.value.text,
        "description": description.value.text,
        "ownerId": ownerId,
        "ownerName": ownerName
      };
      FirebaseFirestore.instance.collection('Chats').add(data);
      Get.back();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('New Chat'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: name,
              onFieldSubmitted: (text) {
                submit();
              },
              decoration: InputDecoration(label: Text('Name')),
            ),
            TextFormField(
              controller: description,
              onFieldSubmitted: (text) {
                submit();
              },
              decoration: InputDecoration(label: Text('Description')),
            ),
            TextButton(onPressed: submit, child: Text('Submit'))
          ],
        ),
      ),
    );
  }
}
