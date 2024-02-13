import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixmania/models/usermodel.dart';
import 'package:pixmania/providers/userprovider.dart';
import 'package:pixmania/services/firestore.dart';
import 'package:pixmania/utils/utils.dart';
import 'package:pixmania/widgets/common_widgets/formfeild.dart';
import 'package:pixmania/widgets/common_widgets/submit_button.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();

  TextEditingController bioController = TextEditingController();

  Uint8List? selectedImage;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Stack(
                children: [
                  selectedImage == null
                      ? CircleAvatar(
                          radius: 65,
                          backgroundImage: NetworkImage(user.profileImage!),
                        )
                      : CircleAvatar(
                          radius: 65,
                          backgroundImage: MemoryImage(selectedImage!),
                        ),
                  Positioned(
                    bottom: 0,
                    right: -5,
                    child: IconButton(
                      onPressed: () {
                        imagepick();
                      },
                      icon: const Icon(
                        Icons.add_a_photo,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
              CustomFormfield(
                controller: nameController,
                hintText: 'Enter Username',
                label: 'Username',
                length: 15,
              ),
              CustomFormfield(
                controller: bioController,
                hintText: 'Tell about yourself',
                label: 'Bio',
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : SubmitButton(
                      title: 'Save Changes',
                      onpressfun: () async {
                        if (selectedImage != null &&
                            nameController.text.isNotEmpty &&
                            bioController.text.isNotEmpty) {
                          setState(() {
                            isLoading = true;
                          });

                          saveProfile(nameController.text, bioController.text,
                              selectedImage, context);
                          Navigator.of(context).pop();
                        } else {
                          showSnackBar(context,
                              "Select an Image and  feilds can't be empty");
                        }
                      })
            ],
          ),
        ),
      ),
    );
  }

  void saveProfile(
    String userName,
    String bio,
    Uint8List? image,
    BuildContext context,
  ) {
    if (image != null) {
      FireStore().uploadProfile(userName, bio, image, context);
    } else {
      showSnackBar(context, 'select an image');
      // Handle the case when no image is selected
    }
  }

  void imagepick() async {
    Uint8List? image = await pickImage(ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  Future<Uint8List?> pickImage(ImageSource imageSource) async {
    ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: imageSource);
    if (file != null) {
      return file.readAsBytes();
    }
    return null;
  }
}
