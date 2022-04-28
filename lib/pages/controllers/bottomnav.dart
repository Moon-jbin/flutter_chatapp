import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/talkroom.dart';
import '../profilepage.dart';

class BottomNavController extends GetxController {
  List<BottomNavigationBarItem> get bottomNavController => [
        const BottomNavigationBarItem(
            label: '친구', icon: Icon(Icons.person_outline)),
        const BottomNavigationBarItem(
            label: '대화방', icon: Icon(Icons.chat_bubble_outline)),
      ]; // bottomNavBar의 구성 코드이다.

  final RxInt _selectedIndex = 0.obs; // GetX로 인해 실시간으로 상태 관리

  int get selectedIndex => _selectedIndex.value; // get 으로 상태 정보 읽어오기

  void setSelectedIndex(int index) {
    _selectedIndex.value = index;
  }

  List pages = [
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
           Text('안녕하세요!'),
          SizedBox(height: 10),
          Text('messaGe는 Flutter & firebase로 만든 채팅앱입니다.'),
          SizedBox(height: 10,),
          Text('UI 부분에서는 Simple을 추구하듯 구현했습니다. ')
        ],
      ),
    ),
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('자유롭게 대화를 나눠보세요!'),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () async {
                Get.to(
                  () => TalkRoom(),
                );
              },
              child: const Text('들어가기'))
        ],
      ),
    )
  ];
}
