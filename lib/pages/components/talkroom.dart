import 'package:flutter/material.dart';
import 'package:messageapp/constants.dart';
import 'package:messageapp/methods/database.dart';
import '../../methods/helperfunctions.dart';
import 'chatroomtile.dart';

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
              ?
          ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ChatRoomTile(
                          snapshot.data!.docs[index].data()["talkroomId"],
                          // .toString()
                          // .replaceAll("_", "")
                          // .replaceAll(Constants.myName, ""),   // 유저의 이름을 나타낼 수 있게 하는 코드이다.
                          snapshot.data!.docs[index].data()["talkroomId"]
                          // 바로 이 부분을 통해서 채팅방 클릭시 해당 대화방으로 입장 할 수 있다.
                          ),
                    );
                  },
                )
              : Text("없다.");
        });
  }

  // 공통참조할 유저 네임을 받아주는 메소드 이다.
  getUserInfo() async {
    // SharedPreference 를 사용하지 않게되면 굳이 initeState를 사용할 필요가 있을까?
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    databaseMethod.getTalkRooms(Constants.myName).then((value) {
      //이부분을 통해서 myName을 통해 해당 유저에게 보여질 데이터 정보를 보여준다.
      // 채팅방의 인자로 본인 이름을 받는다.
      setState(() {
        chatRoomsStream = value;
        // print("${chatRoomsStream}  this is name ${Constants.myName} ");
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [Expanded(child: chatRoomList())],
      ),
    );
  }
}
