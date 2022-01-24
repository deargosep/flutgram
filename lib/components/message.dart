import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  Message(
      {Key? key,
      required String this.text,
      required String this.author,
      required String this.authorId})
      : super(key: key);
  String authorId;
  String text;
  String author;

  @override
  Widget build(BuildContext context) {
    if (text == "") {
      return Container();
    }
    bool getCurrentUser() {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (authorId == uid) {
        return true;
      } else {
        return false;
      }
    }

    return Row(
      mainAxisAlignment:
          getCurrentUser() ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(5),
          child: SizedBox(
            width: 300,
            child: Card(
              child: ListTile(
                title: Text(text),
                subtitle: Text(author),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
