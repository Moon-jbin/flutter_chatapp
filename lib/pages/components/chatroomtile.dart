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

  // 시간을 받을 위젯을 만들자.

  getLastMessageView() {
    databaseMethod.getLastMessage(widget.talkRoomId).then((value) {
      setState(() {
        chatRoomsLastMessage = value;
      });
    });
  }

  @override
  void initState() {
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

    // GestureDetector(
    //   onTap: () {
    //     Get.to(() => MessageScreen(
    //         talkroomId: talkRoomId)); // 채팅방 클릭시 talkRoomId 값으로 인해 들어갈 수 있다.
    //   },
    //   child: Row(
    //     children: [
    //       Container(
    //           height: 40,
    //           width: 40,
    //           decoration: BoxDecoration(
    //               color: Colors.blue, borderRadius: BorderRadius.circular(40)),
    //           child: Center(
    //             child: Text("${userName.substring(0, 1)}"),
    //           )),
    //       SizedBox(width: 8),
    //       Text(userName)
    //     ],
    //   ),
    // );
  }
}
