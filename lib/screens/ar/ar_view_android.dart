import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'ar_view.dart';

class ARViewAndroid extends ARViewBase {
  const ARViewAndroid({super.key, required super.museum});

  @override
  ARViewAndroidState createState() => ARViewAndroidState();
}

class ARViewAndroidState extends State<ARViewAndroid> {
  late ArCoreController arCoreController;
  ArCoreNode? currentNode;
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
          ArCoreView(
            onArCoreViewCreated: _onArCoreViewCreated,
            enableTapRecognizer: true,
            enablePlaneRenderer: true,
            type: ArCoreViewType.STANDARDVIEW,
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

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    onAddLocalObject(hit.pose.translation);
    //_addSphere(arCoreController);
  }

  void _addSphere(ArCoreController controller) {
    final material = ArCoreMaterial(color: const Color.fromARGB(120, 66, 134, 244));
    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.1,
    );
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(0, 0, -1.5),
    );
    controller.addArCoreNode(node);
  }

  void onAddLocalObject(vector.Vector3 position) async {
    if (currentNode != null) {
      arCoreController.removeNode(nodeName: currentNode!.name);
    }

    final node = ArCoreReferenceNode(
      name: widget.museum.name,
      //object3DFileName: "assets/models/felis.glb",
      objectUrl: "https://github.com/KhronosGroup/glTF-Sample-Models/blob/main/2.0/Box/glTF-Binary/Box.glb",
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
