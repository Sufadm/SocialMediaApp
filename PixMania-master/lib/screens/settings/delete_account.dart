// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixmania/constants/constants.dart';
import 'package:pixmania/screens/authenticate/login_screen.dart';
import 'package:pixmania/services/auth.dart';
import 'package:pixmania/utils/utils.dart';
import 'package:pixmania/widgets/common_widgets/formfeild.dart';
import 'package:pixmania/widgets/common_widgets/submit_button.dart';

import '../authenticate/authscreen_widgets/appbar.dart';

class DeleteAccount extends StatefulWidget {
  DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final formkey = GlobalKey<FormState>();

  String error = '';

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

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
                        'Delete Account permanently',
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                  kbox20,
                  CustomFormfield(
                    controller: emailController,
                    label: 'E-mail',
                    hintText: 'Enter your E-mail',
                  ),
                  CustomFormfield(
                    controller: passwordController,
                    label: 'Password',
                    hintText: 'Enter your Password',
                  ),
                  isLoading
                      ? const SpinKitWaveSpinner(
                          color: Colors.teal,
                        )
                      : SubmitButton(
                          title: 'Delete Account',
                          onpressfun: () {
                            if (emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty) {
                              setState(() {
                                isLoading = true;
                              });
                              AuthServices().deleteAccount(
                                  emailController.text.trim(),
                                  passwordController.text.trim());
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                  (route) => false);
                            } else {
                              showSnackBar(
                                  context, 'Enter valid email or password');
                            }
                          }),
                  Text(error),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
