import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../pages/login.dart';

class SignData {

  void signOut () async{
    await Firebase.initializeApp();
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(()=>LoginPage());
      print("로그아웃");
    }catch(e){
      print(e.toString());
    }
  }

  void checkDisplayName() async{
    await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    // user?.updateProfile(displayName:_emailController.text);
    print(user?.displayName);
  }
}