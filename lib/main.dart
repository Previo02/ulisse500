import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:ulisse500/provider/private_provider.dart';
import 'package:ulisse500/routing/navigator.dart';
import 'package:ulisse500/screens/login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var authProvider = PrivateProvider();
  authProvider.signOut();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrivateProvider(),
      child: Consumer<PrivateProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'Ulisse500',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: authProvider.isAuthenticated
                ? const NavigatorPage()
                : const LoginPage(),
          );
        },
      ),
    );
  }
}
