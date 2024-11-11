import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intellect/bloc/chat/chat_bloc.dart';
import 'package:intellect/constants.dart';
import 'package:intellect/models/chat.dart';
import 'package:url_launcher/link.dart';

import '../bloc/theme/theme_cubit.dart';
import '../generated/locale_keys.g.dart';

class Chat extends StatefulWidget {
  // final int id;
  const Chat({
    // required this.id,
    Key? key,
  }) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int id = context.watch<ChatBloc>().state.chatNow ?? 0;

    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) {
        if (current.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: colorElement,
              content: Center(child: Text('Error: ${current.error}'))));
        }
        return previous != current &&
            previous.chat.asMap().containsKey(id) &&
            previous.chat.asMap().containsKey(id);
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              iconSize: 20,
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                // context.read<ChatBloc>().add(ChatSaveEvent());
                Navigator.pop(context);
              },
            ),
            titleSpacing: 0,
            bottomOpacity: 0.0,
            elevation: 0.0,
            title: Text(LocaleKeys.retour.tr(),
                style: const TextStyle(fontWeight: FontWeight.w600)),
            actions: [
              Align(
                child: SvgPicture.asset('assets/svg/chatGptIcon.svg',
                    height: 30,
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).primaryColor, BlendMode.srcIn)),
              ),
              const SizedBox(
                width: 30,
              ),
            ],
          ),
          floatingActionButton: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                TextInput(id: id),
                !state.chat.asMap().containsKey(id)
                    ? Container()
                    : Positioned(
                        bottom: 100,
                        child: SizedBox(
                          width: 198,
                          height: 35,
                          child: TextButton(
                            onPressed: () {
                              var lastMessage = state.chat[id].message
                                  .where((element) => element.role == Role.user)
                                  .first;
                              context.read<ChatBloc>().add(ChatSentEvent(
                                  idChat: id,
                                  message: lastMessage
                                      .content.single.values.single));
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18))),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 36, 36, 36))),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svg/regenerate.svg',
                                        // height: 12,
                                        width: 16,
                                      ),
                                      const Spacer(),
                                      Text(
                                        LocaleKeys.regenerate_response.tr(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 14),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (!state.chat.asMap().containsKey(id)) {
                          return Center(
                            child: Text(LocaleKeys.write_message.tr(),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          );
                        } else {
                          return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: MessageCard(id: id));
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 50)
                  /*                 Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TextInput(id: id),
                  ), */
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class TextInput extends StatefulWidget {
  final int id;

  const TextInput({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  final TextEditingController _controller = TextEditingController();
  final StreamController<bool> _disableController = StreamController<bool>();

  @override
  void initState() {
    _disableController.add(true);

    super.initState();
  }

  @override
  void dispose() {
    _disableController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int id = widget.id;
    return StreamBuilder(
        stream: _disableController.stream,
        builder: (context, snapshot) {
          bool _disable = snapshot.data ?? true;
          if (context.watch<ChatBloc>().state.chat.asMap().containsKey(id)) {
            if (context.watch<ChatBloc>().state.chat[id].message.first.type ==
                MessageType.init) {
              _disableController.add(true);
            } else if (_controller.text.isNotEmpty &&
                !RegExp(r'^\s').hasMatch(_controller.text)) {
              _disableController.add(false);
            }
          }
          if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(80)),
              child: TextField(
                  onSubmitted: (text) {
                    setState(() {
                      if (_disable) {
                      } else {
                        sendMessage(context, id, _controller.text);
                        _controller.clear();
                        _disableController.add(false);
                      }
                    });
                  },
                  // keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (value) {
                    if (_controller.text.isNotEmpty &&
                        !RegExp(r'^\s').hasMatch(_controller.text)) {
                      _disableController.add(false);
                    } else {
                      _disableController.add(true);
                    }
                  },
                  textAlignVertical: TextAlignVertical.center,
                  cursorColor: Theme.of(context).primaryColor,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                      left: 25,
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(80)),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            color: _disable ? Colors.blueGrey : colorElement),
                        child: IconButton(
                          color: colorElement,
                          icon: Center(
                            child: SvgPicture.asset(
                              'assets/svg/sent.svg',
                              height: 30,
                              width: 30,
                            ),
                          ),
                          onPressed: _disable
                              ? null
                              : () {
                                  setState(() {
                                    sendMessage(context, id, _controller.text);
                                    _controller.clear();
                                    _disableController.add(false);
                                  });
                                },
                        ),
                      ),
                    ),
                  ),
                  controller: _controller),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

