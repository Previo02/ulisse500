import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'ar_view.dart';

class ARViewIOS extends ARViewBase {
  const ARViewIOS({super.key, required super.museum});

  @override
  ARViewIOSState createState() => ARViewIOSState();
}

class ARViewIOSState extends State<ARViewIOS> {
  late ARKitController controller;
  ARKitGltfNode? currentNode;
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          ARKitSceneView(
            enableTapRecognizer: true,
            showFeaturePoints: true,
            planeDetection: ARPlaneDetection.horizontalAndVertical,
            onARKitViewCreated: onARKitViewCreated,
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

  void onARKitViewCreated(ARKitController arkitController) {
    controller = arkitController;
    controller.onARTap = (ar) {
      final point = ar.firstWhereOrNull(
        (o) => o.type == ARKitHitTestResultType.featurePoint,
      );
      if (point != null) {
        _loadModel(point);
      }
    };
  }

  void _loadModel(ARKitTestResult point) {
    final position = vector.Vector3(
      point.worldTransform.getColumn(3).x,
      point.worldTransform.getColumn(3).y,
      point.worldTransform.getColumn(3).z,
    );

    try {
      if (currentNode != null) {
        controller.remove(currentNode!.name);
      }
      final node = ARKitGltfNode(
        assetType: AssetType.flutterAsset,
        url: widget.museum.urlModel,
        scale: vector.Vector3(0.5, 0.5, 0.5),
        position: position,
      );
      controller.add(node);
      currentNode = node;
    } catch (e) {
      log("Failed to load model: $e");
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
