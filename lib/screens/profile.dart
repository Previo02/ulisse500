import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ulisse500/provider/private_provider.dart';
import 'package:ulisse500/screens/login.dart';
import 'package:ulisse500/provider/element_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final DinosaurService dinosaurService = DinosaurService();
  List<String> unlockedTrophies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrophies();
    dinosaurService.loadDinosaursFromJson();
  }

  Future<void> _loadTrophies() async {
    List<String> unlocked = await dinosaurService.getUnlockedDinosaurs();
    setState(() {
      unlockedTrophies = unlocked;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userEmail =
        Provider.of<PrivateProvider>(context, listen: false).user?.email ??
            'No email';

    final username = userEmail.split("@")[0];
    final screenWidth = MediaQuery.of(context).size.width;
    final trophySize = screenWidth * 0.15;

    return Scaffold(
      appBar: AppBar(
        title: Text(username),
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
            const Text(
              'Trofei Sbloccati',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: unlockedTrophies.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/trophy.png',
                                  width: trophySize,
                                  height: trophySize,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Dinosauro ID: ${unlockedTrophies[index]}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        dinosaurService.dinosaurs.firstWhere((dino) => dino.id == unlockedTrophies[index]).name,
                                        style:  const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
