import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:intellect/bloc/chat/chat_bloc.dart';
import 'package:intellect/constants.dart';

import '../generated/locale_keys.g.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                SizedBox(height: gap(context, 2)),
                SvgPicture.asset(
                  'assets/svg/chatGptIcon.svg',
                ),
                SizedBox(height: defaultGap),
                Text(LocaleKeys.welcome_to_intellect.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor)),
                SizedBox(height: defaultGap),
                Text(LocaleKeys.ask_anything.tr(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor)),
                // SizedBox(height: gap(context, 2)),
                const Examples(),
              ],
            )),
      ),
    );
  }
}

class Examples extends StatefulWidget {
  const Examples({super.key});

  @override
  State<Examples> createState() => _ExamplesState();
}

class _ExamplesState extends State<Examples> {
  int _page = 0;
  List<Widget> tiles = [
    TileBlock(
        icon: 'assets/svg/sun.svg',
        title: LocaleKeys.examples.tr(),
        body: [
          Tile(
              title: LocaleKeys.explain_quantum_computing_in_simple_terms.tr(),
              page: 0),
          Tile(
              title: LocaleKeys
                  .got_any_creative_ideas_for_a_10_year_olds_birthday
                  .tr(),
              page: 0),
          Tile(
            title: LocaleKeys.how_do_i_make_an_http_request_in_js.tr(),
            page: 0,
          ),
        ]),
    TileBlock(
        icon: 'assets/svg/lightning.svg',
        title: LocaleKeys.capabilities.tr(),
        body: [
          Tile(
              title: LocaleKeys
                  .remembers_what_user_said_earlier_in_the_conversation
                  .tr()),
          Tile(
              title:
                  LocaleKeys.allows_user_to_provide_follow_up_corrections.tr()),
          Tile(
              title: LocaleKeys.trained_to_decline_inappropriate_requests.tr()),
        ]),
    TileBlock(
        icon: 'assets/svg/warning.svg',
        title: LocaleKeys.limitations.tr(),
        body: [
          Tile(
              title: LocaleKeys.may_occasionally_generate_incorrect_information
                  .tr()),
          Tile(
              title: LocaleKeys
                  .may_occasionally_produce_harmful_instructions_or_biased_content
                  .tr()),
          Tile(
              title: LocaleKeys.limited_knowledge_of_world_and_events_after_2021
                  .tr()),
        ]),
  ];
  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: 0);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
      // padding: EdgeInsets.all(value),
      child: Center(
        child: Column(
          children: [
            SizedBox(height: gap(context, 2)),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: PageView(
                onPageChanged: (value) => setState(() {
                  _page = value;
                }),
                controller: controller,
                children: tiles,
              ),
            ),
            SizedBox(height: gap(context, 2)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                  3,
                  (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 30,
                          height: 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1),
                            color: _page == index
                                ? colorElement
                                : const Color(0xff5d5d67),
                            // color: const Color(0xff5d5d67),
                          ),
                        ),
                      )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 55,
                width: double.maxFinite,
                child: ElevatedButton(
                    onPressed: () {
                      if (_page != tiles.length - 1) {
                        controller.animateToPage(++_page,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease);
                      } else {
                        // context.go('/dashboard');
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (Route<dynamic> route) => false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontSize: 16),
                        backgroundColor: colorElement),
                    child: _page != tiles.length - 1
                        ? Text(
                            LocaleKeys.next.tr(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          )
                        : Text(LocaleKeys.lets_chat.tr(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TileBlock extends StatelessWidget {
  final String icon;
  final String? title;
  final List<Widget> body;
  const TileBlock(
      {required this.icon, this.title, required this.body, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: gap(context, 2)),
          SvgPicture.asset(
            height: 25,
            width: 25,
            icon,
            colorFilter: ColorFilter.mode(
                Theme.of(context).primaryColor, BlendMode.srcIn),
          ),
          const SizedBox(height: 10),
          Text(title ?? '',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: Theme.of(context).primaryColor)),
          const Spacer(),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3 + 30,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: body.length,
              itemBuilder: (context, index) {
                return body[index];
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final String title;
  int? page = 1;
  Tile({
    Key? key,
    required this.title,
    this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: page == 0
                ? () {
                    if (context.read<ChatBloc>().state.chat.isEmpty) {
                      context.read<ChatBloc>().add(ChatCreateEvent());
                    }
                    context.read<ChatBloc>().add(ChatSentEvent(
                        idChat: 0,
                        message:
                            title.replaceAll("“", "").replaceAll("”", "")));

                    context.read<ChatBloc>().state.setChatNow = 0;
                    Navigator.pushNamed(context, '/chat');
                  }
                : () {},
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
