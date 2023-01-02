import 'package:shared_preferences/shared_preferences.dart';

Future<int> loadScore() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.get('score') == null) return 0;
  return prefs.getInt('score') as int;
}

Future<void> saveScore() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  int score = await loadScore();

  await prefs.setInt('score', score += 1);
}

Future<void> saveSkins(List<String> skinIds) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setStringList("skins", skinIds);
}

Future<List<String>> loadSkins() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.get("skins") == null) return ["goose"];
  return prefs.getStringList("skins") as List<String>;
}

Future<void> saveCurrentSkin(String currentSkinId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString("skin", currentSkinId);
}

Future<String> loadCurrentSkin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.get("skin") == null) return "goose";
  return prefs.getString("skin") as String;
}
