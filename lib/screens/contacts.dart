import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:get/get.dart';

class User {
  final String? name;
  final String? uid;

  User({this.name, this.uid});

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this User
  //This function in essential to the working of FirestoreSearchScaffold

  List<User> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;

      return User(name: dataMap['name'], uid: dataMap['uid']);
    }).toList();
  }
}

class ContactsScreen extends HookWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void goToUser(uid, name) async {
      var myName = FirebaseAuth.instance.currentUser?.displayName;
      var myUid = FirebaseAuth.instance.currentUser?.uid;
      List listOfUids = [myUid, uid];
      listOfUids.sort((a, b) => a.compareTo(b));
      String newId = '${listOfUids[0]}-${listOfUids[1]}';
      var data = {
        "private": true,
        "name": '${myName} and ${name}',
        "description": 'Private chat',
        "users": [myUid, uid],
        "firstUser": myUid,
        "secondUser": uid
      };

      await FirebaseFirestore.instance
          .collection('Chats')
          .doc('${newId}')
          .set(data);

      final chat = await FirebaseFirestore.instance
          .collection('Chats')
          .doc('${myUid}-${uid}');
      final doc = await chat.get();

      var params = {
        "uid": uid.toString(),
        "name": doc.data()!["name"].toString(),
        "id": chat.id,
        "isPrivate": 'true'
      };

      Get.offAndToNamed('chat', parameters: params);
    }

    return Scaffold(
        body: FirestoreSearchScaffold(
      firestoreCollectionName: 'Users',
      searchBy: 'name',
      scaffoldBody: Center(),
      dataListFromSnapshot: User().dataListFromSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<User>? dataList = snapshot.data;
          if (dataList!.isEmpty) {
            return const Center(
              child: Text('No Results Returned'),
            );
          }
          return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final User data = dataList[index];

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () {
                        goToUser(data.uid, data.name);
                      },
                      title: Text(
                        '${data.name}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ],
                );
              });
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No Results Returned'),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }
}
