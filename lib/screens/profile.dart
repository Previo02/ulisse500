import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ulisse500/provider/private_provider.dart';
import 'package:ulisse500/screens/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userEmail =
        Provider.of<PrivateProvider>(context, listen: false).user?.email ??
            'No email';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profilo Utente"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: const Icon(Icons.logout),
            onTap: () async {
              await Provider.of<PrivateProvider>(context, listen: false)
                  .signOut();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email: $userEmail',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const Text(
              'Trofei Sbloccati',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Expanded(child: Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }
}
