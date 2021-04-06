import 'package:flutter/material.dart';
import 'package:photo_daily_app/screens/post_add/post_add_screen.dart';
import 'package:photo_daily_app/screens/post_list/post_list_screen_model.dart';
import 'package:provider/provider.dart';
import 'package:photo_daily_app/domain/post.dart';

class PostListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PostListModel>(
      //create: (_) {
      //  final a = PostListModel();
      //  a.fetchPosts();
      //  return a;
      // },
      create: (_) => PostListModel()..fetchPosts(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('フォト日記アプリ'),
        ),
        body: Consumer<PostListModel>(
          builder: (context, model, child) {
            final posts = model.posts;
            final cards = posts
                .map(
                  (post) => ListTile(
                    leading: Image.network(post.imageURL),
                    title: Text(post.comment),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            fullscreenDialog: true,
                            builder: (context) => PostAddScreen(
                              post: post,
                            ),
                          ),
                        );
                        model.fetchPosts();
                      },
                    ),
                    onLongPress: () async {
                      // todo: 削除
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('${post.comment}を削除しますか？'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () async {
                                  Navigator.of(context).pop();

                                  await deletePost(model, context, post);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                )
                .toList();
            print('配列 cards の長さ：${cards.length}');
            return ListView(
              children: cards,
            );
          },
        ),
        floatingActionButton:
            Consumer<PostListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute<void>(
                  fullscreenDialog: true,
                  builder: (context) => PostAddScreen(),
                ),
              );
              model.fetchPosts();
            },
            child: Icon(Icons.add),
          );
        }),
      ),
    );
  }

  Future deletePost(
    PostListModel model,
    BuildContext context,
    Post post,
  ) async {
    try {
      await model.deletePost(post);
      await model.fetchPosts();
    } catch (e) {
      await _showDialog(context, e.toString());
      print(e.toString());
    }
  }

  Future _showDialog(
    BuildContext context,
    String title,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
