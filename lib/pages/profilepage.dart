import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messageapp/methods/database.dart';
import 'package:messageapp/pages/components/image_add.dart';

import 'components/profileviewlist.dart';

// 프로필 페이지 이다. 여기서 사진을 등록해서 보여주는 곳으로 설정한다.
// 아직 구현은 하지 못했다.
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DatabaseMethod databaseMethod = DatabaseMethod();
  FirebaseAuth auth = FirebaseAuth.instance;

  //
  Widget ProfileView() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(auth.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ProfileViewList(
                  snapshot.data["userName"],
                  snapshot.data["email"],
                  snapshot.data["img"],
                )
              : Text("없다.");
        });
  }

  @override
  void initState() {
    // getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        // kakao 처럼 프로필 사진이 가운데
        // 그 밑에 userName을 넣을 예정이다.
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            child: GestureDetector(
                onTap: () {
                  showAlert(context);
                  // 프로필이 보여져도, 프로필을 클릭하면
                  // 프로필 사진을 변경 할 수 있도록 alert를 설정했다.
                },
                child: ProfileView()
                ),
          )
        ],
      ),
    );
  }

  void showAlert(BuildContext context) {
    // 호출시 위젯 트리에 삽입 되어야 하기 때문에 인자값으로 context 값을 전달한다.
    showDialog(
      // flutter에서 제공하는 함수이다.
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: ImageAdd(),
        ); // 반환되면 반투명한 창이 나온다.
      },
    );
  }
}
