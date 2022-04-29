import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'landingpage/landingpage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBo8KMwAwmA1FPuynqF64AkHIDMefBcWts',
      appId: '1:617445492817:android:4021dc7e151c3bbde49070',
      messagingSenderId: '617445492817',
      projectId: 'messageapp-5073e',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.black
          )
        )
      ),
      debugShowCheckedModeBanner: false,
      title: 'messaGe',
      home: LandingPage(),
    );
  }
}
