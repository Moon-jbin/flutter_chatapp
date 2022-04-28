import 'package:flutter/material.dart';
import 'package:messageapp/methods/new_message.dart';

import '../../methods/message.dart';

// 실제 대화방
class TalkRoom extends StatefulWidget {
  @override
  _TalkRoomState createState() => _TalkRoomState();
}

class _TalkRoomState extends State<TalkRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Talk',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              // Message()는 ListView 이다. 따라서 Expanded로 감싸지 않으면 overflow error가 난다.
              child: Message(),
            ),
            NewMessage()   // Expanded로 인해 입력창은 바로 아래로 내려가 배치될 것이다.
          ],
        ),
      ),
    );
  }
}
