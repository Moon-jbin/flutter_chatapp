import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messageapp/constants.dart';
import 'package:messageapp/methods/helperfunctions.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:get/get_core/src/get_main.dart';
import '../pages/login.dart';
import 'user.dart';

class SignData {

  final FirebaseAuth _auth = FirebaseAuth.instance;



  Users? _useFromFirebaseUser(User user){
    return user != null ? Users(uid: user.uid) : null;
  }


  Future signInWithEmailAndPassword(String email, String password)async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email , password: password );
      User? user = result.user;
      return _useFromFirebaseUser(user!);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _useFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }




  void signOut () async{
    await Firebase.initializeApp();
    try {
      // HelperFunctions.removeUserEmailSharedPreference();
      // HelperFunctions.removeUserNameSharedPreference();
      // HelperFunctions.removeUserEmailSharedPreference();
      Constants.myName = "";
      await FirebaseAuth.instance.signOut();

      Get.offAll(()=>LoginPage());
    }catch(e){
      print(e.toString());
    }
  }
}