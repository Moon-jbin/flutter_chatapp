import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';

// 단순히 버블 모양으로만 할 것이기 떄문에 stateless로 한다.
class MessageBubble extends StatelessWidget {
  const MessageBubble(this.message, this.isMe, this.userName, {Key? key})
      : super(key: key);

  final String message;

  // 이 message 에게는 message.dart 파일의 chatDocs[index]['text'] 값을 받아온다.

  final bool isMe; // 이 값을 사용해 Container에다가 삼항연산자를 활용해
  // 서로간의 색상을 다르게 표현한다.

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Row(
      // Row로 감싼 이유는 message.dart의 ListView로 인해서
      // width 값이 무시됨 , 그렇기 때문에 Row 로 감싸서 진행
      // 또한 나중에 메시지 배치를 위함도 겸함
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      // isMe가 참 이면 Row방향에서 오른쪽에 배치, 아니면 왼쪽으로 배치한다.

      children: [
        if (isMe)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
            child: ChatBubble(
              // ChatBubble 패키지를 사용했다.
              clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
              alignment: Alignment.topRight,
              margin: const EdgeInsets.only(top: 20),
              backGroundColor: Colors.blue,
              child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Column(
                    children: [
                      Text(
                        message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  )),
            ),
          ),
        if (!isMe)
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
            child: ChatBubble(
              // ChatBubble 패키지를 사용했다.
              clipper: ChatBubbleClipper3(type: BubbleType.receiverBubble),
              backGroundColor: const Color(0xffE7E7ED),
              margin: const EdgeInsets.only(top: 20),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Column(
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.black
                      ),
                    ),
                    Text(
                      message,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }
}
