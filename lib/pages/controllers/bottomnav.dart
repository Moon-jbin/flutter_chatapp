import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../components/messagelistpage.dart';
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('안녕하세요!'),
          SizedBox(height: 10),
          Text('messaGe는 Flutter & Firebase로 만든 채팅앱입니다.'),
          StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                if (snapshot.hasData) {
                  return Text("환영합니다.");
                } else {
                  return Text('${FirebaseAuth.instance.currentUser?.uid}');
                }
              }),
        ],
      ),
      ),
    SearchPage(),
    // Center(child: SearchPage()),
    Center(child: const Text('hi'))
  ];
}
