import 'package:flutter/material.dart';

class NamePixmania extends StatelessWidget {
  const NamePixmania({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 220,
      height: 50,
      decoration: BoxDecoration(
        // color: Colors.white, // Optional container color
        borderRadius: BorderRadius.circular(10), // Optional border radius
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo/camLogo.png', // Replace with your own image path
            fit: BoxFit.cover, // Adjust the fit as needed
            height: 32,
          ),
          const SizedBox(
            width: 5,
          ),
          Image.asset(
            'assets/logo/logo trim.png', // Replace with your own image path
            fit: BoxFit.fill, // Adjust the fit as needed
          ),
        ],
      ),
    );
  }
}
