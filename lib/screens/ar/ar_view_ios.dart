import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'ar_view.dart';
import 'package:collection/collection.dart';

class ARViewIOS extends ARViewBase {
  const ARViewIOS({super.key, required super.museum});

  @override
  ARViewIOSState createState() => ARViewIOSState();
}

class ARViewIOSState extends State<ARViewIOS> {
  late ARKitController controller;
  ARKitNode? currentNode;
  bool _isTextVisible = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isTextVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.museum.category),
      ),
      body: Stack(
        children: [
          ARKitSceneView(
            enableTapRecognizer: true,
            onARKitViewCreated: (ARKitController controller) {
              this.controller = controller;
              controller.onARTap = (hits) {
                final point = hits.firstWhereOrNull(
                  (hit) => hit.type == ARKitHitTestResultType.featurePoint,
                );
                if (point != null) {
                  try {
                    log('Hit detected at: ${point.worldTransform.getColumn(3)}');
                    _onARTapHandler(point);
                  } catch (e) {
                    log('Error during AR tap handling: $e');
                  }
                } else {
                  log('No valid feature point detected.');
                }
              };
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: AnimatedOpacity(
              opacity: _isTextVisible ? 1.0 : 0.0,
              duration: const Duration(seconds: 1),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.black.withOpacity(0.7),
                child: const Text(
                  'Attendere qualche secondo e toccare su un piano per iniziare',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onARTapHandler(ARKitTestResult point) async {
    final position = vector.Vector3(
      point.worldTransform.getColumn(3).x,
      point.worldTransform.getColumn(3).y,
      point.worldTransform.getColumn(3).z,
    );

    if (currentNode != null) {
      currentNode!.position = position;
    } else {
      try {
        final node = ARKitGltfNode(
          assetType: AssetType.flutterAsset,
          url: "assets/models/felis.glb",
          scale: vector.Vector3.all(0.5),
          position: position,
        );
        await controller.add(node);
        currentNode = node;
      } catch (e) {
        log('Error loading model: $e');
      }
    }
  }

  /*ARKitGltfNode _getNodeFromFlutterAsset(vector.Vector3 position) {
    return ARKitGltfNode(
      assetType: AssetType.flutterAsset,
      url: "assets/models/felis.glb",
      scale: vector.Vector3.all(0.5),
      position: position,
    );
  }*/

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
