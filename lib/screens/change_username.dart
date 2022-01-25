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
