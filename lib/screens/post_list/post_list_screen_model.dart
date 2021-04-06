import 'package:flutter/material.dart';
import 'package:photo_daily_app/domain/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostListModel extends ChangeNotifier {
  List<Post> posts = [];

  Future fetchPosts() async {
    final docs = await FirebaseFirestore.instance.collection('posts').get();
    print(docs);
    print(docs.docs.length);
    print(docs.docs[0]['comment']);
    //final posts = docs.docs.map((doc) => Post(doc)).toList();
    final posts = docs.docs.map((item) {
      return Post(item);
    }).toList();
    this.posts = posts;
    notifyListeners();
  }

  Future deletePost(Post post) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(post.documentID)
        .delete();
  }
}
