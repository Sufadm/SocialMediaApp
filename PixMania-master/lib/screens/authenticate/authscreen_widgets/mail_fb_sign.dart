import 'package:flutter/material.dart';
import 'package:pixmania/constants/constants.dart';

class SignInOptions extends StatelessWidget {
  const SignInOptions({super.key, required this.imagePath});
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      foregroundColor: scafoldBg,
      backgroundColor: scafoldBg,
      radius: 18,
      child: Image.asset(imagePath),
    );
  }
}
