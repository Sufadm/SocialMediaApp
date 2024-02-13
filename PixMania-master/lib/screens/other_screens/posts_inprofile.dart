import 'package:flutter/material.dart';
import 'package:pixmania/constants/constants.dart';

import '../home_screen/homescreen_widgets/post_card_widget.dart';

class ViewPost extends StatelessWidget {
  const ViewPost({super.key, required this.snap});
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Posts'),
      ),
      body: SafeArea(
        child: Container(
          decoration: kboxDecoration,
          child: SingleChildScrollView(
            child: SizedBox(
              // width: double.infinity,
              child: PostCard(snap: snap),
            ),
          ),
        ),
      ),
    );
  }
}
