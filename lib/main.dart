import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutgram/components/drawer.dart';
import 'package:flutgram/screens/auth.dart';
import 'package:flutgram/screens/change_username.dart';
import 'package:flutgram/screens/chat.dart';
import 'package:flutgram/screens/chats.dart';
import 'package:flutgram/screens/contacts.dart';
import 'package:flutgram/screens/new_chat.dart';
import 'package:flutgram/screens/settings.dart';
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
      GetPage(
          name: '/', page: () => Home(), transition: Transition.noTransition),
      GetPage(
          name: '/auth',
          page: () => AuthScreen(),
          transition: Transition.noTransition),
      GetPage(
          name: '/chats',
          page: () => ChatsScreen(),
          transition: Transition.noTransition),
      GetPage(
          name: '/chat',
          page: () => ChatScreen(),
          showCupertinoParallax: false),
      GetPage(name: '/new_chat', page: () => NewChatScreen()),
      GetPage(name: '/settings', page: () => SettingsScreen()),
      GetPage(
          name: '/settings/change_username',
          page: () => ChangeUsernameScreen()),
      GetPage(name: '/contacts', page: () => ContactsScreen()),
    ],
  ));
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        Get.offAllNamed('/auth');
      } else {
        Get.offAllNamed('/chats');
      }
    });
    return Container(
      color: Colors.white,
    );
  }
}
