import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ulisse500/classes/museum.dart';
import 'package:ulisse500/screens/ar/ar_view_android.dart';
import 'package:ulisse500/screens/ar/ar_view_ios.dart';

class MuseumDetailPage extends StatefulWidget {
  final Museum museum;
  const MuseumDetailPage({super.key, required this.museum});

  @override
  State<MuseumDetailPage> createState() => _MuseumDetailPageState();
}

class _MuseumDetailPageState extends State<MuseumDetailPage> {
  final styleText = const TextStyle(
    color: Colors.black,
    fontFamily: "Trajan",
    fontSize: 18,
  );
  late Future<PermissionStatus> cameraStatus;

  @override
  void initState() {
    super.initState();
    setState(() {
      cameraStatus = Permission.camera.status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.museum.category),
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
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    children: [
                      Image.asset(
                        widget.museum.image,
                        alignment: Alignment.topCenter,
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          style: styleText,
                          children: [
                            const TextSpan(
                              text: 'Descrizione: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: widget.museum.description),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      RichText(
                        text: TextSpan(
                          style: styleText,
                          children: [
                            const TextSpan(
                              text: 'Indirizzo: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: widget.museum.indirizzo),
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
                            TextSpan(text: widget.museum.curiosity),
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
                  //var status = await Permission.camera.status;
                  if (await cameraStatus.isGranted) {
                    if (!context.mounted) return;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Platform.isAndroid
                              ? ARViewAndroid(museum: widget.museum)
                              : ARViewIOS(museum: widget.museum),
                        ),
                      );
                    });
                  } else if (await cameraStatus.isDenied) {
                    cameraStatus = Permission.camera.request();
                    if (await cameraStatus.isGranted) {
                      if (!context.mounted) return;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Platform.isAndroid
                                ? ARViewAndroid(museum: widget.museum)
                                : ARViewIOS(museum: widget.museum),
                          ),
                        );
                      });
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
                  } else if (await cameraStatus.isRestricted || await cameraStatus.isPermanentlyDenied) {
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
