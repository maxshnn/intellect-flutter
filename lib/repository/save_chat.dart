import 'package:hive/hive.dart';
import 'package:intellect/models/chat.dart';

class SaveChat {
  final _box = Hive.openBox<Chat>('chat');
  Future<void> addChat(int id, Chat chat) async {
    (await _box).add(chat);
  }

  Future<List<Chat>> getChat() async {
    List<Chat> list = [];
    for (var i = 0; i < (await _box).length; i++) {
      if ((await _box).getAt(i) != null) {
        list.add((await _box).getAt(i) ?? Chat(id: 0, name: ''));
      }
    }
    return list;
  }

  Future<void> addMessage(int id, Chat chat) async {
    (await _box).putAt(id, chat);
    var chat1 = (await _box).get(id);
  }

  void deleteAllChat() async {
    (await _box).clear();
  }

  void deleteChat(int id) async {
    try {
      (await _box).deleteAt(id);
    } catch (e) {
      print(e);
    }
  }

  void renameChat(int id, Chat chat) async {
    (await _box).putAt(id, chat);
  }
}
