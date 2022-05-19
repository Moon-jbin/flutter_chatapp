import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileViewList extends StatelessWidget{
  final String userName;
  // final String email;
  // final img ;
  ProfileViewList(this.userName);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: ElevatedButton(
        onPressed: (){
          print(userName);
        },
        child: Text("check!"),
      )
    );
  }
}