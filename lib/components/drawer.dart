import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProfileDrawer extends StatelessWidget {
  ProfileDrawer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  FirebaseAuth.instance.currentUser?.displayName ?? '',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(
                        text: FirebaseAuth.instance.currentUser?.uid));
                  },
                  child: Text(
                    FirebaseAuth.instance.currentUser?.uid ?? '',
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.contacts),
            title: const Text('Contacts'),
            onTap: () {
              Get.toNamed('/contacts');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Get.toNamed('/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Get.defaultDialog(
                  middleText: 'Log out?',
                  textConfirm: 'Yes',
                  textCancel: 'No',
                  onConfirm: () {
                    FirebaseAuth.instance.signOut();
                  });
            },
          ),
        ],
      ),
    );
  }
}
