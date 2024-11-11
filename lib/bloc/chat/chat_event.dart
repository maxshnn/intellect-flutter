part of 'chat_bloc.dart';

abstract class ChatEvent {}

class ChatInitEvent extends ChatEvent {
  int id;
  String name;
  ChatInitEvent({
    required this.id,
    required this.name,
  });
}

class ChatFirstEvent extends ChatEvent {}

class ChatSentEvent extends ChatEvent {
  final int idChat;
  final String message;
  ChatSentEvent({
    required this.idChat,
    required this.message,
  });
}

class ChatClearEvent extends ChatEvent {}

class ChatSetLikeEvent extends ChatEvent {
  final idMessage;
  final Mark mark;

  ChatSetLikeEvent({
    required this.idMessage,
    required this.mark,
  });
}

class ChatNowEvent extends ChatEvent {
  int chatNow;
  ChatNowEvent({
    required this.chatNow,
  });
}

class ChatCreateEvent extends ChatEvent {}

class ChatDeleteEvent extends ChatEvent {
  int idChat;
  ChatDeleteEvent({
    required this.idChat,
  });
}

class ChatRenameEvent extends ChatEvent {
  int idChat;
  String name;
  ChatRenameEvent({
    required this.idChat,
    required this.name,
  });
}

class ChatSaveEvent extends ChatEvent {
/*   int idChat;
  ChatSaveEvent({
    required this.idChat,
  }); */
}

class ChatResentEvent extends ChatEvent {}
