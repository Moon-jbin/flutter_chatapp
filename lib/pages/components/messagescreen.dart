import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:get/get.dart';
import 'package:messageapp/methods/database.dart';
import 'package:uuid/uuid.dart';
import '../../constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class MessageScreen extends StatefulWidget {
  final String talkroomId;

  MessageScreen({required this.talkroomId});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController inputController = TextEditingController();
  DatabaseMethod databaseMethods = DatabaseMethod();

  Stream? chatMessagesStream;
  File? imageFile; // 이미지를 담을 변수이다.

  Widget ChatMessageList() {
    return StreamBuilder(
        stream: chatMessagesStream,
        // initeState 함수 코드와, database 코드를 확인하면 이해하기 좋다.
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> map = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    return MessageTile(
                        snapshot.data!.docs[index].data()["sendBy"],
                        // 유저의 이름을 불러오는 코드이다. userName
                        map, // text, image를 구분하기 위한 기준선이 되는 코드다.
                        snapshot.data!.docs[index].data()["message"],
                        // message 데이터를 전송 !
                        snapshot.data.docs[index].data()["sendBy"] == Constants.myName);
                        // isMe 역할을 하는 인자이다.
                  })
              : Container();
        });
  }

  // 이미지를 받고(get) FireStore에 저장(upload)하는 메소드를 만들 것이다.
  Future getImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then(
      (value) {
        if (value != null) {
          imageFile = File(value.path);
          uploadImage();
        }
      },
    );
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;

    await FirebaseFirestore.instance
        .collection('TalkRoom')
        .doc(widget.talkroomId)
        .collection("chats")
        .doc(fileName)
        .set({
      "message": "",
      "sendBy": Constants.myName,
      // userName의 시초는 sendBy 즉, 자기자신으로부터 데이터가 저장 될 거고 이를 불러오는것이다.
      "time": Timestamp.now(),
      "type": "img"
    }).catchError((e) {
      print(e.toString());
    });

    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((e) async {
      await FirebaseFirestore.instance
          .collection("TalkRoom")
          .doc(widget.talkroomId)
          .collection('chats')
          .doc(fileName)
          .delete();
      status = 0;
    });

    if (status == 1) {
      String imageUrl = await  uploadTask.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection("TalkRoom")
          .doc(widget.talkroomId)
          .collection("chats")
          .doc(fileName)
          .update({"message": imageUrl});
    }
  }

  sendMessage() {
    // 메시지 데이터를 전송해 주는 역할을 한다.
    if (inputController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": inputController.text,
        "sendBy": Constants.myName,
        "time": Timestamp.now(),
        "type": "text"
      };
      databaseMethods.addConversationMessages(widget.talkroomId, messageMap);
      inputController.text = "";
    }
  }

  String inputValue = ''; // 이 변수를 사용한 이유는 버튼 비활성화를 위함
  late FocusNode inputFocusNode;

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.talkroomId).then((value) {
      setState(() {
        chatMessagesStream = value; // 채팅 내용을 stream (비동기)자료형 변수로 받아서 값을 넣어준다.
      });
    });
    inputFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    inputFocusNode.dispose();
    super.dispose();
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
          Expanded(child: ChatMessageList()),
          // Message()는 ListView 이다. 따라서 Expanded로 감싸지 않으면 overflow error가 난다.
          // const SizedBox(height: 20),
          Material(
            elevation: 18,
            shadowColor: Colors.grey,
            child: Container(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      getImage();
                    },
                    icon: const Icon(Icons.image),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                        border: InputBorder.none,
                      ),
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
                            sendMessage();
                          },
                    // onPressed 에서는 콜백이 null 이면 비활성화 된다.
                    // 즉, 입력창이 빈값일 경우 버튼 비활성화
                    icon: const Icon(Icons.send),
                    color: Colors.lightBlueAccent,
                  )
                ],
              ),
            ),
          )
          // Expanded로 인해 입력창은 바로 아래로 내려가 배치될 것이다.
        ],
      ),
    );
  }
}

// 메시지가 나오는 클래스이다.
class MessageTile extends StatelessWidget {
  final String userName;
  final String message;
  final bool isSendByMe;
  final Map map;

  MessageTile(this.userName, this.map, this.message, this.isSendByMe,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return map['type'] == "text"
        ? Row(
            // Row로 감싼 이유는 message.dart의 ListView로 인해서
            // width 값이 무시됨 , 그렇기 때문에 Row 로 감싸서 진행
            // 또한 나중에 메시지 배치를 위함도 겸함
            mainAxisAlignment:
                isSendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            // isMe가 참 이면 Row방향에서 오른쪽에 배치, 아니면 왼쪽으로 배치한다.

            children: [
              if (isSendByMe)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
                  child: ChatBubble(
                    // ChatBubble 패키지를 사용했다.
                    clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
                    alignment: Alignment.topRight,
                    margin: const EdgeInsets.fromLTRB(0, 10, 0 , 10),
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
                      ),
                    ),
                  ),
                ),
              if (!isSendByMe)
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                  child: ChatBubble(
                    // ChatBubble 패키지를 사용했다.
                    clipper:
                        ChatBubbleClipper3(type: BubbleType.receiverBubble),
                    backGroundColor: const Color(0xffE7E7ED),
                    margin: const EdgeInsets.only(top: 20),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 3),
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
          )
        : Padding(
      padding: isSendByMe ? const EdgeInsets.only(right: 6) : const EdgeInsets.only(left: 6),
      child: ChatBubble(
        // ChatBubble 패키지를 사용했다.
        clipper: isSendByMe ? ChatBubbleClipper3(type: BubbleType.sendBubble) : ChatBubbleClipper3(type: BubbleType.receiverBubble),
        alignment: isSendByMe ? Alignment.topRight : Alignment.topLeft ,
        backGroundColor: const Color(0xffE7E7ED),
        margin: const EdgeInsets.only(top: 20),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Column(
            children: [
          Container(
            height: 150,
            width: 150,
            padding: EdgeInsets.all(6),
            alignment:
            isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                Get.to(
                      () => ShowImage(imageUrl: map['message']),
                );
              },
              child: Container(
                height: 150,
                width: 150,
                child: ClipRRect(   // 이미지 border Radius를 사용하기 위한 위젯이다.
                  borderRadius: BorderRadius.circular(10),
                  child: map["message"] != ""
                      ? Image.network(
                    map['message'],
                    fit: BoxFit.cover,
                  )
                      : CircularProgressIndicator(),
                )



              ),
            ),
          ),
            ],
          ),
        ),
      ),
    );


    // Container(
    //         height: 150,
    //         width: 150,
    //         margin: EdgeInsets.only(top: 20),
    //         padding: isSendByMe
    //             ? EdgeInsets.only(right: 6)
    //             : EdgeInsets.only(left: 6),
    //         alignment:
    //             isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
    //         child: InkWell(
    //           onTap: () {
    //             Get.to(
    //               () => ShowImage(imageUrl: map['message']),
    //             );
    //           },
    //           child: Container(
    //             height: 150,
    //             width: 150,
    //             decoration: BoxDecoration(
    //               border: Border.all(),
    //             ),
    //             child: map["message"] != ""
    //                 ? Image.network(
    //                     map['message'],
    //                     fit: BoxFit.cover,
    //                   )
    //                 : CircularProgressIndicator(),
    //           ),
    //         ),
    //       );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.network(imageUrl),
      ),
    );
  }
}
