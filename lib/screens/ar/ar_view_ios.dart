import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'ar_view.dart';
import 'package:collection/collection.dart';

class ARViewIOS extends ARViewBase {
  const ARViewIOS({super.key, required super.dinosaur});

  @override
  ARViewIOSState createState() => ARViewIOSState();
}

class ARViewIOSState extends State<ARViewIOS> {
  late ARKitController controller;
  ARKitNode? currentNode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dinosaur.name),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: ARKitSceneView(
        enableTapRecognizer: true,
        showFeaturePoints: false,
        planeDetection: ARPlaneDetection.none,
        onARKitViewCreated: (ARKitController controller) {
          this.controller = controller;

          controller.onARTap = (hits) {
            final point = hits.firstWhereOrNull(
              (hit) => hit.type == ARKitHitTestResultType.featurePoint,
            );
            if (point != null) {
              try {
                _onARTapHandler(point);
              } catch (e) {
                log('$e');
              }
            }
          };
        },
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
      final node = _getNodeFromFlutterAsset(position);
      await controller.add(node);
      currentNode = node;
    }
  }

  ARKitGltfNode _getNodeFromFlutterAsset(vector.Vector3 position) {
    return ARKitGltfNode(
      assetType: AssetType.flutterAsset,
      url: "assets/models/felis.glb",
      scale: vector.Vector3.all(0.5),
      position: position,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
