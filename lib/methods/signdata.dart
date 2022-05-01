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
    }catch(e){
      print(e.toString());
    }
  }

  void checkDisplayName() async{  // displayName은 회원가입한 이메일이 나온다.
    await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    // user?.updateProfile(displayName:_emailController.text);
    print(user?.displayName);
  }


}