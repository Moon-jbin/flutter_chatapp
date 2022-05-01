import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// messageListPage 즉, 개별적인 채팅방이 보여질 공간이다.
class MessageListPage extends StatefulWidget {
  @override
  _MessageListPageState createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (BuildContext context) {
          //   return SearchPage();
          // }));
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
