import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messageapp/methods/database.dart';
import 'package:messageapp/methods/helperfunctions.dart';

// import 'package:messageapp/methods/database.dart';
// import 'package:messageapp/methods/helperfunctions.dart';

// import '../../constants.dart';
import '../../methods/signdata.dart';
import '../login.dart';

class RegisterInput extends StatefulWidget {
  @override
  _RegisterInputState createState() => _RegisterInputState();
}

class _RegisterInputState extends State<RegisterInput> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignData authMethods = SignData();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  DatabaseMethod databaseMethod = DatabaseMethod();
  // late String _userName = "";
  late String _emailValue = "";
  late String _pwValue = "";

  signMeUP() async {
    if (_formKey.currentState!.validate()) {
      await authMethods.signUpWithEmailAndPassword(_emailValue, _pwValue).then(
        (value) {
          // print("$value");
          if (value != null) {
            Map<String, String> userInfoMap = {
              'userName': _nameController.text,
              'email': _emailController.text
            };
            databaseMethod.uploadUserInfo(userInfoMap);

            HelperFunctions.saveUserLoggedInSharedPreference(true);
            HelperFunctions.saveUserEmailSharedPreference(
                _emailController.text);
            HelperFunctions.saveUserNameSharedPreference(_nameController.text);

            Get.snackbar('회원가입 완료', '가입이 완료되었습니다.');
            Get.to(() => LoginPage());
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.fromLTRB(70.0, 60.0, 70.0, 0.0),
            height: 450,
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
                  // 유저이름 코드
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "이름을 입력하세요.";
                      }
                      if (value.length < 2) {
                        return '2자 이상입력해주세요.';
                      }
                      return null;
                    },
                    // onChanged: (value) {
                    //   _userName = value;
                    // },
                  ),

                  const SizedBox(height: 20),
                  // 이메일 입력 코드

                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'E-mail',
                    ),
                    validator: (value) {
                      if (value == "") {
                        return "이메일을 입력하세요.";
                      } else if (!RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                          .hasMatch(value!)) {
                        return '잘못된 이메일 형식입니다.';
                      }
                    },
                    onChanged: (value) {
                      _emailValue = value;
                    },
                  ),

                  const SizedBox(height: 20),
                  // 비밀번호 입력 코드
                  TextFormField(
                    obscureText: true,
                    controller: _pwController,
                    decoration: const InputDecoration(
                      hintText: 'password',
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "비밀번호를 입력하세요.";
                      }
                      if (value.length < 6) {
                        return '6자 이상입력해주세요.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _pwValue = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  // 비밀번호 재입력 코드
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'password',
                    ),
                    validator: (String? value) {
                      if (value == _pwController.text) {
                        return null;
                      } else {
                        return '비밀번호를 다시 입력하세요.';
                      }
                    },
                  ),
                  const SizedBox(height: 35),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('users')
                          .snapshots();
                      signMeUP(); // 이때 firestore 에다가 입력한 정보들이 저장되도록 한다.
                    },
                    child: const Text(
                      '확인',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
      ),
    );
  }

// 회원가입 메소드
// void _register() async {
//   try {
//     if (_formKey.currentState!.validate()) {
//       // 이부분이 TextFormField 에 있는 validate 를 검사한다.
//      final newUser = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(
//               // 이 코드가 firebase 에다가 이메일, 비밀번호를 넣어주는 역할!
//               // 구글 로그인에서는 로그인시 자동으로 firebase에 다가 넣어줌.
//               email: _emailController.text,
//               password: _pwController.text)
//           .then(
//         (result) async {
//           HelperFunctions.saveUserNameSharedPreference(_userName);
//         },
//       );
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(newUser.user!.uid) // newUser에서 user의 정보중 uid를 doc이름으로 설정시켜준다.
//           .set({
//         // 필드값을 넣어준다.
//         'userName': _userName,
//         'email': _emailValue,
//         'password': _pwValue
//       }); // 이렇게 해야지 사용자 UID 로 인해서 email 인증 로그인 과 통합된 UID를 가지므로 id를 가질 수 있다.
//       // 이부분 을 구글 로그인시 컬렉션에 넣어 줘야 함.
//       // 그러면 생각을 해봐야 겠다.
//       // userName(displayName)만 넣어보자. 물론 이부분은 구글 로그인 버튼을 클릭시 일어나야 한다.
//
//       Get.snackbar('회원가입 완료', '가입이 완료되었습니다.');
//
//       Get.to(() => LoginPage());
//     }
//   } catch (e) {
//     Get.snackbar('회원가입 실패', '이미 가입된 회원정보입니다.');
//   }
// }
}
