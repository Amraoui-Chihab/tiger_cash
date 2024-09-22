import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tigercashiraq/view/profile/profile_page.dart';
import 'package:tigercashiraq/view/videos/videos_veiw.dart';

import '../../utl/colors.dart';
import '../chat/group_chat_page.dart';
import 'home_page.dart';
import '../store/taiker_store_page.dart';
import '../transfers_page.dart';

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
      const PageViewExample(),
      const TaikerStorePage(),
      TransfersPage(),
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
        showUnselectedLabels: false,
        showSelectedLabels: true,
        currentIndex: _currentIndex,
        onTap: _onTap,
        items:  [
          BottomNavigationBarItem(
            icon: Image.asset("assets/home.png",height: 35,),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/entertainment.png",height: 40,),
            label: 'الترفيه',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/reel.png",height: 40,),
            label: 'ريلز',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/store2.png",height: 40,),
            label: 'ستور',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/transaction.png",height: 40,),
            label: 'الحوالات',
          ),
          BottomNavigationBarItem(

            icon: Image.asset("assets/profile.png",height: 40,),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}
