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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: ARKitSceneView(
        showFeaturePoints: true,
        enableTapRecognizer: true,
        planeDetection: ARPlaneDetection.horizontalAndVertical,
        onARKitViewCreated: (ARKitController controller) {
          this.controller = controller;

          controller.onARTap = (hits) {
            final point = hits.firstWhereOrNull(
              (hit) => hit.type == ARKitHitTestResultType.featurePoint,
            );
            if (point != null) {
              _onARTapHandler(point);
            }
          };
        },
      ),
    );
  }

  void _onARTapHandler(ARKitTestResult point) {
    final position = vector.Vector3(
      point.worldTransform.getColumn(3).x,
      point.worldTransform.getColumn(3).y,
      point.worldTransform.getColumn(3).z,
    );
    final node = _getNodeFromFlutterAsset(position);
    controller.add(node);
  }

  ARKitGltfNode _getNodeFromFlutterAsset(vector.Vector3 position) {
    return ARKitGltfNode(
      assetType: AssetType.flutterAsset,
      url: "assets/models/felis.glb",
      scale: vector.Vector3.all(0.05),
      position: position,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
