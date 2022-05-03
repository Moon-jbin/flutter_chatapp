import 'package:shared_preferences/shared_preferences.dart';

 class HelperFunctions {
   static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
   static String sharedPreferenceUserNameKey = "USERNAMEKEY";
   static String sharedPreferenceUserEmailKey = "USEREMAILKEY";

   /// saving data to sharedpreference
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

   /// fetching data from sharedpreference
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