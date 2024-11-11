import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intellect/bloc/chat/chat_bloc.dart';
import 'package:intellect/constants.dart';

class Init extends StatefulWidget {
  const Init({super.key});

  @override
  State<Init> createState() => _InitState();
}

class _InitState extends State<Init> {
  @override
  Future<void> timeDelay() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: BlocBuilder<ChatBloc, ChatState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          Future.delayed(
            Duration.zero,
            () {
              if (mounted) {
                if (context.read<ChatBloc>().state.status == Status.first) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/welcome',
                    (route) => false,
                  );
                  didChangeDependencies();
                  deactivate();
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                  didChangeDependencies();
                  deactivate();
                }
              }
            },
          );

          return const CircularProgressIndicator.adaptive(
            backgroundColor: colorElement,
          );
        },
      )),
    );
  }
}
