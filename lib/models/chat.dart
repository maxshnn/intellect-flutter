import 'package:hive/hive.dart';

part 'chat.g.dart';

@HiveType(typeId: 1)
class Chat {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;

  @HiveField(2)
  List<Message> message;
  Chat({
    required this.id,
    required this.name,
    this.message = const <Message>[],
  });
}

@HiveType(typeId: 2)
class Message {
  @HiveField(0)
  int dateTime;

  @HiveField(1)
  Role role;

  @HiveField(2)
  MessageType type;

  @HiveField(3)
  Mark mark;

  @HiveField(4)
  List<Map<MessageType, String>> content;
  Message({
    required this.dateTime,
    required this.role,
    this.mark = Mark.none,
    required this.type,
    required this.content,
  });
}

@HiveType(typeId: 3)
enum Role {
  @HiveField(0)
  assistant,
  @HiveField(1)
  user
}

@HiveType(typeId: 4)
enum MessageType {
  @HiveField(0)
  link,
  @HiveField(1)
  text,
  @HiveField(2)
  init,
  @HiveField(3)
  image
}

@HiveType(typeId: 5)
enum Mark {
  @HiveField(0)
  like,

  @HiveField(1)
  dislike,

  @HiveField(2)
  none
}
