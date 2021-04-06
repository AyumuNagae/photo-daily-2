import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String documentID;
  String comment;
  String imageURL;
  Timestamp createdAt;

  Post(DocumentSnapshot doc) {
    documentID = doc.id;
    comment = doc.data()['comment'];
    imageURL = doc.data()['imageURL'];
    createdAt = doc.data()['createdAt'];
  }
}
