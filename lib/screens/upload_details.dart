import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadDetailsScreen extends StatefulWidget {
  const UploadDetailsScreen({Key? key}) : super(key: key);

  @override
  State<UploadDetailsScreen> createState() => _UploadDetailsScreenState();
}

class _UploadDetailsScreenState extends State<UploadDetailsScreen> {
  var file;
  var loading = true;
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  @override
  initState() {
    setState(() {
      loading = true;
    });
    var arg = Get.arguments['file'];
    if (arg.runtimeType == 'Medium') {
      arg.getFile().then((File val) {
        setState(() {
          file = val;
          loading = false;
        });
        print(file.runtimeType);
      });
    } else {
      setState(() {
        file = arg;
        loading = false;
      });
    }
    super.initState();
  }

  submit() async {
    setState(() {
      loading = true;
    });
    //  STORAGE SECTION
    await FirebaseStorage.instance
        .ref(file.path)
        .putFile(file)
        .then((taskSnapshot) {
      print("task done");

      if (taskSnapshot.state == TaskState.success) {
        FirebaseStorage.instance.ref(file.path).getDownloadURL().then((url) {
          //  FIRESTORE SECTION
          var data = {
            "title": title.text,
            "description": description.text,
            "imageUrl": url,
            "authorUid": FirebaseAuth.instance.currentUser?.uid,
            "author": FirebaseAuth.instance.currentUser?.displayName,
            "at": Timestamp.now(),
          };
          FirebaseFirestore.instance.collection('Feed').add(data);

          setState(() {
            loading = false;
          });
          Get.offAndToNamed('/tabs', parameters: {"tabs": "1"});
        }).catchError((onError) {
          print("Got Error $onError");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: loading
          ? CircularProgressIndicator()
          : GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Your image",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Image.file(
                      file,
                      width: MediaQuery.of(context).size.width / 1.5,
                    ),
                  ]),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: title,
                          autofocus: true,
                          decoration: InputDecoration(label: Text('Title')),
                        ),
                        TextFormField(
                          controller: description,
                          decoration:
                              InputDecoration(label: Text('Description')),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                          onPressed: submit,
                          child: Text('Ok'),
                          color: Colors.blue,
                          textColor: Colors.white,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
