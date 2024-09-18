import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:ulisse500/provider/private_provider.dart';
import 'package:ulisse500/routing/navigator.dart';
import 'package:ulisse500/screens/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = screenHeight * 0.15;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: appBarHeight,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                "assets/images/sigillo.png",
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          'Ulisse500',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    UserCredential userCredential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                    if (!context.mounted) return;
                    Provider.of<PrivateProvider>(context, listen: false)
                        .updateUser(userCredential.user);

                    if (!context.mounted) return;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const NavigatorPage()),
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to sign in: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
                child: const Text(
                  'Create an account',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
