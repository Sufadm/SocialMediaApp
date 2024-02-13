// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixmania/screens/authenticate/authscreen_widgets/appbar.dart';
import 'package:pixmania/constants/constants.dart';
import 'package:pixmania/widgets/common_widgets/formfeild.dart';
import 'package:pixmania/widgets/common_widgets/submit_button.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController userIdController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  String error = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: const CustomAppbar(),
        title: Image.asset("assets/logo/logo_transparent.png"),
        automaticallyImplyLeading: false,
        toolbarHeight: 130,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Text("Let's share the precious moments...",
                      style: GoogleFonts.monoton(fontSize: 16)),
                  kbox20,
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_ios_new)),
                      const Text(
                        'Reset password',
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                  kbox20,
                  CustomFormfield(
                    controller: userIdController,
                    label: 'E-mail',
                    hintText: 'Enter your E-mail',
                  ),
                  SubmitButton(
                      title: 'Send reset mail',
                      onpressfun: () => resetPassword(context)),
                  Text(error),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void resetPassword(BuildContext context) async {
    if (formkey.currentState?.validate() ?? false) {
      try {
        await _auth.sendPasswordResetEmail(email: userIdController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent.'),
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send reset email. Please try again.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
