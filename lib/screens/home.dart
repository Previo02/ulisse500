import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ulisse500/classes/museum.dart';
import 'package:ulisse500/provider/element_provider.dart';
import 'package:ulisse500/provider/private_provider.dart';
import 'package:ulisse500/screens/login.dart';
import 'package:ulisse500/screens/quiz_page.dart';
import 'package:ulisse500/screens/detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  double radius = 8.0;
  bool isLoading = true;
  final MuseumService _museumService = MuseumService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadMuseumStatus();
  }

  Future<void> _loadMuseumStatus() async {
    _museumService.loadMuseumsFromJson();
    List<String> lockedMuseumsIds = await _museumService.getLockedMuseums();

    if (!mounted) return;
    setState(() {
      for (var museum in _museumService.museums) {
        museum.isLocked = lockedMuseumsIds.contains(museum.id);
      }
      isLoading = false;
    });
  }

  void _unlockMuseum(Museum museum) {
    if (!mounted) return;
    setState(() {
      museum.isLocked = false;
    });

    List<String> lockedMuseumIds = _museumService.museums
        .where((museum) => museum.isLocked)
        .map((museum) => museum.id)
        .toList();
    _museumService.updateLockedMuseumStatus(lockedMuseumIds);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Ulisse500",
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
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
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Ulisse500",
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
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
        body: GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 4 / 5,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: _museumService.museums.length,
          itemBuilder: (context, index) {
            final museum = _museumService.museums[index];
            return GestureDetector(
              onTap: () {
                if (museum.isLocked) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QuizPage(
                        museum: museum,
                        onUnlock: () => _unlockMuseum(museum),
                        museumService: _museumService,
                      ),
                    ),
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          MuseumDetailPage(museum: museum),
                    ),
                  );
                }
              },
              child: Card(
                borderOnForeground: false,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(radius),
                            child: Image.asset(
                              museum.image,
                              fit: BoxFit.fill,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(radius),
                                child: Container(
                                  color:
                                      const Color.fromARGB(255, 92, 200, 214),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      museum.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (museum.isLocked)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(radius),
                        child: Container(
                          color: Colors.grey.withOpacity(0.8),
                          child: const Center(
                            child: Icon(
                              Icons.lock,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
