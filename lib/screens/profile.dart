import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ulisse500/provider/private_provider.dart';
import 'package:ulisse500/screens/history_page.dart';
import 'package:ulisse500/screens/login.dart';
import 'package:ulisse500/provider/element_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final MuseumService museumService = MuseumService();
  List<String> unlockedTrophies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrophies();
    museumService.loadMuseumsFromJson();
  }

  Future<void> _loadTrophies() async {
    List<String> unlocked = await museumService.getUnlockedMuseums();
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
    bool areTrophiesPresent = unlockedTrophies.isNotEmpty;
    final username = userEmail.split("@")[0];
    final screenWidth = MediaQuery.of(context).size.width;
    final trophySize = screenWidth * 0.15;

    return Scaffold(
      appBar: AppBar(
        title: Text(username),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: Icon(
              Icons.logout,
              size: trophySize * 0.5,
            ),
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Musei Visitati',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : areTrophiesPresent
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: unlockedTrophies.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
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
                                                museumService.museums
                                                    .firstWhere((museum) =>
                                                        museum.id ==
                                                        unlockedTrophies[index])
                                                    .name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold,
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
                          )
                        : const Center(
                            child: Text("Non ci sono trofei presenti"),
                          ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black54,
              onPressed: () async {
                if (!context.mounted) return;
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
                );
              },
              child: Icon(
                Icons.history_edu,
                size: trophySize * 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
