import 'dart:developer';

import 'package:chatbot/core/data/local/app_preferences.dart';
import 'package:chatbot/di.dart';
import 'package:chatbot/src/chat/chat_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final prefs = sl<AppPreferences>();

    // log(prefs.getToken().toString());
    return Scaffold(
      body: const Center(
        child: Text('Open Example'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(ChatScreen.route);
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
