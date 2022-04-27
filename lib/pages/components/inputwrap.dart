import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../mainpage.dart';
import '../register.dart';

class InputWrap extends StatefulWidget {
  const InputWrap({Key? key}) : super(key: key);

  @override
  _InputWrapState createState() => _InputWrapState();
}

class _InputWrapState extends State<InputWrap> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(100.0, 0, 100.0, 0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // id TextField 이다.
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'E-mail',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.0),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                // password TextField 이다.
                TextFormField(
                  controller: _pwController,
                  decoration: const InputDecoration(
                    hintText: 'password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                // 로그인 버튼입니다.
                ElevatedButton(
                  onPressed: () {
                    _login();
                  },
                  child: const Text('로그인'),
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
                  child: const Text('회원가입'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    minimumSize: const Size.fromHeight(55),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    await Firebase.initializeApp();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text , password: _pwController.text);




      Get.offAll(()=> MainPage());

    } on FirebaseAuthException catch (e) {
      if(e.code == 'invalid-email'){
        Get.snackbar('로그인 실패', '가입된 이메일이 아닙니다.');
      }
      if (e.code == 'wrong-password') {
        Get.snackbar('로그인 실패', '비밀번호를 다시 확인해주세요.');
      }
      else{
        print(e);
      }
    }
  }

}
