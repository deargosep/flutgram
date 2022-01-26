import 'dart:io';

import 'package:flutgram/components/gallery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  @override
  Widget build(BuildContext context) {
    File? file;
    void takeImage() async {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      setState(() {
        file = File(pickedFile!.path);
      });
      Get.toNamed('/upload/details', arguments: {"file": file});
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Upload image'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: takeImage,
          child: Icon(Icons.camera),
        ),
        body: Gallery());
  }
}
