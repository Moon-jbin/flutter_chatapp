import 'package:cloud_firestore/cloud_firestore.dart';
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
  final TextEditingController _nameController = TextEditingController();

  late String _userName ="";
  late String _emailValue = "";
  late String _pwValue = "";

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
                // 유저이름 코드
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      hintText: 'name', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "이름을 입력하세요";
                    }
                    if (value.length < 2) {
                      return '2자 이상입력해주세요';
                    }
                    return null;
                  },
                  onChanged: (value){
                    _userName = value;
                  },
                ),
                const SizedBox(height: 20),
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
                  },
                  onChanged: (value){
                    _emailValue = value;
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
                  onChanged: (value){
                    _pwValue = value;
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
                    FirebaseFirestore.instance.collection('users').snapshots();
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
    try {
      if (_formKey.currentState!.validate()) {
        // 이부분이 TextFormField 에 있는 validate 를 검사한다.

        final newUser =  await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text, password: _pwController.text);
        // 이 코드가 firebase 에다가 이메일, 비밀번호를 넣어주는 역할!


        await FirebaseFirestore.instance.collection('users').doc(newUser.user!.uid).set({
          'userName' : _userName,
          'email' : _emailValue,
          'password' : _pwValue
        });  // 이렇게 해야지 사용자 UID 로 인해서 email 인증 로그인 과 통합된 UID를 가지므로 id를 가질 수 있다.


        Get.snackbar('회원가입 완료', '가입이 완료되었습니다.');

        Get.to(() => LoginPage());
      }
    } catch (e) {
      Get.snackbar('회원가입 실패', '이미 가입된 회원정보입니다.');
    }
  }
}
