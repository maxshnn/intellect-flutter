import 'package:hive/hive.dart';

class FirstStart {
  final _box = Hive.openBox('first_start');
  void set() async {
    (await _box).put('first', false);
  }

  Future<bool> get() async {
    print((await _box).get('first'));
    return (await _box).get('first') ?? true;
  }
}
