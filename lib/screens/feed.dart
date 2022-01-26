import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedScreen extends StatelessWidget {
  FeedScreen({Key? key}) : super(key: key);

  final Stream<QuerySnapshot> _feedStream =
      FirebaseFirestore.instance.collection('Feed').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Get.toNamed('/upload');
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _feedStream,
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
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.network(data['imageUrl'])),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          data['title'],
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          data['description'],
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.favorite,
                    color: Colors.blue,
                  )
                ],
              ),
            );
          }).toList());
        },
      ),
    );
  }
}
