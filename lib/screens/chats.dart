import 'package:flutgram/components/chats.dart';
import 'package:flutgram/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void newChat() {
      Get.toNamed('/new_chat');
    }

    return Scaffold(
      drawer: ProfileDrawer(),
      appBar: AppBar(
        title: Text('Chats'),
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: newChat, child: Icon(Icons.add)),
      body: Center(child: Chats()),
    );
  }
}
