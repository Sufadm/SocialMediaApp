import 'package:flutter/material.dart';
import 'package:pixmania/providers/userprovider.dart';
import 'package:pixmania/screens/authenticate/login_screen.dart';
import 'package:pixmania/screens/home_screen/home_screen.dart';
import 'package:pixmania/models/model.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    addData() async {
      UserProvider userProvider = Provider.of(context, listen: false);
      await userProvider.refreshUser();
    }

    final user = Provider.of<UserModel?>(context);

    if (user == null) {
      return const LoginScreen();
    } else {
      addData();
      return const HomeScreen();
    }
  }
}
