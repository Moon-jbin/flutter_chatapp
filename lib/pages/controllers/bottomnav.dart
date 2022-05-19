import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messageapp/pages/components/talkroom.dart';
import 'package:messageapp/pages/profilepage.dart';
import '../components/image_add.dart';
import '../components/searchpage.dart';

// import '../profilepage.dart';

class BottomNavController extends GetxController {
  List<BottomNavigationBarItem> get bottomNavController => [
        const BottomNavigationBarItem(
            label: '소개',
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person)),
    const BottomNavigationBarItem(
        label: '친구찾기',
        icon: Icon(Icons.add_box_outlined),
        activeIcon: Icon(Icons.add_box_rounded)),
        const BottomNavigationBarItem(
            label: '대화방 입장',
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble)),
      ]; // bottomNavBar의 구성 코드이다.

  final RxInt _selectedIndex = 0.obs; // GetX로 인해 실시간으로 상태 관리

  int get selectedIndex => _selectedIndex.value; // get 으로 상태 정보 읽어오기

  void setSelectedIndex(int index) {
    _selectedIndex.value = index;
  }

  List pages = [
    Center(
      child: Text("HI")
      ),
    SearchPage(),
    // Center(child: SearchPage()),
    TalkRoom()
  ];
}
