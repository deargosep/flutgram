import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutgram/screens/auth.dart';
import 'package:flutgram/screens/chat.dart';
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
      } else {}
    });
    void logout() {
      firebaseAuth.signOut();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      body: Center(child: Chats()),
    );
  }
}
