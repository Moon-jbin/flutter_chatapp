import 'package:flutter/material.dart';

import 'components/register_input.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('회원가입', style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w100
        ),),
        elevation: 0.5,
        backgroundColor: Colors.white,
        toolbarOpacity: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: RegisterInput(),
      )
,

    );
  }
}