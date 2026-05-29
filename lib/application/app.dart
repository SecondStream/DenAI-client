import 'package:chat_bot_client/application/l10n.dart';
import 'package:chat_bot_client/application/routes.dart';
import 'package:chat_bot_client/screens/chat_lists_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat with AI',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1E1E24),
        cardColor: const Color(0xFF2A2A32),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF18181C),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),

        colorScheme: ColorScheme.dark(
          primary: Colors.indigo.shade400,
          secondary: Colors.purple.shade300,
          surface: const Color(0xFF2A2A32),
        ),
      ),
      supportedLocales: const [Locale('en'), Locale('ru')],
      localizationsDelegates: const [
        AppLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const ChatsListScreen(),
      initialRoute: AppRoutes.chats,
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    return AppRoutes.createRoute(settings.name, settings: settings);
  }
}
