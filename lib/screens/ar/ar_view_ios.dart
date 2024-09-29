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
    print('ARViewIOS initialized');
  }

  @override
  Widget build(BuildContext context) {
    print('Building AR view');
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
    print('ARKitView created');
    controller = arkitController;
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      final node = ARKitGltfNode(
        assetType: AssetType.flutterAsset,
        url: 'assets/models/prova_felis.glb',
        scale: vector.Vector3(0.5, 0.5, 0.5),
        position: vector.Vector3(0, 0, -1.5),
      );

      await controller.add(node);
      currentNode = node;
      print('Model added successfully.');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
