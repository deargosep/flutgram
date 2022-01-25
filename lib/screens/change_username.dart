import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

class ChangeUsernameScreen extends HookWidget {
  const ChangeUsernameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = useTextEditingController();
    void submit() {
      FirebaseAuth.instance.currentUser?.updateDisplayName(name.value.text);
      var data = {"name": name.value.text};
      final uid = FirebaseAuth.instance.currentUser?.uid;
      var docId = '';
      FirebaseFirestore.instance
          .collection('Users')
          .where('uid', isEqualTo: uid)
          .get()
          .then((value) => docId = value.docs.first.id);
      FirebaseFirestore.instance.collection('Users').doc(docId).update(data);
      Get.back();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Change username'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: submit,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: TextFormField(
            controller: name,
            onFieldSubmitted: (text) {
              submit();
            },
            decoration: InputDecoration(label: Text('Name')),
          ),
        ),
      ),
    );
  }
}
