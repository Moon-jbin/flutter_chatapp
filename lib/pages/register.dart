import 'package:flutter/material.dart';

import 'components/register_input.dart';

class Register extends StatefulWidget {
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
          color: Colors.white
        ),),
        elevation: 0.5,
        backgroundColor: Colors.black,
      ),
      body: RegisterInput(),

    );
  }
}