import 'package:flutter/cupertino.dart';

class ProfileViewList extends StatelessWidget{
  // final String userName;
  // final String email;
  final img ;
  ProfileViewList(this.img);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: Text(img)
    );
  }
}