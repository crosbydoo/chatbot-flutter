import 'package:chatbot/common_ui/color_schemes.g.dart';
import 'package:chatbot/core/utils/date_time_util.dart';

import 'package:chatbot/di.dart';
import 'package:chatbot/src/auth/presentation/screens/login_screen.dart';
import 'package:chatbot/src/chat/chat_screen.dart';
import 'package:chatbot/src/main/presentation/main_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await initializeDateFormatting(DateTimeUtil.locale, null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chatbot',
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
        navigationBarTheme: const NavigationBarThemeData(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.route,
      routes: {
        MainPage.route: (ctx) => const MainPage(),
        LoginScreen.route: (ctx) => const LoginScreen(),
        ChatScreen.route: (ctx) => const ChatScreen(),
        // ExampleIsTyping.route: (ctx) => const ExampleIsTyping(),
        // ChatScreenNew.route: (ctx) => const ChatScreenNew(),
        // ExamplePage.route: (ctx) => const ExamplePage(),
      },
    );
  }
}
