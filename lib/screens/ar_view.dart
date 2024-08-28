import 'package:ar_flutter_plugin_flutterflow/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_flutterflow/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:ulisse500/classes/dinosaur.dart';
import 'package:vector_math/vector_math_64.dart';

class ARViewPage extends StatefulWidget {
  final Dinosaur dinosaur;
  const ARViewPage({super.key, required this.dinosaur});

  @override
  ARViewPageState createState() => ARViewPageState();
}

class ARViewPageState extends State<ARViewPage> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  ARNode? dinosaurNode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dinosaur.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: onAddLocalObjectButtonPressed,
                child: const Text("Add Model"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onARViewCreated(
      ARSessionManager sessionManager,
      ARObjectManager objectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      showWorldOrigin: true,
      handleTaps: true,
    );
    arObjectManager.onInitialize();
  }

  Future<void> onAddLocalObjectButtonPressed() async {
    if (dinosaurNode != null) {
      arObjectManager.removeNode(dinosaurNode!);
    }

    final newNode = ARNode(
      type: NodeType.fileSystemAppFolderGLB,
      uri: "asset/felis.glb",
      scale: Vector3(0.5, 0.5, 0.5),
    );

    bool? didAddNode = await arObjectManager.addNode(newNode);
    if (didAddNode!) {
      dinosaurNode = newNode;
    } else {
      print("Error adding model to the scene.");
    }
  }

  @override
  void dispose() {
    arSessionManager.dispose();
    super.dispose();
  }
}
