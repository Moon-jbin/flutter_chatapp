import 'package:flutter/material.dart';
import 'package:messageapp/methods/database.dart';

class LastChatTime extends StatefulWidget {
    final String talkRoomId;
    LastChatTime(this.talkRoomId);

  @override
  _LastChatTimeState createState() => _LastChatTimeState();
}

class _LastChatTimeState extends State<LastChatTime>{
  DatabaseMethod databaseMethod = DatabaseMethod();
  Stream? chatRoomsLastTime;

  getLastTimeView() {
    databaseMethod.getLastMessage(widget.talkRoomId).then((value) {
      setState(() {
        chatRoomsLastTime = value;
      });
    });
  }

  @override
  void initState() {
    getLastTimeView();
    super.initState();
  }

  //마지막 메시지를 받은 시간을 받을 위젯을 만들자.
  Widget lastChatTime() {
    return StreamBuilder(
      stream: chatRoomsLastTime,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Text("${snapshot.data!.docs[0].data()["viewTime"]}")
            : Container();
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      alignment: Alignment.centerRight,
      child:SafeArea(
        child:lastChatTime() ,
      )
    );
  }
}
