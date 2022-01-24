import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutgram/screens/auth.dart';
import 'package:flutgram/screens/chat.dart';
import 'package:flutgram/screens/new_chat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'components/chats.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(GetMaterialApp(
    getPages: [
      GetPage(name: '/', page: () => AuthScreen()),
      GetPage(name: '/chats', page: () => Home()),
      GetPage(name: '/chat', page: () => ChatScreen()),
      GetPage(name: '/new_chat', page: () => NewChatScreen()),
    ],
  ));
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    firebaseAuth.authStateChanges().listen((User? user) {
      if (user == null) {
        Get.offAllNamed('/');
      }
    });
    void logout() {
      firebaseAuth.signOut();
    }

    void newChat() {
      Get.toNamed('/new_chat');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: newChat, child: Icon(Icons.add)),
      body: Center(child: Chats()),
    );
  }
}
