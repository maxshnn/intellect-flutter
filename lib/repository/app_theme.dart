import 'package:hive/hive.dart';

class StorageTheme {
  var _box = Hive.openBox('theme');
  void set(String theme) async {
    return (await _box).put('theme', theme);
  }

  Future<String> get() async {
    return (await _box).get('theme') ?? 'dark';
  }
}
