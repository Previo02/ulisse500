import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ulisse500/classes/dinosaur.dart';
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
  bool _isLoading = true;
  final DinosaurService _dinosaurService = DinosaurService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadDinosaurStatus();
  }

  Future<void> _loadDinosaurStatus() async {
    List<String> lockedDinosaurIds =
        await _dinosaurService.getLockedDinosaurs();

    if (!mounted) return;
    setState(() {
      for (var dinosaur in _dinosaurService.dinosaurs) {
        dinosaur.isLocked = lockedDinosaurIds.contains(dinosaur.id);
      }
      _isLoading = false;
    });
  }

  void _unlockDinosaur(Dinosaur dinosaur) {
    if (!mounted) return;
    setState(() {
      dinosaur.isLocked = false;
    });

    List<String> lockedDinosaurIds = _dinosaurService.dinosaurs
        .where((dino) => dino.isLocked)
        .map((dino) => dino.id)
        .toList();
    _dinosaurService.updateLockedDinosaurStatus(lockedDinosaurIds);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Ulisse500"),
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
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Ulisse500"),
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
        body: GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 4 / 5,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: _dinosaurService.dinosaurs.length,
          itemBuilder: (context, index) {
            final dinosaur = _dinosaurService.dinosaurs[index];
            return GestureDetector(
              onTap: () {
                if (dinosaur.isLocked) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QuizPage(
                        dinosaur: dinosaur,
                        onUnlock: () => _unlockDinosaur(dinosaur),
                        dinosaurService: _dinosaurService,
                      ),
                    ),
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          DinosaurDetailPage(dinosaur: dinosaur),
                    ),
                  );
                }
              },
              child: Card(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(radius),
                            child: Image.asset(
                              dinosaur.image,
                              fit: BoxFit.contain,
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
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      dinosaur.name,
                                      style: const TextStyle(
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
                    if (dinosaur.isLocked)
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
