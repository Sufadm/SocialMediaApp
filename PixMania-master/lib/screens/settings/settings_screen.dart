import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pixmania/constants/constants.dart';
import 'package:pixmania/screens/settings/about_us.dart';
import 'package:pixmania/screens/settings/delete_account.dart';
import 'package:pixmania/screens/settings/edit_profile.dart';
import 'package:pixmania/services/auth.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:share_plus/share_plus.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  AuthServices auth = AuthServices();

  FirebaseAuth user = FirebaseAuth.instance;

  // Uint8List? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: Container(
          decoration: kboxDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                label: const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const EditProfile(),
                  ));
                },
                icon: const Icon(Icons.person),
              ),
              const Divider(),
              TextButton.icon(
                label: const Text(
                  'About Us',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AboutUs(),
                  ));
                },
                icon: const Icon(Icons.info),
              ),
              const Divider(),
              TextButton.icon(
                label: const Text(
                  'Log Out',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  AwesomeDialog(
                    dialogBackgroundColor: scafoldBg,

                    context: context,
                    dialogType: DialogType
                        .warning, // Change it as per your requirements
                    animType: AnimType.scale,
                    title: 'Log out?',
                    desc: 'Log out from this User',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async {
                      logOut();
                      Navigator.of(context).pop();
                    },
                  ).show();
                },
                icon: const Icon(Icons.logout),
              ),
              const Divider(),
              //delete accnt
              TextButton.icon(
                label: const Text(
                  'Delete Account',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  AwesomeDialog(
                    dialogBackgroundColor: scafoldBg,
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.scale,
                    title: 'Delete the account?',
                    desc: 'The account will be deleted permanently',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DeleteAccount(),
                      ));
                    },
                  ).show();
                },
                icon: const Icon(Icons.delete_forever_outlined),
              ),
              const Divider(),
              TextButton.icon(
                label: const Text(
                  'Feedback',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  AwesomeDialog(
                    dialogBackgroundColor: scafoldBg,
                    context: context,
                    dialogType: DialogType.infoReverse,
                    animType: AnimType.scale,
                    title: 'Mail Us',
                    desc: 'Press ok to feedback mail ',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async {
                      launchUrlString('mailto:nanohardbro@gmail.com');
                    },
                  ).show();
                },
                icon: const Icon(Icons.mail_outline_outlined),
              ),
              const Divider(),
              TextButton.icon(
                label: const Text(
                  'Share',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Share.share('pixMania');
                },
                icon: const Icon(Icons.share),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }

  void logOut() async {
    await auth.signout();
  }
}