class MessageCard extends StatefulWidget {
  final int id;
  const MessageCard({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard>
    with TickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  late bool loading;

  @override
  Widget build(BuildContext context) {
    int id = widget.id;
    var bloc = context.watch<ChatBloc>().state.chat;

    return BlocConsumer<ChatBloc, ChatState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (_controller.hasClients) {
          _controller.animateTo(_controller.position.minScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.linear);
        }
      },
      builder: (context, state) {
        return ListView.builder(
            physics: const BouncingScrollPhysics(),
            reverse: true,
            shrinkWrap: true,
            controller: _controller,
            itemCount: bloc[id].message.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 0 == index ? 90 : 0),
                child: Row(
                  mainAxisAlignment: bloc[id].message[index].role == Role.user
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) {
                        if ((bloc[id].message[index].content.isEmpty ||
                            bloc[id].message[index].content.last.keys.first ==
                                MessageType.init)) {
                          return const LoadingMessage();
                        } else if (bloc[id].message[index].role ==
                            Role.assistant) {
                          return assistantMessage(context, id, index);
                        } else {
                          return userMessage(context, id, index);
                        }
                      },
                    ),
                  ],
                ),
              );
            });
      },
    );
  }
}

void sendMessage(BuildContext context, int idChat, String text) {
  if (!context.read<ChatBloc>().state.chat.asMap().containsKey(idChat)) {
    context.read<ChatBloc>().add(ChatCreateEvent());
    context.read<ChatBloc>().add(ChatSentEvent(idChat: idChat, message: text));
  } else {
    context.read<ChatBloc>().add(ChatSentEvent(idChat: idChat, message: text));
  }
}

class LoadingMessage extends StatefulWidget {
  const LoadingMessage({super.key});

  @override
  State<LoadingMessage> createState() => _LoadingMessageState();
}

class _LoadingMessageState extends State<LoadingMessage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _opacity = 0;
  int _point = 0;

  @override
  void initState() {
    _animationController = AnimationController(
        lowerBound: 0.3,
        vsync: this,
        duration: const Duration(milliseconds: 300))
      ..forward();
    _animationController.addListener(() async {
      setState(() {
        _opacity = _animationController.value;
      });

      if (_animationController.isCompleted) {
        _animationController.reverse();
        setState(() {
          _point = _point == 2 ? 0 : _point + 1;
        });
      }
      if (_animationController.isDismissed) {
        _animationController.forward();
      }
    });
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInExpo);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var color = context.read<ThemeCubit>().state.theme == AppTheme.dark ??
    var color = Theme.of(context).iconTheme.color;
    List<Widget> icon = List.generate(
        3,
        (index) => Icon(Icons.circle,
            size: 15,
            color: color?.withOpacity(_point == index ? _opacity : 1)));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(13),
                  topRight: Radius.circular(13),
                  bottomRight: Radius.circular(13))),
          child: Center(
            child: Row(children: icon),
          )),
    );
  }
}

