import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 이제 실제로 메세지를 입력후 실시간으로 창에 나타나게 한다.
// " 메시지 보낼시 입력창 비활성화를 벨리데이션 " 으로 작동하기 위해 StatefulWidget 으로 클래스를 생성시킨다.
// (input, send icon 배치하는 곳이다.)
class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  TextEditingController inputController = TextEditingController();
  String inputValue = ''; // 이 변수를 사용한 이유는 버튼 비활성화를 위함

  late FocusNode inputFocusNode;

  @override
  void initState() {
    super.initState();
    inputFocusNode = FocusNode();
  }

  @override
  void dispose() {
    inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 18,
      shadowColor: Colors.grey,
      child: Container(
        margin: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                    border: InputBorder.none),
                minLines: 1,
                maxLines: 4,
                focusNode: inputFocusNode,
                autofocus: true,
                controller: inputController,
                onChanged: (value) {
                  setState(() {
                    inputValue = value;
                  });
                },
              ),
            ),
            IconButton(
              onPressed: inputValue.trim().isEmpty
                  ? null
                  : () {
                _messageSend();
              },
              // onPressed 에서는 콜백이 null 이면 비활성화 된다.
              // 즉, 입력창이 빈값일 경우 버튼 비활성화
              icon: const Icon(Icons.send),
              color: Colors.lightBlueAccent,
            )
          ],
        ),
      ),
    );

  }

  void _messageSend() async {
    // 이 함수가 작동시 TextFiled가 unfocus 되야 한다.
    FocusScope.of(context).unfocus();

    final userID = FirebaseAuth.instance.currentUser;
    // firebaseAuth이용해 ID 가져오기
    final userName = // 이 부분은 로그인한 UID에 있는 userName을 가져오기 위함이다.
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userID!.uid)
            .get();

    //firebase와 연동하여 메시지 등록
    FirebaseFirestore.instance.collection('talk').add({
      // map형태 (js 배열생각하면 안됨, 객체임)
      'text': inputValue,
      'time': Timestamp.now(), // 이 타임 스탬프로 인해서 메시지로 차례대로 보여질 것
      'userID': userID.uid, // 이러면 현재 로그인한 아이디를 인식할 수 있다. (랜덤으로 생성됨)
      'userName': userName.data()!['userName']
    });
    inputController.clear();
    // 자동 포커스 기능
    FocusScope.of(context).requestFocus(inputFocusNode);
  }
}