import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart';
import 'ar_view.dart';

class ARViewAndroid extends ARViewBase {
  const ARViewAndroid({super.key, required super.dinosaur});

  @override
  ARViewAndroidState createState() => ARViewAndroidState();
}

class ARViewAndroidState extends State<ARViewAndroid> {
  late ArCoreController arCoreController;
  ArCoreNode? currentNode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dinosaur.name),
      ),
      body: Stack(
        children: [
          ArCoreView(
            onArCoreViewCreated: _onArCoreViewCreated,
            enableTapRecognizer: true,
            type: ArCoreViewType.STANDARDVIEW,
          ),
        ],
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    onAddLocalObject(hit.pose.translation);
  }

  void onAddLocalObject(Vector3 position) async {
    if (currentNode != null) {
      arCoreController.removeNode(nodeName: currentNode!.name);
    }

    final node = ArCoreReferenceNode(
      name: widget.dinosaur.name,
      objectUrl: "assets/models/felis.glb",
      position: position,
      scale: Vector3(0.5, 0.5, 0.5),
    );

    await arCoreController.addArCoreNodeWithAnchor(node);
    currentNode = node;
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}