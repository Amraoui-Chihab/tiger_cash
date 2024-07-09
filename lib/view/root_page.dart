import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tigercashiraq/view/profile_page.dart';

import '../utl/colors.dart';
import 'group_chat_page.dart';
import 'home_page.dart';
import 'taiker_store_page.dart';
import 'transfers_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;

  GetStorage box = GetStorage();
  List<Widget> page() {
    return [
      MyHomePage(),
      const GroupChatPage(),
      TransfersPage(),
      const TaikerStorePage(),
      ProfilePage(
          // user: controller.user.value,
          ),
    ];
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page()[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Ccolors.primry,
        unselectedItemColor: Colors.grey.shade900,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'دردشة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'الحوالات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'تايكر ستور',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}
