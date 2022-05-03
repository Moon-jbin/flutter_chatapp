import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:messageapp/constants.dart';
import 'package:messageapp/methods/database.dart';
import 'package:messageapp/pages/components/messagescreen.dart';
import '../../methods/helperfunctions.dart';

// 실제 대화방   (chatroom screen)
class TalkRoom extends StatefulWidget {
  const TalkRoom({Key? key}) : super(key: key);

  @override
  _TalkRoomState createState() => _TalkRoomState();
}

class _TalkRoomState extends State<TalkRoom> {
  DatabaseMethod databaseMethod = DatabaseMethod();
  Stream? chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ChatRoomTile(
                        snapshot.data!.docs[index].data()["talkroomId"]
                            .toString().replaceAll("_","")
                            .replaceAll(Constants.myName, ""),
                        snapshot.data!.docs[index].data()["talkroomId"]
                    );
                  })
              : Container();
        });
  }

  // 공통참조할 유저 네임을 받아주는 메소드 이다.
  getUserInfo() async {
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    databaseMethod.getTalkRooms(Constants.myName).then((value) {
      // 채팅방의 인자로 본인 이름을 받는다.
      setState(() {
        chatRoomsStream = value;
        print("${chatRoomsStream}  this is name ${Constants.myName} ");
      });
    });
  }

  @override
  void initState() {
    getUserInfo(); // 채팅방 입장시 해당 유저 네임을 바로 초기값 설정을 하기 위해 initState()에 할당해준다.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [Expanded(child: chatRoomList())],
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String talkRoomId;
  ChatRoomTile(this.userName, this.talkRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(()=> MessageScreen(talkroomId: talkRoomId));
      },
      child: Row(
        children: [
          Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(40)),
              child: Center(
                child: Text("${userName.substring(0, 1)}"),
              )
          ),
          SizedBox(width: 8),
          Text(userName)
        ],
      )
    );
  }
}
