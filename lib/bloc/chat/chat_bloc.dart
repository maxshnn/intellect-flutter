// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intellect/models/chat.dart';
import 'package:intellect/constants.dart';
import 'package:intellect/repository/first_start.dart';
import 'package:intellect/repository/save_chat.dart';
import 'package:linkify/linkify.dart';
// import 'package:tiktoken/tiktoken.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  static List<Chat> chats = [];
  static late OpenAI _openAI;
  static int chatNow = 0;
  static Status status = Status.init;
  // late var _encoding;

  ChatBloc() : super(ChatInitialState(chatNow: 0)) {
    on<ChatInitEvent>(_onInit);
    on<ChatSentEvent>(_onSent);
    on<ChatCreateEvent>(_onCreate);
    on<ChatNowEvent>(_onChatNow);
    on<ChatFirstEvent>(_onGet);
    on<ChatRenameEvent>(_onRename);
    on<ChatDeleteEvent>(_onDelete);
    on<ChatSetLikeEvent>(_onSetLike);
    on<ChatClearEvent>(_onClearChat);
    // on<ChatSaveEvent>(_saveChat);
  }

  void _onInit(ChatInitEvent event, Emitter emit) async {
    // _encoding = encodingForModel('gpt-3.5-turbo');
    _openAI = OpenAI.instance.build(
        token: apiKey,
        baseOption: HttpSetup(
            receiveTimeout: const Duration(minutes: 5),
            connectTimeout: const Duration(minutes: 5)),
        isLog: true);
    chatNow = 0;
    if (await FirstStart().get()) {
      status = Status.first;
      emit(ChatState(chat: chats, chatNow: chatNow, status: status));
      (FirstStart()).set();
    } else {
      status = Status.success;
      chats.insertAll(0, await SaveChat().getChat());
      emit(ChatState(chat: chats, chatNow: chatNow, status: status));
    }
  }

  void _onClearChat(ChatClearEvent event, Emitter emit) {
    chats.clear();
    SaveChat().deleteAllChat();
    emit(ChatState(chat: chats, chatNow: chatNow, status: status));
  }

  void _onSetLike(ChatSetLikeEvent event, Emitter emit) {
    chats[chatNow].message[event.idMessage].mark = event.mark;
    emit(ChatState(status: status, chat: chats, chatNow: chatNow));
  }

  void _onDelete(ChatDeleteEvent event, Emitter emit) {
    chats.removeAt(event.idChat);
    SaveChat().deleteChat(event.idChat);
    emit(ChatState(chat: chats));
  }

  void _onRename(ChatRenameEvent event, Emitter emit) {
    chats[event.idChat].name = event.name;
    SaveChat().renameChat(event.idChat, chats[event.idChat]);
    emit(ChatState(chat: chats));
  }

  void _onGet(ChatFirstEvent event, Emitter emit) {
    emit(ChatMapState(chat: chats));
  }

  void _onChatNow(ChatNowEvent event, Emitter emit) {
    chatNow = event.chatNow;
    emit(ChatState(chat: chats, chatNow: chatNow, status: status));
  }

  void _onSent(ChatSentEvent event, Emitter emit) async {
    try {
/*       if (chats[chatNow].message.isNotEmpty &&
          chats[chatNow].message.first.type == MessageType.init) {
        emit(ChatState(chat: chats, chatNow: chatNow));

        return;
      } */
      if (chats[chatNow].message.isEmpty) {
        chats[chatNow].message = [
          Message(
              role: Role.user,
              dateTime: DateTime.now().toUtc().millisecondsSinceEpoch,
              type: MessageType.text,
              content: [
                {MessageType.text: event.message}
              ])
        ];
      } else {
        chats[chatNow].message.insert(
            0,
            Message(
                role: Role.user,
                type: MessageType.text,
                dateTime: DateTime.now().toUtc().millisecondsSinceEpoch,
                content: [
                  {MessageType.text: event.message}
                ]));
      }

      emit(ChatState(chat: chats, chatNow: chatNow));

      if (chats[chatNow].message.length < 2) {
        chats[chatNow].name = event.message;
      }

      List<Map<String, String>> jsonContent = [];
      for (var chatMessage in chats[chatNow].message) {
        for (var element in chatMessage.content) {
          if (jsonContent.toString().codeUnits.length / 3.5 <= 2000) {
            jsonContent.insert(0, {
              'role': chatMessage.role == Role.assistant ? 'assistant' : 'user',
              'content': element.values.first,
            });
          } else {
            break;
          }
        }
      }

      chats[chatNow].message.insert(
          0,
          Message(
              dateTime: 0,
              role: Role.assistant,
              type: MessageType.init,
              content: [
                {MessageType.init: 'null'}
              ]));

      emit(ChatState(chat: chats, chatNow: chatNow));

      final request = ChatCompleteText(
          messages: jsonContent,
          maxToken: 1000,
          model: ChatModel.chatGptTurboModel);

      /* final request = CompleteText(
        maxTokens: 1000,
        prompt: event.message,
        model: Model.kTextDavinci3,
      ); */

      // final response = await _openAI.onCompletion(request: request);
      final response = await _openAI.onChatCompletion(request: request);
      dynamic choice;

      var type;
      for (var element in response!.choices) {
        element.message?.content;
        choice = element.message?.content.trim().trimLeft();
        var link =
            linkify(choice, options: const LinkifyOptions(humanize: false));
        type = MessageType.text;
        List<Map<MessageType, String>> message = [];
        for (var i in link) {
          if (i.runtimeType == UrlElement) {
            if (RegExp("\\b(jpg|jpeg|gif|png|photo|image)\\b",
                    caseSensitive: false)
                .hasMatch(i.text)) {
              type = MessageType.image;
              message.add({MessageType.image: i.text.trimRight()});
            } else {
              type = MessageType.link;
              message.add({MessageType.link: i.text.trimRight()});
              message.first.remove(0);
            }
          } else {
            message.add({MessageType.text: i.text});
          }
        }
        choice = message;
      }

      var message = Message(
          dateTime: response.created,
          role: Role.assistant,
          type: type,
          content: choice);

      chats[chatNow].message.first = message;

      SaveChat().addMessage(chats[chatNow].id, chats[chatNow]);
      emit(ChatState(chat: chats, chatNow: chatNow));
    } catch (e) {
      emit(ChatState(error: e.toString(), chat: chats, chatNow: chatNow));
    }
  }

  void _onCreate(ChatCreateEvent event, Emitter emit) {
    var chat =
        Chat(id: chats.length, name: 'chat ${chats.length}', message: []);
    SaveChat().addChat(chats.length, chat);
    chats.add(chat);
    emit(ChatState(chat: chats, chatNow: chatNow, status: status));
  }
}
