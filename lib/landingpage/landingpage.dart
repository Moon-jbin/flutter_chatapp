import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../pages/mainpage.dart';      // Ui 작업으로 인해 불러옴. 나중에 login 으로 다시 바꿔야됨
import '../pages/login.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  @override
  void initState() {
    Timer(const Duration(seconds: 0), () {
      Get.offAll(()=>LoginPage());
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Image.asset(
        'assets/image/landing_image.jpg',
        fit: BoxFit.cover,
      ),
    ));
  }
}
