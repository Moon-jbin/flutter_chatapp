import 'package:flutter/material.dart';

class TalkRoom extends StatefulWidget {
  const TalkRoom({Key? key}) : super(key: key);

  @override
  _TalkRoomState createState() => _TalkRoomState();
}

class _TalkRoomState extends State<TalkRoom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('대화방입니다.'),
      ),
    );
  }
}