Widget assistantMessage(BuildContext context, int idChat, int index) {
  var bloc = context.watch<ChatBloc>().state.chat;

  return Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 100,
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
                bottomRight: Radius.circular(13)),
            color: Theme.of(context).colorScheme.tertiary,
          ),
          child: Builder(builder: (context) {
            List<Widget> widgets = [];
            var length = bloc[idChat].message[index].content.length;
            for (int i = 0; i < length; i++) {
              var element = bloc[idChat].message[index].content[i];
              if (element.keys.first == MessageType.text) {
                widgets.add(Text(
                  element.values.first.capitalize(),
                  softWrap: true,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ));
              } else if (element.keys.first == MessageType.image) {
                try {
                  widgets.add(CachedNetworkImage(
                      imageUrl: element.values.first,
                      errorWidget: (context, url, error) => Link(
                            target: LinkTarget.blank,
                            uri: Uri.parse(element.values.first),
                            builder: (context, followLink) => TextButton(
                                onPressed: followLink,
                                child: Text(
                                  element.values.first,
                                  softWrap: true,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )),
                          )));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: colorElement,
                      content: Center(
                          child: Text(
                              'An error has occurred, it is recommended that the application enable VPN for better performance'))));
                  widgets.add(Link(
                    target: LinkTarget.blank,
                    uri: Uri.parse(element.values.first),
                    builder: (context, followLink) => TextButton(
                        onPressed: followLink,
                        child: Text(
                          element.values.first,
                          softWrap: true,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                  ));
                }
              } else if (element.keys.first == MessageType.link) {
                widgets.add(Link(
                  target: LinkTarget.blank,
                  uri: Uri.parse(element.values.first),
                  builder: (context, followLink) => TextButton(
                      onPressed: followLink,
                      child: Text(
                        element.values.first,
                        softWrap: true,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                ));
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widgets,
            );
          }),
        ),
        Container(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                padding: const EdgeInsets.only(right: 8),
                constraints: const BoxConstraints(),
                onPressed: () {
                  context
                      .read<ChatBloc>()
                      .add(ChatSetLikeEvent(idMessage: index, mark: Mark.like));
                },
                icon: SvgPicture.asset(
                  'assets/svg/like.svg',
                  height: 20,
                  width: 20,
                  colorFilter: ColorFilter.mode(
                      context
                                  .watch<ChatBloc>()
                                  .state
                                  .chat[idChat]
                                  .message[index]
                                  .mark ==
                              Mark.like
                          ? Colors.red
                          : const Color(0xFF85868d),
                      BlendMode.srcIn),
                ),
              ),
              IconButton(
                iconSize: 20,
                padding: const EdgeInsets.only(left: 8),
                constraints: const BoxConstraints(),
                onPressed: () {
                  context.read<ChatBloc>().add(
                      ChatSetLikeEvent(idMessage: index, mark: Mark.dislike));
                },
                icon: SvgPicture.asset(
                  'assets/svg/dislike.svg',
                  height: 20,
                  width: 20,
                  colorFilter: ColorFilter.mode(
                      context
                                  .watch<ChatBloc>()
                                  .state
                                  .chat[idChat]
                                  .message[index]
                                  .mark ==
                              Mark.dislike
                          ? Colors.red
                          : const Color(0xFF85868d),
                      BlendMode.srcIn),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextButton.icon(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey)),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(
                            text: bloc[idChat]
                                .message[index]
                                .content
                                .last
                                .values
                                .last))
                        .then((value) => ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                                backgroundColor: colorElement,
                                content: Center(
                                    child: Text(LocaleKeys.copied.tr())))));
                  },
                  icon: SvgPicture.asset(
                    'assets/svg/copy.svg',
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                        Color(0xFF85868d), BlendMode.srcIn),
                  ),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      LocaleKeys.copy.tr(),
                      style: const TextStyle(
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}

Widget userMessage(BuildContext context, int chatId, int index) {
  return GestureDetector(
    onLongPress: () async {
      await Clipboard.setData(ClipboardData(
              text: context
                  .read<ChatBloc>()
                  .state
                  .chat[chatId]
                  .message[index]
                  .content
                  .last
                  .values
                  .last))
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: colorElement,
              content: Center(child: Text(LocaleKeys.copied.tr())))));
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        width: MediaQuery.of(context).size.width -
            MediaQuery.of(context).size.width * 0.32,
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(
            color: colorElement,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
                bottomLeft: Radius.circular(13))),
        child: Builder(builder: (context) {
          List<Widget> widgets = [];
          for (var element in context
              .watch<ChatBloc>()
              .state
              .chat[chatId]
              .message[index]
              .content) {
            widgets.add(Text(
              element.values.single.capitalize(),
              softWrap: true,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ));
          }
          return Column(
            children: widgets,
          );
        }),
      ),
    ),
  );
}
