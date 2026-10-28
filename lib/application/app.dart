import 'package:den_ai/application/l10n.dart';
import 'package:den_ai/application/routes.dart';
import 'package:den_ai/screens/chat_lists_screen.dart';
import 'package:den_ai/widgets/notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';

class ChatApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DenAI',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF161622),
        cardColor: const Color(0xFF252538),
        dividerColor: Color(0xFF5C62A3),
        hintColor: const Color(0xFF6B729C),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF12121A),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          shape: Border(
            bottom: BorderSide(
              color: Color(0xFF5C62A3),
              width: 1,
            ),
          ),
        ),

        colorScheme: ColorScheme.dark(
          primary: Colors.indigo.shade400,
          secondary: Colors.purple.shade300,
          surface: const Color(0xFF212132),
          outlineVariant: const Color(0xFF5C62A3),

          onSurface: Colors.white.withValues(alpha: 0.95),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1B1B29),
          hintStyle: TextStyle(color: const Color(0xFF6B729C)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.indigo.shade400, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: const Color(0xFF2A2A40)),
          ),
        ),

        dialogTheme: DialogThemeData(
          backgroundColor: const Color(0xFF212132),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
            return Colors.indigo.shade400;

          }),
          trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.indigo.shade400.withValues(alpha: 0.5);
            }
            return const Color(0xFF1B1B29);
          }),
          trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.transparent;
            }
            return Colors.indigo.shade400.withAlpha(150);
          }),
        ),
      ),

      supportedLocales: const [Locale('en'), Locale('ru')],
      localizationsDelegates: const [
        AppLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => NotifyWidget(navKey: navigatorKey, child: child),
      home: const ChatsListScreen(),
      initialRoute: AppRoutes.home,
      onGenerateRoute: _onGenerateRoute,
      navigatorKey: navigatorKey,
      navigatorObservers: [GetIt.instance.get<AppRouteObserver>()],
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    return AppRoutes.createRoute(settings.name, settings: settings);
  }
}
