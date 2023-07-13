import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_app/firebase_options.dart';
import 'package:new_app/widgets/grocery_list.dart';
import 'package:new_app/providers/authentication_provider.dart';
import 'package:new_app/widgets/sign_in_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthenticationProvider(FirebaseAuth.instance),
      child: MaterialApp(
        title: 'Flutter Groceries',
        theme: ThemeData.dark().copyWith(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 147, 229, 250),
            brightness: Brightness.dark,
            surface: const Color.fromARGB(255, 42, 51, 59),
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
        ),
        home: Consumer<AuthenticationProvider>(
          builder: (context, auth, _) {
            return auth.isSigningIn ? const SignInPage() : const GroceryList();
          },
        ),
      ),
    );
  }
}
