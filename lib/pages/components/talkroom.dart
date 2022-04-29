import 'package:flutter/material.dart';
import 'package:messageapp/pages/components/new_message.dart';

import 'message.dart';

// 실제 대화방
class TalkRoom extends StatefulWidget {
  const TalkRoom({Key? key}) : super(key: key);

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
