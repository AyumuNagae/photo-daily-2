import 'package:flutter/material.dart';
import 'package:photo_daily_app/screens/post_list/post_list_screen.dart';

class DailyPhotoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Photo',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: PostListScreen(),
    );
  }
}
