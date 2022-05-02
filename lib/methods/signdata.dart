import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
import '../pages/login.dart';
import 'user.dart';

class SignData {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Users? _userFormFirebaseUser(user) {
    return user != null ? Users(uid: user.uid) : null;
  }


  void signOut () async{
    await Firebase.initializeApp();
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(()=>LoginPage());
    }catch(e){
      print(e.toString());
    }
  }


}