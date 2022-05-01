import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../methods/signdata.dart';
import 'controllers/bottomnav.dart';

class MainPage extends StatefulWidget {
   MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final BottomNavController _controller = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'messaGe',
          style: TextStyle(color: Colors.black, fontFamily: "GreatVibes" ,fontSize: 30),
        ),
        // centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          TextButton(onPressed: (){
            SignData().signOut();
            FirebaseAuth.instance.signOut();
          }, child: Text('로그아웃', style: TextStyle(color: Colors.red[300]),))
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
        })
      ),
      body: Container(
        child: _controller.pages[_controller.selectedIndex],
      )

    );
  }



}
