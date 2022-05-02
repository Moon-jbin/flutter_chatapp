import 'package:flutter/material.dart';
import 'package:messageapp/constants.dart';
import 'package:messageapp/pages/components/new_message.dart';

import '../../methods/helperfunctions.dart';
import 'message.dart';

// 실제 대화방
class TalkRoom extends StatefulWidget {
  const TalkRoom({Key? key}) : super(key: key);
  @override
  _TalkRoomState createState() => _TalkRoomState();
}

class _TalkRoomState extends State<TalkRoom> {

  @override
  void initState(){
    getUserInfo();  // 채팅방 입장시 해당 유저 네임을 바로 초기값 설정을 하기 위해 initState()에 할당해준다.
    super.initState();
  }

  // 공통참조할 유저 네임을 받아주는 메소드 이다.
  getUserInfo() async{
      Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TalkRoom',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        toolbarOpacity: .5,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          const Expanded(
            // Message()는 ListView 이다. 따라서 Expanded로 감싸지 않으면 overflow error가 난다.
            child: Message(),
          ),
          const SizedBox(height: 20),
          NewMessage()   // Expanded로 인해 입력창은 바로 아래로 내려가 배치될 것이다.
        ],
      ),
    );
  }
}
