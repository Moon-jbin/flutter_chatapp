import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messageapp/constants.dart';
import 'package:messageapp/methods/database.dart';
import 'package:messageapp/pages/components/messagescreen.dart';

import '../../methods/helperfunctions.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  DatabaseMethod databaseMethods = DatabaseMethod();

  // 데이터베이스 클래스에서 받은 유저 데이터 값을 사용하기 위해 불러온다.
  TextEditingController searchController = TextEditingController();

  QuerySnapshot? searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot!.docs.length,
            // 그리고는 해당 검색한 searchSnapshot의 문서에 length를 찾아서 Count에 넣어주면 검색시 Tile의 갯수를 확인할 수 있다.
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapshot!.docs[index]["userName"],
                // userName값을 searchSnapshot 입력된 값을  docs중 userName에 있는 것과 같은값을 가져온다.
              );
            })
        : Container();
  }

  initialSearch() {
    // 검색한 값을 자료형이 QuerySnapshot인 searchSnapshot이란 변수에 할당한다.
    databaseMethods.getUserByUserName(searchController.text).then((result) {
      // 데이터 베이스에 있는 값을 찾을 건데 내가 검색한 userName의 값을 받아올것이고
      // 그것은 then 으로 결과값을 가지고 와서 사용한다.
      if (mounted) {
        // mounted를 하지않으면 dispose error가 발생한다. 따라서 사용하면 에러가 사라지는 것을 볼 수 있다.
        setState(() {
          // 해당 searchSnapshot을
          searchSnapshot = result;
        });
      }
    });
  }

  getUserInfo() async{  // 이 함수는 myName 즉, 본인의 로그인한 userName을 가지고 올 수 있게 해준다.
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
  }   //내가 해냈따 ! 본 로그인 계정의 userName을 사용했다 !!! 아싸아싸 ! 잘했다 나 자신 ..!!! ㅠㅠㅠㅠㅠㅠㅠㅠ

  @override
  void initState() {
    getUserInfo();   // 초기값으로 설정을 시켜주면 searchPage에 들어가자마자 로그인 userName을 가지고 오게 할 수 있다.
    super.initState();
  }

  // 대화방을 만든다. 당연하게 유저를 검색한 곳에서 대화하기를 누르면 대화방이 만들어 져야 하므로, searchPage에서 작성해준다.
  createTalkRoomAndStartTalk({required String userName}) {
    if (userName != Constants.myName) {
      // 본인 계정에게 검색해서 메시지보냄을 방지하는 코드이다.
      // 카카오톡에서는 하던데... 흠... 일단 이렇게 진행해 보자.
      String talkroomId = getChatRoomId(userName, Constants.myName);
      // 이 함수를 통해서 대화방ID를 만들어 질 것이고,

      List<String> users = [userName, Constants.myName]; // 해당 유저들이 들어가지며
      // 이 유저 변수에는 상대방 유저이름 , 그리고 본인 이름이 배열로 들어 가 진다.
      Map<String, dynamic> talkRoomMap = {
        // 대화방명 안에는 users, talkroomId 가 들어간다.
        // users는 위에서 한것으로 배열 형식으로 두고 있다.
        "users": users,
        "talkroomId": talkroomId
      }; // 이 구간을 통해 데이터 베이스에 들어갈 값들이 완성될 것이다.
      DatabaseMethod().createTalkRoom(talkroomId, talkRoomMap);
      // 이로써 만들어진 talkroomId, talkRoomMap을 database에 잘 집어 넣어준다.
      // 아까 만들어둔 databaseMethods 확인해보자.

      // 그리고 방을 생성하면 대화방으로 갈 수 있도록 코드를 구성해주자.
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MessageScreen(talkroomId: talkroomId);
      }));

      // Get.to(()=> MessageScreen(talkroomId));
    } else {
      print("자기자신에게는 보낼 수 없습니다.");
    }
  }

// SearchTile 은 검색결과로 나온 유저의 정보이다.
  Widget SearchTile({required String userName}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(userName), // 이부분이 검색한 결과가 나오는 구간이다.
        ),
        Spacer(),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
                onPressed: () {
                  createTalkRoomAndStartTalk(
                      userName: userName); // 대화하기 버튼을 누르게 되면 대화방이 만들어 진다.
                },
                child: const Text(
                  "대화하기",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  minimumSize: const Size.fromHeight(40),
                )),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // 이렇게 짜게 되면 검색버튼을 누를때만 검색결과가 나타난다.
      // 하지만 StreamBuilder를 사용하면 한자한자 누를대마다 검색 결과를 살피기때문에
      // 검색버튼을 누르지 않고도 사용할 수 있다.
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: "친구 검색",
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  initialSearch();
                  // then을 사용해서 나온 result 값은 JsonQuerySnapshot을 가진다.
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
        ),
        Expanded(child: searchList())
      ],
    );
  }
}

// 채팅룸 아이디를 만드는 메소드 즉, 알고리즘이다.
getChatRoomId(String a, String b) {
  if (a.compareTo(b) > 0) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  } // 대화방을 만들때 user1_user2 이런식으로 대화방을 만든다고 했었다.
  // 따라서 이 부분을 통해서 대화방과 대화방ID값을 만들 수 있다.
}
