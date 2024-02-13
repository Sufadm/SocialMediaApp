// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixmania/constants/constants.dart';
import 'package:pixmania/providers/userprovider.dart';
import 'package:pixmania/models/usermodel.dart';
import 'package:pixmania/services/firestore.dart';
import 'package:pixmania/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? _file;

  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  void postImage(String uid, String userName, String profileImage) async {
    try {
      String res = await FireStore().uploadPost(
          _descriptionController.text, _file!, uid, userName, profileImage);

      if (res == 'Success') {
        showSnackBar(context, 'Posted');
        Navigator.of(context).pop();
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: scafoldBg,
          title: const Text('Create a Post'),
          children: [
            const Divider(),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            // const Divider(),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            const Divider(),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserData user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Scaffold(
            body: SafeArea(
              child: Container(
                decoration: kboxDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back_ios)),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  _selectImage(context);
                                },
                                icon: const Icon(
                                  Icons.upload_file_outlined,
                                  size: 45,
                                )),
                            kbox10,
                            Text("Let's share the precious moments...",
                                style: GoogleFonts.monoton(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Post to'),
            ),
            body: SafeArea(
                child: Container(
              decoration: kboxDecoration,
              child: Column(
                children: [
                  kbox20,
                  isLoading
                      ? const LinearProgressIndicator()
                      : const SizedBox(),
                  kbox10,
                  Text("Let's share the precious moments...",
                      style: GoogleFonts.monoton(fontSize: 16)),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          user.profileImage!,
                          //  "https://p.kindpng.com/picc/s/24-248253_user-profile-default-image-png-clipart-png-download.png"
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: TextField(
                          maxLength: 100,
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                              hintText: "Write a caption...",
                              border: InputBorder.none),
                          maxLines: 8,
                        ),
                      ),
                      SizedBox(
                        height: 70.0,
                        width: 70.0,
                        child: AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                              image: MemoryImage(_file!),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          postImage(
                              user.uid, user.userName!, user.profileImage!);
                          setState(() {
                            isLoading = true;
                          });
                        },
                        label: const Text(
                          'Post',
                          style: TextStyle(fontSize: 22),
                        ),
                        icon: const Icon(Icons.arrow_circle_right_outlined),
                      )
                    ],
                  )
                ],
              ),
            )),
          );
  }
}
