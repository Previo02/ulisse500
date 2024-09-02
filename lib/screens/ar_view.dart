import 'dart:developer';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:ulisse500/classes/dinosaur.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:arkit_plugin/arkit_plugin.dart';

class ARViewPage extends StatefulWidget {
  const ARViewPage({super.key, required this.dinosaur});
  final Dinosaur dinosaur;

  @override
  ARViewPageState createState() => ARViewPageState();
}

class ARViewPageState extends State<ARViewPage> {
  late ArCoreController arCoreController;
  late ARKitController arKitController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dinosaur.name),
      ),
      body: Stack(
        children: [
          if (Platform.isAndroid)
            ArCoreView(
              onArCoreViewCreated: _onArCoreViewCreated,
            ),
          if (Platform.isIOS)
            ARKitSceneView(
              onARKitViewCreated: _onARKitViewCreated,
            ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _onAddLocalObjectButtonPressed,
                child: const Text("Add Model"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
  }

  void _onARKitViewCreated(ARKitController controller) {
    arKitController = controller;
  }

  Future<void> _onAddLocalObjectButtonPressed() async {
    try {
      if (Platform.isAndroid) {
        log("Removing existing node...");
        await arCoreController.removeNode(nodeName: widget.dinosaur.name);
        await Future.delayed(const Duration(milliseconds: 500));
        log("Adding new node to ARCore...");
        final node = ArCoreReferenceNode(
          name: widget.dinosaur.name,
          objectUrl: "asset/models/felis.glb",
          position: Vector3(0, 0, 1.5),
          scale: Vector3(0.5, 0.5, 0.5),
        );
        await arCoreController.addArCoreNodeWithAnchor(node);
      } else if (Platform.isIOS) {
        log("Removing existing node...");
        await arKitController.remove(widget.dinosaur.name);
        await Future.delayed(const Duration(milliseconds: 500));
        log("Adding new node to ARKit...");
        final node = ARKitGltfNode(
          name: widget.dinosaur.name,
          assetType: AssetType.flutterAsset,
          url: 'assets/models/felis.glb',
          position: Vector3(0, 0, -2),
          scale: Vector3(0.2, 0.2, 0.2),
        );
        await arKitController.add(node);
      }

      log("Model added successfully.");
    } catch (e) {
      log("Error adding model: $e");
    }
  }

  @override
  void dispose() {
    if (Platform.isAndroid) {
      arCoreController.dispose();
    } else if (Platform.isIOS) {
      arKitController.dispose();
    }
    super.dispose();
  }
}
