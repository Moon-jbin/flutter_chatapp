import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:ntp/ntp.dart';
import '../constants.dart';
import '../methods/helperfunctions.dart';
import '../methods/signdata.dart';
import 'controllers/bottomnav.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final BottomNavController _controller = Get.put(BottomNavController());

  @override
  void initState() {
    currentUserName();
    getUserInfo();  // 채팅방 입장시 해당 유저 네임을 바로 초기값 설정을 하기 위해 initState()에 할당해준다.
    super.initState();
  }

  // 공통참조할 유저 네임을 받아주는 메소드 이다.
  getUserInfo() async{
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    setState(() {

    });
  }

  void currentUserName() {
    final userNameWrap = FirebaseFirestore.instance.collection('users');
    // 그러면 필드가 아닌 필드 안에 배열로 user 정보를 가져올까? 그러면 가능할 것 같기도 한데....?
    // 추가로 집가서 쫌더 봐야겠다.
    // 다른 테스트는 무엇이 될까... 할수 있겠찌...??? 허허...
    userNameWrap.get().then((value)=>{
      print(value)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          appBar: AppBar(
            title: const Text(
              'messaGe',
              style: TextStyle(
                  color: Colors.black, fontFamily: "GreatVibes", fontSize: 30),
            ),
            // centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.5,
            actions: [
              TextButton(
                  onPressed: ()  async{
                    SignData().signOut();
                    FirebaseAuth.instance.signOut();

                  },
                  child: Text(
                    '로그아웃',
                    style: TextStyle(color: Colors.red[300]),
                  ))
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Colors.black,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              currentIndex: _controller.selectedIndex,
              items: _controller.bottomNavController,
              onTap: (index) => setState(() {
                    _controller.setSelectedIndex(index);
                  })),
          body: Container(
            child: _controller.pages[_controller.selectedIndex],
          )
          // _controller.selectedIndex
          ),
    );
  }
}
