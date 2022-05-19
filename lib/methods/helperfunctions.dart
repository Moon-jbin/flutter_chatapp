import 'package:shared_preferences/shared_preferences.dart';

 class HelperFunctions {
   // 로그인시 로그한 유저의 이름을 저장할 수 있는 클래스이다.
   // 다만 단점이 있다면 디스크에 저장하기 때문에
   // 삭제시 다시 저장을 할 수 없고,
   // 앱을 리 스타트 시켜야지 사용할 수 있다.
   // 음.. 검색하본 결과 자동로그인을 할때 주로 사용한다는데..
   // 이 패키지에대해 좀더 공부를 해봐야 겠다.
   // 저번에 계획한 방법은 물거품....ㅠㅠ
   static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
   static String sharedPreferenceUserNameKey = "USERNAMEKEY";
   static String sharedPreferenceUserEmailKey = "USEREMAILKEY";


   static Future<bool> saveUserLoggedInSharedPreference(bool isUserLoggedIn) async{

     // 공유 참조해주는 유저네임, 이메일, 비밀번호를 두었다.
     SharedPreferences preferences = await SharedPreferences.getInstance();
     return await preferences.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
   }

   static Future<bool> saveUserNameSharedPreference(String userName) async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     return await preferences.setString(sharedPreferenceUserNameKey, userName);
   }

   static Future<bool> saveUserEmailSharedPreference(String userEmail) async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     return await preferences.setString(sharedPreferenceUserEmailKey, userEmail);
   }

   static Future<bool?> getUserLoggedInSharedPreference() async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     return await preferences.getBool(sharedPreferenceUserLoggedInKey);
   }

   static Future<String?> getUserNameSharedPreference() async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     return await preferences.getString(sharedPreferenceUserNameKey);
   }

   static Future<String?> getUserEmailSharedPreference() async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     return await preferences.getString(sharedPreferenceUserEmailKey);
   }

   static Future<bool> removeUserLoggedInSharedPreference() async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     return await preferences.remove(sharedPreferenceUserLoggedInKey);
   }

   static Future<bool> removeUserNameSharedPreference() async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     return await preferences.remove(sharedPreferenceUserNameKey);
   }

   static Future<bool> removeUserEmailSharedPreference() async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     return await preferences.remove(sharedPreferenceUserEmailKey);
   }

 }