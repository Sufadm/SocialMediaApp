import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pixmania/screens/other_screens/visit_profile.dart';
import 'package:pixmania/models/usermodel.dart';

class SearchSuggestions extends StatelessWidget {
  const SearchSuggestions({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('profileImage',
                isNotEqualTo:
                    'https://firebasestorage.googleapis.com/v0/b/pixmania-182c7.appspot.com/o/profilePics%2FcamLogo.png?alt=media&token=6994a6f8-fc44-4dfa-a328-c964db9a19d8')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: SpinKitWaveSpinner(
              size: 80,
              color: Colors.teal,
            ));
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          final documents = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: documents.length,
              itemBuilder: (BuildContext context, int index) {
                // Post user = Post.fromSnap(documents[index]);
                UserData user = UserData.fromSnap(documents[index]);
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          VisitProfile(snap: documents[index]),
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(user.profileImage!))),
                    // child: Image.network(
                    //   documents[index].data()['postUrl'],
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                );
              },
            ),
          );
        });
  }
}
