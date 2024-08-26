import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ulisse500/classes/dinosaur.dart';
import 'package:ulisse500/screens/ar_view.dart';

class DinosaurDetailPage extends StatelessWidget {
  final Dinosaur dinosaur;

  const DinosaurDetailPage({super.key, required this.dinosaur});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dinosaur.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(dinosaur.image),
            const SizedBox(height: 16.0),
            Text(
              dinosaur.description,
              style: const TextStyle(fontSize: 16.0),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Verifica lo stato dei permessi della fotocamera
                  var status = await Permission.camera.status;

                  if (status.isGranted) {
                    // Se il permesso è già concesso, naviga verso la pagina AR
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ARViewPage(dinosaur: dinosaur),
                      ),
                    );
                  } else if (status.isDenied) {
                    // Se il permesso è negato, richiedilo all'utente
                    status = await Permission.camera.request();
                    if (status.isGranted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ARViewPage(dinosaur: dinosaur),
                        ),
                      );
                    } else {
                      // Se il permesso viene rifiutato, mostra un messaggio all'utente
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Camera permission is required to use AR features.',
                          ),
                        ),
                      );
                    }
                  } else if (status.isRestricted || status.isPermanentlyDenied) {
                    // Se l'accesso è limitato o permanentemente negato, mostra un messaggio
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Camera permission is required to use AR features. Please enable it in settings.',
                        ),
                      ),
                    );
                    // Qui puoi eventualmente guidare l'utente alle impostazioni dell'app
                  }
                },
                child: const Text('Mostra in AR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
