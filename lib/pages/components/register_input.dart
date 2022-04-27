import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login.dart';

class RegisterInput extends StatefulWidget {
  @override
  _RegisterInputState createState() => _RegisterInputState();
}

class _RegisterInputState extends State<RegisterInput> {
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
                // 이메일 입력 코드
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      hintText: 'E-mail', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == "") {
                      return "이메일을 입력하세요";
                    } else if (!RegExp(
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                        .hasMatch(value!)) {
                      return '잘못된 이메일 형식입니다.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // 비밀번호 입력 코드
                TextFormField(
                  obscureText: true,
                  controller: _pwController,
                  decoration: const InputDecoration(
                      hintText: 'password', border: OutlineInputBorder()),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "비밀번호를 입력하세요";
                    }
                    if (value.length < 6) {
                      return '6자 이상입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // 비밀번호 재입력 코드
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: 'password', border: OutlineInputBorder()),
                  validator: (String? value) {
                    if (value == _pwController.text) {
                      return null;
                    } else {
                      return '비밀번호를 다시 입력하세요';
                    }
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _register(); // 이때 firestore 에다가 입력한 정보들이 저장되도록 한다.
                  },
                  child: const Text('확인'),
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

  // 회원가입 메소드
  void _register() async {
    try{
      if (_formKey.currentState!.validate()) {
        // 이부분이 TextFormField 에 있는 validate 를 검사한다.

        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text, password: _pwController.text);
        // 이 코드가 firebase 에다가 이메일, 비밀번호를 넣어주는 역할!

        Get.snackbar('회원가입 완료', '가입이 완료되었습니다.');

        Get.to(() => LoginPage());
      }
    }catch(e) {
      Get.snackbar('회원가입 실패', '이미 가입된 회원정보입니다.');
    }

  }
}
