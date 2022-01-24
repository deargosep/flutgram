import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  Message({Key? key, required String this.text, required String this.author})
      : super(key: key);
  String text;
  String author;

  @override
  Widget build(BuildContext context) {
    if (text == "") {
      return Container();
    }
    return Container(
        margin: EdgeInsets.all(5),
        child: Card(
          child: ListTile(
            title: Text(text),
            subtitle: Text(author),
          ),
        ));
  }
}
