import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:for_you/providers/auth_providers.dart';
import 'package:for_you/providers/contact_providers.dart';
import 'package:for_you/providers/message_providers.dart';
import 'package:for_you/ui/screen/auth_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => MessagesProvider(),
        ),
        ChangeNotifierProxyProvider<MessagesProvider, ContactsProvider>(
          create: (_) => ContactsProvider(),
          update: (_, msgMgr, contactsProvider) =>
              contactsProvider!..update(msgMgr),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        )
    ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Messager',
        theme: ThemeData(
          primaryColor: Colors.lightBlueAccent[700],
          scaffoldBackgroundColor: Color(0xFFfefefe),
          fontFamily: "Roboto",
          appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.grey[800]),
          ),
          iconTheme: IconThemeData(color: Colors.grey[800]),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          "/": (_) => AuthScreen(),
          // HomeScreen.routeName: (_) => HomeScreen(),
          // ArchivedMessagesScreen.routeName: (_) => ArchivedMessagesScreen(),
          // SpamBlockedMessagesScreen.routeName: (_) =>
          //     SpamBlockedMessagesScreen(),
          // SettingsScreen.routeName: (_) => SettingsScreen(),
          // MessagesForWebScreen.routeName: (_) => MessagesForWebScreen(),
        },
      ),
    );
  }
}