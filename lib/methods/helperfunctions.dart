import 'package:shared_preferences/shared_preferences.dart';

 class HelperFunctions {
   static String sharingPreferenceUserNameKey ="USERNAMEKEY";

   //공유 참조할 userName을 설정하는 코드다. (write)
   static Future<bool> saveUserNameSharedPreference (String userName) async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     return await prefs.setString(sharingPreferenceUserNameKey, userName);
   }

   // 공유참조할 userName을 받아오는 코드다.
   static Future<String?> getUserNameSharedPreference () async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     return await prefs.getString(sharingPreferenceUserNameKey);
   }

 }