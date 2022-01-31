import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutgram/screens/auth.dart';
import 'package:flutgram/screens/change_username.dart';
import 'package:flutgram/screens/chat.dart';
import 'package:flutgram/screens/chats.dart';
import 'package:flutgram/screens/contacts.dart';
import 'package:flutgram/screens/new_chat.dart';
import 'package:flutgram/screens/settings.dart';
import 'package:flutgram/screens/tabs.dart';
import 'package:flutgram/screens/upload.dart';
import 'package:flutgram/screens/upload_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  runApp(GetMaterialApp(
    getPages: [
      GetPage(
          name: '/', page: () => Home(), transition: Transition.noTransition),
      GetPage(
          name: '/auth',
          page: () => AuthScreen(),
          transition: Transition.noTransition),
      GetPage(
          name: '/tabs',
          page: () => TabScreen(),
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
      GetPage(name: '/upload', page: () => UploadScreen()),
      GetPage(name: '/upload/details', page: () => UploadDetailsScreen()),
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
        Get.offAllNamed('/tabs');
      }
    });
    return Container(
      color: Colors.white,
    );
  }
}
