import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/talkroom.dart';

class BottomNavController extends GetxController {
  List<BottomNavigationBarItem> get bottomNavController => [
        const BottomNavigationBarItem(
            label: '친구', icon: Icon(Icons.person_outline)),
        const BottomNavigationBarItem(
            label: '대화방', icon: Icon(Icons.chat_bubble_outline)),
      ];

  final RxInt _selectedIndex = 0.obs;

  int get selectedIndex => _selectedIndex.value;

  void setSelectedIndex(int index) {
    _selectedIndex.value = index;
  }

  List pages = [
    Container(
      child: const Center(
        child: Text("1번입니다."),
      ),
    ),
     TalkRoom()
  ];
}
