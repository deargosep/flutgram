import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          SettingsItem(
            title: 'Change username',
            onTap: () {
              Get.toNamed('settings/change_username');
            },
          )
        ],
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  String title;

  final VoidCallback? onTap;

  SettingsItem({Key? key, required String this.title, VoidCallback? this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
      trailing: Icon(Icons.chevron_right),
    );
  }
}
