import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    // 유저의 메일로 유저정보를 가지고 올것이다.
    return await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap) async {
    // 유저의 정보들을 users 라는 컬렉션에 저장시키기 위한 메서드이다.
    await FirebaseFirestore.instance.collection('users').add(userMap);
  }

  // 대화방의 데이터 베이스이다.
  createTalkRoom(String talkRoomId, talkRoomMap) {
    FirebaseFirestore.instance
        .collection("TalkRoom")
        .doc(talkRoomId)
        .set(talkRoomMap)
        .catchError((e) {
      // 이 역시, talkRoomId 는 대화방 알고리즘을 통해 만들어 진 값을 넣고,
      // set 안에는 처음엔 upload 이지만 그 이후엔 수정을 시켜주는 부분이기에
      // 추가로 방이 만들어지는 버그를 없애는데 좋다. 그래서 talkRoomMap으로 이어 지고 user와 TalkRoomId 값을 변수가 된다.
      // TalkRoom 의 컬렉션을 가진 곳의 인자로 받는 대화방 ID 를 찾아서 talkRoomMap 대화방 이름을 설정 한다.
      // 이를 searchpage 쪽에서 갱신하게 할것이다.
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap)  async{
    // 메시지를 데이터 베이스에 추가시켜주는 기능
    await FirebaseFirestore.instance
        .collection("TalkRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId) async {
    //  데이터베이스에서 받아오게 하는 기능
    return FirebaseFirestore.instance
        .collection("TalkRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false) // 범인은 오타였다니... 으윽......한심한심... ㅠㅠㅠ
        .snapshots();
  }

  getUserInfo(String email) async {
    // 유저의 이메일 정보를 가지고 와주는 메서드이다.
    // 아마도 2번째 것과 같은 값을 가질텐데.. 후에 필요없다면 수정해볼만 하다.
    return FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addUserInfo(userData) async {
    // 회원가입만 유저의 정보를 users 라는 컬렉션에 추가하는 메서드이다.
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getTalkRooms(String userName) async {
    return await FirebaseFirestore.instance
        .collection("TalkRoom")
        .where("users", arrayContains: userName)
        .snapshots(); // 이 부분을 통해서 myName을 통해 어떤 유저에 대한 정보를 보여줄지를 보여준다.
  }

  getLastMessage (String chatRoomId) async{
    // 메시를 데이터베이스에서 받아오게 하는 기능
    return await FirebaseFirestore.instance
        .collection("TalkRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true) // 범인은 오타였다니... 으윽......한심한심... ㅠㅠㅠ
        .limit(1)
        .snapshots();
  }



  getProfileInfo (String currentUserUid) async{
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserUid)
        .get();
  }

}
