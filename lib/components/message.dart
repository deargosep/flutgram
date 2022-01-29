import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  Message(
      {Key? key,
      required String this.text,
      required String this.author,
      required String this.authorId,
      required String this.time,
      required bool this.isPrivate})
      : super(key: key);
  final String authorId;
  final String text;
  final String author;
  final String time;
  final bool isPrivate;
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
                title: SelectableText(text),
                subtitle: isPrivate ? null : Text(author),
                trailing: Text('${time}'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
