import 'package:flutter/material.dart';
import 'package:photo_daily_app/domain/post.dart';
import 'package:photo_daily_app/screens/post_add/post_add_screen_model.dart';
import 'package:provider/provider.dart';

class PostAddScreen extends StatelessWidget {
  PostAddScreen({this.post});
  final Post post;
  @override
  Widget build(BuildContext context) {
    final bool isUpdate = post != null;
    final textEditingController = TextEditingController();

    if (isUpdate) {
      textEditingController.text = post.comment;
    }

    return ChangeNotifierProvider<PostAddModel>(
      create: (_) => PostAddModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isUpdate ? '編集する' : '投稿する'),
        ),
        body: Consumer<PostAddModel>(
          builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      await model.getImage();
                    },
                    child: SizedBox(
                      width: 160,
                      height: 160,
                      child: model.imageFile != null
                          ? Image.file(model.imageFile)
                          : Image.network(
                              'https://pics.prcm.jp/c3d1fa6ce8989/84374982/png/84374982.png'),
                      // : Container(
                      //     color: Colors.grey,
                      //   ),
                    ),
                  ),
                  TextField(
                    controller: textEditingController,
                    onChanged: (text) {
                      model.postComment = text;
                    },
                  ),
                  ElevatedButton(
                    child: Text(isUpdate ? '更新する' : '追加する'),
                    onPressed: () async {
                      if (isUpdate) {
                        await updatePost(model, context);
                      } else {
                        await addPost(model, context);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future addPost(PostAddModel model, BuildContext context) async {
    try {
      await model.addCommentToFirebase();
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('保存しました！'),
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
      Navigator.of(context).pop();
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.toString()),
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

  Future updatePost(PostAddModel model, BuildContext context) async {
    try {
      await model.updatePost(post);
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('更新しました'),
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
      Navigator.of(context).pop();
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.toString()),
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
}
