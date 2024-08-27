// import 'package:ar_flutter_plugin_flutterflow/ar_flutter_plugin.dart';
// import 'package:ar_flutter_plugin_flutterflow/datatypes/config_planedetection.dart';
// import 'package:ar_flutter_plugin_flutterflow/datatypes/node_types.dart';
// import 'package:ar_flutter_plugin_flutterflow/managers/ar_anchor_manager.dart';
// import 'package:ar_flutter_plugin_flutterflow/managers/ar_location_manager.dart';
// import 'package:ar_flutter_plugin_flutterflow/managers/ar_object_manager.dart';
// import 'package:ar_flutter_plugin_flutterflow/managers/ar_session_manager.dart';
// import 'package:ar_flutter_plugin_flutterflow/models/ar_anchor.dart';
// import 'package:ar_flutter_plugin_flutterflow/models/ar_node.dart';
// import 'package:ar_flutter_plugin_flutterflow/widgets/ar_view.dart';
// import 'package:flutter/material.dart';
// import 'package:ulisse500/classes/dinosaur.dart';
// import 'package:vector_math/vector_math_64.dart';

// class ARViewPage extends StatefulWidget {
//   final Dinosaur dinosaur;
//   const ARViewPage({super.key, required this.dinosaur});

//   @override
//   State<ARViewPage> createState() => _ARViewPageState();
// }

// class _ARViewPageState extends State<ARViewPage> {
//   ARSessionManager? arSessionManager;
//   ARObjectManager? arObjectManager;

//   @override
//   void dispose() {
//     arSessionManager?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.dinosaur.name),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       body: ARView(
//         onARViewCreated: _onARViewCreated,
//         planeDetectionConfig: PlaneDetectionConfig.horizontal,
//       ),
//     );
//   }

//   void _onARViewCreated(
//     ARSessionManager arSessionManager,
//     ARObjectManager arObjectManager,
//     ARAnchorManager arAnchorManager,
//     ARLocationManager arLocationManager,
//   ) {
//     this.arSessionManager = arSessionManager;
//     this.arObjectManager = arObjectManager;

//     this.arSessionManager?.onInitialize(
//           showFeaturePoints: false,
//           showPlanes: true,
//           showWorldOrigin: true,
//         );
//     this.arObjectManager!.onInitialize();

//     this.arSessionManager!.onPlaneDetected = ;
//   }

//   bool onPlaneDetected(ARPlaneAnchor anchor) {
//     const modelUri = "assets/models/felis.glb";

//     final model = ARNode(
//       type: NodeType.fileSystemAppFolderGLB,
//       uri: modelUri,
//       scale: Vector3(0.5, 0.5, 0.5),
//       position: _extractPosition(anchor.transformation),
//       rotation: _extractRotation(anchor.transformation),
//     );

//     arObjectManager?.addNode(model).then((didAddNode) {
//       if (didAddNode == true) {
//         print("3D model successfully added to the detected plane.");
//       } else {
//         print("Error adding 3D model.");
//       }
//     }).catchError((e) {
//       print("Exception while adding node: $e");
//     });
//     return true;
//   }

//   Vector3 _extractPosition(Matrix4 transform) {
//     return Vector3(transform[12], transform[13], transform[14]);
//   }

//   Vector4 _extractRotation(Matrix4 transform) {
//     final quaternion = Quaternion.fromRotation(transform.getRotation());
//     return Vector4(quaternion.x, quaternion.y, quaternion.z, quaternion.w);
//   }
// }

import 'dart:math';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_anchor_manager.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin_flutterflow/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_flutterflow/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_flutterflow/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_node.dart';
import 'package:ulisse500/classes/dinosaur.dart';
import 'package:vector_math/vector_math_64.dart';

class ARViewPage extends StatefulWidget {
  final Dinosaur dinosaur;
  const ARViewPage({super.key, required this.dinosaur});
  @override
  ARViewPageState createState() => ARViewPageState();
}

class ARViewPageState extends State<ARViewPage> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARNode? localObjectNode;
  ARNode? webObjectNode;
  ARNode? fileSystemNode;

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Local & Web Objects'),
        ),
        body: Stack(children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: onFileSystemObjectAtOriginButtonPressed,
                        child: const Text(
                            "Add/Remove Filesystem\nObject at Origin"),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: onLocalObjectAtOriginButtonPressed,
                          child:
                              const Text("Add/Remove Local\nObject at Origin")),
                      ElevatedButton(
                          onPressed: onWebObjectAtOriginButtonPressed,
                          child:
                              const Text("Add/Remove Web\nObject at Origin")),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: onLocalObjectShuffleButtonPressed,
                        child: const Text("Shuffle Local\nobject at Origin"),
                      ),
                    ],
                  )
                ],
              ))
        ]));
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;

    this.arSessionManager!.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          customPlaneTexturePath: "Images/triangle.png",
          showWorldOrigin: true,
          handleTaps: false,
        );
    this.arObjectManager!.onInitialize();
  }

  Future<void> onLocalObjectAtOriginButtonPressed() async {
    if (localObjectNode != null) {
      arObjectManager!.removeNode(localObjectNode!);
      localObjectNode = null;
    } else {
      var newNode = ARNode(
          type: NodeType.fileSystemAppFolderGLB,
          uri: "asset/models/feli.glb",
          scale: Vector3(0.2, 0.2, 0.2),
          position: Vector3(0.0, 0.0, 0.0),
          rotation: Vector4(1.0, 0.0, 0.0, 0.0));
      bool? didAddLocalNode = await arObjectManager!.addNode(newNode);
      localObjectNode = (didAddLocalNode!) ? newNode : null;
    }
  }

  Future<void> onWebObjectAtOriginButtonPressed() async {
    if (webObjectNode != null) {
      arObjectManager!.removeNode(webObjectNode!);
      webObjectNode = null;
    } else {
      var newNode = ARNode(
          type: NodeType.webGLB,
          uri:
              "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb",
          scale: Vector3(0.2, 0.2, 0.2));
      bool? didAddWebNode = await arObjectManager!.addNode(newNode);
      webObjectNode = (didAddWebNode!) ? newNode : null;
    }
  }

  Future<void> onFileSystemObjectAtOriginButtonPressed() async {
    if (fileSystemNode != null) {
      arObjectManager!.removeNode(fileSystemNode!);
      fileSystemNode = null;
    } else {
      var newNode = ARNode(
          type: NodeType.fileSystemAppFolderGLB,
          uri: "asset/models/feli.glb",
          scale: Vector3(0.2, 0.2, 0.2));
      bool? didAddFileSystemNode = await arObjectManager!.addNode(newNode);
      fileSystemNode = (didAddFileSystemNode!) ? newNode : null;
    }
  }

  Future<void> onLocalObjectShuffleButtonPressed() async {
    if (localObjectNode != null) {
      var newScale = Random().nextDouble() / 3;
      var newTranslationAxis = Random().nextInt(3);
      var newTranslationAmount = Random().nextDouble() / 3;
      var newTranslation = Vector3(0, 0, 0);
      newTranslation[newTranslationAxis] = newTranslationAmount;
      var newRotationAxisIndex = Random().nextInt(3);
      var newRotationAmount = Random().nextDouble();
      var newRotationAxis = Vector3(0, 0, 0);
      newRotationAxis[newRotationAxisIndex] = 1.0;

      final newTransform = Matrix4.identity();

      newTransform.setTranslation(newTranslation);
      newTransform.rotate(newRotationAxis, newRotationAmount);
      newTransform.scale(newScale);

      localObjectNode!.transform = newTransform;
    }
  }
}
