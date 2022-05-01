import 'package:flutter/material.dart';
import 'components/inputwrap.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            '로그인',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w200),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.5,
      ),
      body: const Padding(
        padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0) ,
        child: InputWrap() ,
      ),
    );
  }
}
