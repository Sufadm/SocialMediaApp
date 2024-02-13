//@@@@@@//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pixmania/constants/constants.dart';
import 'package:pixmania/widgets/common_widgets/name_logo.dart';
import 'homescreen_widgets/post_card_widget.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kboxDecoration,
      child: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            toolbarHeight: 70,
            floating: true,
            pinned: false,
            snap: false,
            backgroundColor: Colors.white,
            flexibleSpace: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: NamePixmania(),
            ),
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('dateTime', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                    child: Center(
                  child: SpinKitWaveSpinner(
                    size: 80,
                    color: Colors.teal,
                  ),
                ));
              } else if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              } else {
                final documents = snapshot.data!.docs;
                if (documents.isEmpty) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          const Center(child: Text('Not following anyone')),
                      childCount: 1,
                    ),
                  );
                } else {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => PostCard(snap: documents[index]),
                      childCount: documents.length,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
