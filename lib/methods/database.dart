import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethod {
  // 친구 검색할시에 사용될 데이터베이스 메소드이다.
  getUserByUserName(String userName) async {
    // 유저의 이름을으로 유저정보를 가지고 올것이다.
    return await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: userName)
        .get();
    // 위의 코드를 해석하면 다음과 같다. 함수가 실행되면 ,users 콜렉션안에 where를 통해서 값을 찾는다.
    // 값을 찾을때는 userName값들 중  isEqualTo 로 인해서 같은 값인 걸 뽑아 낼 수 있다.
    // get()을 통해서 찾은 userName 값을 불러올수 있다.
  }


  getUserByUserEmail(String userEmail) async {
    // 유저의 이름을으로 유저정보를 가지고 올것이다.
    return await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap) async{

    await FirebaseFirestore.instance.collection('users').add(userMap);
  }

  // 대화방의 데이터 베이스이다.
  createTalkRoom(String talkRoomId, talkRoomMap) {
    FirebaseFirestore.instance
        .collection("TalkRoom")
        .doc(talkRoomId)
        .set(talkRoomMap)
        .catchError((e) {
      // TalkRoom 의 컬렉션을 가진 곳의 인자로 받는 대화방 ID 를 찾아서 talkRoomMap 대화방 이름을 설정 한다.
      // 이를 searchpage 쪽에서 갱신하게 할것이다.
      print(e.toString());
    });
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      print(e.toString());
    });
  }
}
