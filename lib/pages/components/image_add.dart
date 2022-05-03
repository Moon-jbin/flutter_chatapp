import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



// 이쪽 부분은 차후 추가해볼 예정
// 이를 이용해서 각 계정간의 프로필 사진을 넣어볼 예정이다.

class ImageAdd extends StatefulWidget {
  const ImageAdd( {Key? key}) : super(key: key);

  @override
  _ImageAddState createState() => _ImageAddState();
}

class _ImageAddState extends State<ImageAdd> {
  File? pickedImage;  // File을 사용하려면 dart.io 를 import 해야한다.



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      width: 150,
      height: 300,
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            backgroundImage: pickedImage != null ? FileImage(pickedImage!) : null,
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () {
              _pickImage();
            },
            icon: const Icon(Icons.image),
            label: const Text('프로필 편집'),
          ),
          const SizedBox(height: 80),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("확인"))
        ],
      ),
    );
  }

  void _pickImage() async {
    // 프로필 편집 클릭시 이미지를 선택할 수 있게 해주는 메서드이다.
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxHeight: 150
    );
    setState(() {
      if(pickedImageFile != null){
       pickedImage = File(pickedImageFile.path);
      }
    });
  }
}
