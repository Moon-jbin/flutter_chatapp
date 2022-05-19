import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../methods/database.dart';
import 'lastchattime.dart';
import 'messagescreen.dart';

class ChatRoomTile extends StatefulWidget {
  final String userName;
  final String talkRoomId;

  ChatRoomTile(this.userName, this.talkRoomId);

  @override
  _ChatRoomTileState createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<ChatRoomTile> {
  DatabaseMethod databaseMethod = DatabaseMethod();
  Stream? chatRoomsLastMessage;


// 마지막 메시지를 받을 위젯을 만들자.
  Widget LastChatMessage() {
    return StreamBuilder(
      stream: chatRoomsLastMessage,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Text("${snapshot.data!.docs[0].data()["message"]}")
            : Container();
      },
    );
  }


  getLastMessageView() {
    // 마지막 으로 생성된 메시지 값을 받아올 것이다.
    databaseMethod.getLastMessage(widget.talkRoomId).then((value) {
      setState(() {
        chatRoomsLastMessage = value;
      });
    });
  }

  @override
  void initState() {
    //chatRoom화면이 보일시 이 함수가 실행 된다.
    getLastMessageView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.userName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: SafeArea(child: LastChatMessage()),
      onTap: () {
        // print(DatabaseMethod().getLastMessage(talkRoomId));
        Get.to(() => MessageScreen(talkroomId: widget.talkRoomId));
      },
      trailing:
          SafeArea(child: LastChatTime(widget.talkRoomId)), // 최근 보낸 메시지 시간 출력하기
    );
  }
}
