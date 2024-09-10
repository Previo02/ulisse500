import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
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
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Attendere qualche secondo e toccare su un piano per iniziare',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  backgroundColor: Colors.black.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ),
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

  void onAddLocalObject(vector.Vector3 position) async {
    if (currentNode != null) {
      arCoreController.removeNode(nodeName: currentNode!.name);
    }

    final node = ArCoreReferenceNode(
      name: widget.dinosaur.name,
      objectUrl: "assets/models/felis.glb",
      position: position,
      scale: vector.Vector3(0.5, 0.5, 0.5),
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
