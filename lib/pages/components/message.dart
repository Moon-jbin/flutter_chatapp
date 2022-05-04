import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messageapp/methods/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

// message data가 오가는 위젯
class Message extends StatelessWidget {
  const Message({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;  // 현재 로그중인 아이디 인지를 위해 또 불러옴옴


   return StreamBuilder(
      // 메시지를 실시간으로 구독해야 하기 때문에 stream 으로 한다.
      stream: FirebaseFirestore.instance
          .collection('talk')
          .orderBy('time', descending: true)   // 이 부분으로 인해 time 스탬프 데이터를 가지고 정렬을 해준다.
          .snapshots(),
      // 컬렉션 talk에 있는 문서를 가져온다.
      // snapshots 전에 있는 orderBy 함수는 타임 스탬프를 받아서 정렬을 해주는 역할을 한다.
      // 또한 정렬 방식이 있는 이는 ascending , descending 이 있다.
      // 이는 아래 부터 에서 위로 올라가길 바라기 때문에 descending으로 한다.
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          ); // snapshot의 연결 상태가 아직 진행 중이라면 로딩 화면을 표시한다.
        }

        final chatDocs = snapshot.data!.docs; // 가독성을 위해 변수로 선언 !

        return ListView.builder(
          // 메시지를 불러올때 docs의 갯수 만큼 불러올 것이다.
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (context, index) {
            return MessageBubble(chatDocs[index]['text'],
            chatDocs[index]['userID'].toString() == user!.uid,
            chatDocs[index]['userName']
            ); // 불러온 값들은 js의 map 함수 처럼 돌면서 출력된다.
          },
        );
      },
    );
  }
}
