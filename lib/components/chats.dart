import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Chats extends StatelessWidget {
  Chats({Key? key}) : super(key: key);

  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _chatsStream =
      FirebaseFirestore.instance.collection('Chats').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            String id = document.id;

            if (data['name'] == '') {
              return Container();
            }

            var params = {"id": id, "name": data['name'].toString()};
            return ListTile(
              onTap: () {
                Get.toNamed('/chat', parameters: params);
              },
              title: Text(data['name']),
              subtitle: Text(data['description']),
            );
          }).toList(),
        );
      },
    );
  }
}
