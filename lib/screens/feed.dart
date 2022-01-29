import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedScreen extends StatelessWidget {
  FeedScreen({Key? key}) : super(key: key);

  final Stream<QuerySnapshot> _feedStream = FirebaseFirestore.instance
      .collection('Feed')
      .orderBy('at', descending: true)
      .snapshots();

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
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

            String id = document.id;
            final uid = FirebaseAuth.instance.currentUser?.uid;
            bool liked() {
              if (data['likedBy'] != null && data['likedBy'].contains(uid)) {
                return true;
              } else {
                return false;
              }
            }

            void like() {
              if (data['likedBy'] != null && data['likedBy'].contains(uid)) {
                List likes = data['likedBy'];
                likes.removeWhere((item) => item == uid);
                FirebaseFirestore.instance
                    .collection('Feed')
                    .doc(id)
                    .update({"likedBy": likes});
              } else if (data['likedBy'] != null) {
                List likes = data['likedBy'];
                likes.add(uid);
                FirebaseFirestore.instance
                    .collection('Feed')
                    .doc(id)
                    .update({"likedBy": likes});
              } else {
                List likes = [];
                likes.add(uid);
                FirebaseFirestore.instance
                    .collection('Feed')
                    .doc(id)
                    .update({"likedBy": likes});
              }
            }

            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.white70),
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      data['imageUrl'],
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          data['likedBy']?.length.toString() ?? '${0}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 10, 8),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: like,
                            icon: Icon(liked()
                                ? Icons.favorite
                                : Icons.favorite_outline),
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
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
