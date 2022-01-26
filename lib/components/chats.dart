import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
            final uid = FirebaseAuth.instance.currentUser?.uid;
            if (data['name'] == '') {
              return Container();
            }
            if (data['ownerId'] == null &&
                (data['firstUser'] != uid && data['secondUser'] != uid)) {
              return Container();
            }
            bool isMine() {
              if (data['ownerId'] == uid.toString()) {
                return true;
              } else if (data['firstUser'] == uid ||
                  data['secondUser'] == uid) {
                return true;
              } else {
                return false;
              }
            }

            bool isPrivate() {
              if (data['private'] == true) {
                return true;
              } else {
                return false;
              }
            }

            void deleteChat(context) {
              Get.defaultDialog(
                  textConfirm: 'Yes',
                  textCancel: 'No',
                  middleText: 'Are you sure you wanna delete this chat?',
                  onConfirm: () {
                    FirebaseFirestore.instance
                        .collection('Chats')
                        .doc(id)
                        .delete();
                    Get.back();
                  });
            }

            var params = {
              "id": id,
              "name": data['name'].toString(),
              "isPrivate": isPrivate() ? 'true' : 'false'
            };
            return Slidable(
              enabled: isMine(),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                      backgroundColor: Colors.red,
                      label: 'Delete',
                      icon: Icons.delete,
                      onPressed: deleteChat)
                ],
              ),
              key: Key(id),
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      onTap: () {
                        Get.toNamed('/chat', parameters: params);
                      },
                      title: Text(data['name']),
                      subtitle: Text(data['description'] ?? ''),
                      // trailing: Container(
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius:
                      //           BorderRadius.all(Radius.circular(20))),
                      //   width: 10,
                      //   height: 10,
                      // ),
                    ),
                  ),
                  SizedBox(
                    child: Container(
                      color: isMine() ? Colors.red : Colors.white,
                      width: 2,
                      height: 70,
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
