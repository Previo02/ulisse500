import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ulisse500/classes/dinosaur.dart';
import 'package:ulisse500/screens/ar/ar_view_android.dart';
import 'package:ulisse500/screens/ar/ar_view_ios.dart';

class DinosaurDetailPage extends StatelessWidget {
  final Dinosaur dinosaur;
  final styleText = const TextStyle(
    color: Colors.black,
    fontFamily: "Trajan",
    fontSize: 18,
  );

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
            Image.asset(dinosaur.image), // L'immagine è fissa
            const SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: styleText,
                          children: [
                            const TextSpan(
                              text: 'Descrizione: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: dinosaur.description),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      RichText(
                        text: TextSpan(
                          style: styleText,
                          children: [
                            const TextSpan(
                              text: 'Periodo di vita: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: dinosaur.period),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      RichText(
                        text: TextSpan(
                          style: styleText,
                          children: [
                            const TextSpan(
                              text: 'Peso: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '${dinosaur.weight} kg'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      RichText(
                        text: TextSpan(
                          style: styleText,
                          children: [
                            const TextSpan(
                              text: 'Curiosità: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: dinosaur.curiosity),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  var status = await Permission.camera.status;
              
                  if (status.isGranted) {
                    if (!context.mounted) return;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Platform.isAndroid
                            ? ARViewAndroid(dinosaur: dinosaur)
                            : ARViewIOS(dinosaur: dinosaur),
                      ),
                    );
                  } else if (status.isDenied) {
                    status = await Permission.camera.request();
                    if (status.isGranted) {
                      if (!context.mounted) return;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Platform.isAndroid
                              ? ARViewAndroid(dinosaur: dinosaur)
                              : ARViewIOS(dinosaur: dinosaur),
                        ),
                      );
                    } else {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Camera permission is required to use AR features.',
                          ),
                        ),
                      );
                    }
                  } else if (status.isRestricted || status.isPermanentlyDenied) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Camera permission is required to use AR features. Please enable it in settings.',
                        ),
                      ),
                    );
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
