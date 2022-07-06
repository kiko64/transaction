import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getLoginToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return prefs.getString("logintoken");
}

Future<String?> getUsername() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return prefs.getString("username");
}

Future<String?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return prefs.getString("userId");
}

setUsername(String username) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("logintoken", username);
}

setUserId(String userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("userId", userId);
}

setLoginToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("logintoken", token);
}

deleteLoginToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("logintoken", "");
}
