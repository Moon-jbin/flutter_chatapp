import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messageapp/methods/database.dart';
import 'package:messageapp/methods/helperfunctions.dart';
import '../../constants.dart';
import '../../methods/database.dart';
import '../../methods/helperfunctions.dart';
import '../../methods/signdata.dart';
import '../mainpage.dart';
import '../register.dart';


// 로그인 화면을 나타내는 곳이다.
class InputWrap extends StatefulWidget {
  const InputWrap({Key? key}) : super(key: key);

  @override
  _InputWrapState createState() => _InputWrapState();
}

class _InputWrapState extends State<InputWrap> {

  SignData authMethods = SignData();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  DatabaseMethod databaseMethod = DatabaseMethod();
  late QuerySnapshot snapshotUserInfo;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Form(
          key: _formKey,
          child: Container(
            height: 450,
            padding: const EdgeInsets.fromLTRB(70.0, 50.0, 70.0, 0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 7,
                      offset: const Offset(2, 3))
                ]),
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // id TextField 이다.
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'E-mail',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  // password TextField 이다.
                  TextFormField(
                    controller: _pwController,
                    decoration: const InputDecoration(
                      hintText: 'password',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 40),
                  // 로그인 버튼입니다.
                  ElevatedButton(
                    onPressed: () {
                      signIn();
                      // print("${Constants.myName}");
                    },
                    child: const Text(
                      '로그인',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      minimumSize: const Size.fromHeight(55),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '회원이 아니신가요?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => Register());
                    },
                    child: const Text(
                      '회원가입',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      minimumSize: const Size.fromHeight(55),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: signInWithGoogle,
                    style: ElevatedButton.styleFrom(
                      elevation: 1,
                      side: BorderSide(width: 1, color: Colors.grey),
                      primary: Colors.white,
                      minimumSize: const Size.fromHeight(55),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset("assets/image/google_logo.png"),
                        const Text(
                          'Sign in with Google',
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void _FireBaselogin() async {
  //   // Firebase 로그인 쪽
  //   await Firebase.initializeApp();
  //   try {
  //     await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(
  //             email: _emailController.text, password: _pwController.text)
  //         .then((result) async {
  //       if (result != null) {
  //         QuerySnapshot userInfoSnapshot =
  //             await DatabaseMethod().getUserInfo(_emailController.text);
  //         HelperFunctions.saveUserNameSharedPreference(
  //           userInfoSnapshot.docs.isNotEmpty ? userInfoSnapshot.docs[0]["userName"] : '');
  //       }
  //     });
  //
  //     Get.offAll(() => MainPage());
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'invalid-email') {
  //       Get.snackbar('로그인 실패', '가입된 이메일이 아닙니다.');
  //     }
  //     if (e.code == 'wrong-password') {
  //       Get.snackbar('로그인 실패', '비밀번호를 다시 확인해주세요.');
  //     } else {
  //       print(e);
  //     }
  //   }
  // }

  signIn() {
    HelperFunctions.saveUserEmailSharedPreference(_emailController.text);
    databaseMethod.getUserByUserEmail(_emailController.text).then((value) {
      snapshotUserInfo = value;

    Constants.myName = snapshotUserInfo.docs[0]["userName"];
      HelperFunctions.saveUserNameSharedPreference(
          snapshotUserInfo.docs[0]["userName"]);
    });
    authMethods
        .signInWithEmailAndPassword(_emailController.text, _pwController.text)
        .then((value) {
      if (value != null) {
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        // User? user = FirebaseAuth.instance.currentUser;
        // user?.updateDisplayName("$snapshotUserInfo");
        //   print("$snapshotUserInfo");
        Get.offAll(() => MainPage());
      }
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final user = authResult.user;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser
            ?.uid) // newUser에서 user의 정보중 uid를 doc이름으로 설정시켜준다.
        .set({
      // 필드값을 넣어준다.
      'userName': user!.displayName,
      'email': user.email,
    });

    HelperFunctions.saveUserNameSharedPreference(user.displayName.toString());
    HelperFunctions.saveUserEmailSharedPreference(user.email.toString());
    // Once signed in, return the UserCredential
    Get.offAll(() => MainPage());

    return authResult; // 리턴 값을 활성화 하기 위해 불러낸다.
  }
}
