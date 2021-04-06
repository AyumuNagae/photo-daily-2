import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_daily_app/domain/post.dart';

class PostAddModel extends ChangeNotifier {
  String postComment = '';
  File imageFile;
  String imageURL = '';

  // File _image;
  // final picker = ImagePicker();
  //
  // Future getImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.camera);
  //
  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  Future getImage() async {
    final picker = ImagePicker();
    print('あいうえお');
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    print('かきくけこ');

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    print(pickedFile);
    notifyListeners();
  }

  Future addCommentToFirebase() async {
    if (postComment.isEmpty) {
      throw ('タイトルを入力してください');
    }

    final imageURL = await uploadImage();

    FirebaseFirestore.instance.collection('posts').add(
      {
        'comment': postComment,
        'createdAt': Timestamp.now(),
        'imageURL': imageURL,
      },
    );
  }

  Future updatePost(Post post) async {
    final imageURL = await uploadImage();

    final document =
        FirebaseFirestore.instance.collection('posts').doc(post.documentID);
    document.update(
      {
        'comment': postComment,
        'createdAt': Timestamp.now(),
        'imageURL': imageURL,
      },
    );
  }

  // Future<String> uploadImage() async {
  //   //　FireStorageへアップロードする
  //   final storage = FirebaseStorage.instance;
  //   StorageTaskSnapshot snapshot = await storage.ref()
  //
  //
  //   return 'https://pbs.twimg.com/profile_images/1338095810387431425/yGf7Sbxh_400x400.jpg';
  // }

  Future<String> uploadImage() async {
    if (imageFile == null) {
      return 'https://pbs.twimg.com/profile_images/1338095810387431425/yGf7Sbxh_400x400.jpg';
    }
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('posts').child(postComment);
    final snapshot = await ref.putFile(
      imageFile,
    );
    final downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }
}
