import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../methods/signdata.dart';
import 'controllers/bottomnav.dart';

class MainPage extends StatefulWidget {
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
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(onPressed: (){
            SignData().signOut();
          }, icon: const Icon(Icons.logout_outlined, color: Colors.black,))
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
      body: _controller.pages[_controller.selectedIndex],
    );
  }



}
