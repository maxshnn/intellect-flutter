// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intellect/bloc/theme/theme_cubit.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../bloc/chat/chat_bloc.dart';
import '../generated/locale_keys.g.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({super.key});

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  bool first = true;
  String language = '';
  @override
  Widget build(BuildContext context) {
    if (first) {
      language = context.locale.toString();
      first = !first;
    }
    return AlertDialog(
      title: Text(LocaleKeys.change_language.tr()),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        RadioListTile(
          title: const Text('English'),
          value: 'en',
          groupValue: language,
          onChanged: (value) {
            setState(() {
              language = value ?? 'en';
            });
          },
        ),
        RadioListTile(
          title: const Text('Русский'),
          value: 'ru',
          groupValue: language,
          onChanged: (value) {
            setState(() {
              language = value ?? 'ru';
            });
          },
        )
      ]),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            LocaleKeys.cancel.tr(),
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        TextButton(
          onPressed: () {
            context.setLocale(Locale(language));
            Navigator.pop(context);
          },
          child: Text(LocaleKeys.apply.tr(),
              style: const TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController language = TextEditingController();
  var length;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) {
/*         for (var i = 1; i < current.chat.length - 1; i++) {
          if (current.chat[i].message == current.chat[i - 1].message &&
              current.chat[i].message.isNotEmpty) {
            context.read<ChatBloc>().add(ChatDeleteEvent(idChat: i));
          }
        } */
        setState(() {
          length = current.chat.length;
        });
        return previous != current && current.chat.isNotEmpty;
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                child: Column(
                  children: [
                    FutureBuilder(
                      // future: asd(),
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            horizontalTitleGap: 3,
                            onTap: () {
                              length =
                                  context.read<ChatBloc>().state.chat.length;

                              context
                                  .read<ChatBloc>()
                                  .add(ChatNowEvent(chatNow: length));
                              context.read<ChatBloc>().state.setChatNow =
                                  length;
                              // context.goNamed('chat');
                              setState(() {
                                Navigator.pushNamed(context, '/chat');
                              });
                            },
                            leading: SvgPicture.asset('assets/svg/new_chat.svg',
                                height: 22,
                                colorFilter: ColorFilter.mode(
                                    Theme.of(context).primaryColor,
                                    BlendMode.srcIn)),
                            title: Text(LocaleKeys.new_chat.tr(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                )),
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount:
                              context.watch<ChatBloc>().state.chat.length,
                          itemBuilder: (context, index) {
                            /* if (state.chat[index].message.isEmpty) {
                                return Container();
                              } */
                            /* if (state.chat[index != 0 ? index : index] ==
                                  state.chat[
                                      index != 0 ? index - 1 : index + 1]) {
                                return Container();
                              } */
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              child: ChatsTile(
                                  question: state.chat[index].name.toString(),
                                  id: index),
                            );
                          }),
                    ),
                    Column(
                      children: [
                        DefaultTile(
                          icon: 'assets/svg/trash.svg',
                          title: LocaleKeys.clear_conversations.tr(),
                          onTap: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(LocaleKeys.clear_conversations.tr()),
                              content:
                                  Text(LocaleKeys.on_clear_conversations.tr()),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    LocaleKeys.cancel.tr(),
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context
                                        .read<ChatBloc>()
                                        .add(ChatClearEvent());

                                    Navigator.pop(context);
                                  },
                                  child: Text(LocaleKeys.yes.tr(),
                                      style:
                                          const TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          ), /* () {
                                
                              } */
                        ),
/*                           DefaultTile(
                              icon: 'assets/svg/person.svg',
                              title: LocaleKeys.upgrade_to_plus.tr(),
                              trailing: Container(
                                height: 25,
                                width: 50,
                                decoration: const BoxDecoration(
                                    color: Color(0xFFFBF3AD),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Center(
                                  child: Text(LocaleKeys.new_plan.tr(),
                                      style: const TextStyle(
                                          color: Color(0xFF887B06),
                                          fontWeight: FontWeight.bold)),
                                ),
                              )), */
                        DefaultTile(
                            icon: 'assets/svg/translation.svg',
                            title: LocaleKeys.change_language.tr(),
                            onTap: () {
                              return showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      const ChangeLanguage());
                            }),
                        DefaultTile(
                          icon: 'assets/svg/sun.svg',
                          title: context.watch<ThemeCubit>().state.theme !=
                                  AppTheme.light
                              ? LocaleKeys.light_mode.tr()
                              : LocaleKeys.dark_mode.tr(),
                          onTap: () {
                            context.read<ThemeCubit>().switchTheme();
                          },
                        ),
                        DefaultTile(
                          icon: 'assets/svg/update.svg',
                          title: LocaleKeys.updates_and_faq.tr(),
                          onTap: () => launchUrlString(
                              'https://help.openai.com/en/articles/6783457-what-is-chatgpt'),
                        ),
/*                           DefaultTile(
                              icon: 'assets/svg/logout.svg',
                              title: LocaleKeys.logout.tr(),
                              color: Colors.red), */
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class DefaultTile extends StatelessWidget {
  final String icon;
  final String title;
  final Widget? trailing;
  final Color? color;
  final Function()? onTap;
  const DefaultTile(
      {super.key,
      required this.icon,
      required this.title,
      this.trailing,
      this.color,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: ListTile(
          onTap: onTap ?? () {},
          horizontalTitleGap: 3,
          leading: SvgPicture.asset(icon,
              height: 25,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor, BlendMode.srcIn)),
          title: Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: color ?? Theme.of(context).primaryColor)),
          trailing: trailing),
    );
  }
}

