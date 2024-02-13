import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pixmania/screens/other_screens/add_post.dart';
import 'package:pixmania/screens/chat_screen/chat_screen.dart';
import 'package:pixmania/screens/home_screen/home.dart';
import 'package:pixmania/screens/profile_screen/profile_screen.dart';
import 'package:pixmania/screens/search_screen/search_screen.dart';
import 'package:pixmania/services/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });
  static ValueNotifier<int> selectedBottomNotifier = ValueNotifier(0);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthServices auth = AuthServices();

  final _pages = [
    const Home(),
    const SearchScreen(),
    ChatScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AddPost(),
          ));
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.black87,
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder(
          valueListenable: HomeScreen.selectedBottomNotifier,
          builder: (ctx, int updatedINdex, _) {
            return Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: GNav(
                    selectedIndex: updatedINdex,
                    onTabChange: (value) {
                      HomeScreen.selectedBottomNotifier.value = value;
                    },
                    padding: const EdgeInsets.all(10),
                    activeColor: const Color.fromARGB(255, 207, 238, 230),
                    gap: 2,
                    backgroundColor: Colors.white,
                    tabBackgroundColor: const Color.fromARGB(255, 99, 116, 112),
                    tabs: const [
                      GButton(icon: Icons.home, text: "Home"),
                      GButton(icon: Icons.search, text: "Search"),
                      GButton(icon: Icons.chat, text: "Chat"),
                      GButton(icon: Icons.person, text: "Profile")
                    ]),
              ),
            );
          }),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: HomeScreen.selectedBottomNotifier,
          builder: (context, int updatedIndex, _) {
            return _pages[updatedIndex];
          },
        ),
      ),
    );
  }
}
