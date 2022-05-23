import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileViewList extends StatelessWidget{
  final String userName;
  final String email;
  final img ;
  ProfileViewList(this.userName, this.email, this.img);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blue,
            backgroundImage: img != null ? NetworkImage(img) : null,
            child: img != null ? Container() : Icon(Icons.person, size: 60,)
          ),
          SizedBox(height: 30),
          Text(userName, style: TextStyle(
            color: Color.fromRGBO(32, 32, 32, 1),
            fontSize: 15,
            fontWeight: FontWeight.w600
          ),),
          SizedBox(height: 10),
          Text(email, style: TextStyle(
            color: Color.fromRGBO(32, 32, 32, 1),
            fontSize: 13,
            fontWeight: FontWeight.w400
          ),)
        ],
      )
    );
  }
}