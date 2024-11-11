// ignore_for_file: overridden_fields

part of 'chat_bloc.dart';

enum Status { success, error, init, first }

class ChatState {
  List<Chat> chat;

  int? chatNow;
  set setChatNow(chatId) => chatNow = chatId ?? 0;
  Status? status;
  String? error;

  ChatState({
    this.chat = const <Chat>[],
    this.chatNow,
    this.status,
    this.error,
  });
}

class ChatInitialState extends ChatState {
  ChatInitialState({super.chat, required super.chatNow});
}

class ChatStatusState extends ChatState {
  @override
  final Status status;
  ChatStatusState({
    required this.status,
    super.chat,
  });
}

class ChatMapState extends ChatState {
  ChatMapState({
    required super.chat,
  });
}

class ChatNowState extends ChatState {
  @override
  final int chatNow;
  ChatNowState({required this.chatNow}) : super(chatNow: chatNow) {
    ChatState().setChatNow = chatNow;
  }
}

class ChatErrorState extends ChatState {
  final int code;
  final String error;
  ChatErrorState({
    required this.code,
    required this.error,
  });
}
