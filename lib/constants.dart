import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messageapp/methods/helperfunctions.dart';

class Constants {
  // getMyName () async{
  //   final userID = FirebaseAuth.instance.currentUser;
  //   // firebaseAuth이용해 ID 가져오기
  //   final userName = // 이 부분은 로그인한 UID에 있는 userName을 가져오기 위함이다.
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userID!.uid)
  //       .get();
  // }
 static String myName = "";
}