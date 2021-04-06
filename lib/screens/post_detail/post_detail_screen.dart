import 'package:flutter/material.dart';
import 'package:photo_daily_app/screens/post_add/post_add_screen.dart';

class PostDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('詳細'),
      ),
      body: const Center(
        child: Text('投稿の詳細ページ 編集できるようにする'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              fullscreenDialog: true,
              builder: (context) => PostAddScreen(),
            ),
          );
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