class ChatsTile extends StatefulWidget {
  final String question;
  final int id;
  const ChatsTile({
    Key? key,
    required this.question,
    required this.id,
  }) : super(key: key);

  @override
  State<ChatsTile> createState() => _ChatsTileState();
}

class _ChatsTileState extends State<ChatsTile> {
  final TextEditingController _textController = TextEditingController();
  bool edit = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 3,
      onTap: () {
        context.read<ChatBloc>().add(ChatNowEvent(chatNow: widget.id));
        setState(() {
          Navigator.pushNamed(context, '/chat');
        });
      },
      leading: SvgPicture.asset(
        'assets/svg/chat.svg',
        height: 20,
        colorFilter:
            ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn),
      ),
      title: !edit
          ? Text(
              widget.question.capitalize(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.clip,
              maxLines: 2,
            )
          : TextField(
              style: const TextStyle(fontWeight: FontWeight.w500),
              decoration: const InputDecoration(border: InputBorder.none),
              autofocus: true,
              controller: _textController,
              onSubmitted: (value) {
                edit = !edit;
                context.read<ChatBloc>().add(ChatRenameEvent(
                    idChat: widget.id, name: _textController.text));
              },
              onTapOutside: (event) {
                edit = !edit;
                context.read<ChatBloc>().add(ChatRenameEvent(
                    idChat: widget.id, name: _textController.text));
              },
            ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PopupMenuTheme(
            data: Theme.of(context).popupMenuTheme,
            child: PopupMenuButton(
              icon: Icon(Icons.more_vert_outlined,
                  color: Theme.of(context).primaryColor),
              itemBuilder: (context) => [
                PopupMenuItem(
                    onTap: () {
                      setState(() {
                        edit = !edit;
                        _textController.text = widget.question;
                      });
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/svg/edit.svg',
                            colorFilter: ColorFilter.mode(
                                Theme.of(context).primaryColor,
                                BlendMode.srcIn)),
                        const SizedBox(width: 10),
                        Text(LocaleKeys.edit.tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ))
                      ],
                    )),
                PopupMenuItem(
                    onTap: () {
                      context
                          .read<ChatBloc>()
                          .add(ChatDeleteEvent(idChat: widget.id));
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/svg/trash.svg',
                            colorFilter: const ColorFilter.mode(
                                Colors.red, BlendMode.srcIn)),
                        const SizedBox(width: 10),
                        Text(LocaleKeys.delete.tr(),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.red))
                      ],
                    )),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
