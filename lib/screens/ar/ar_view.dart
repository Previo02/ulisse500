import 'package:flutter/material.dart';
import 'package:ulisse500/classes/dinosaur.dart';
import 'package:vector_math/vector_math_64.dart';

abstract class ARViewBase extends StatefulWidget {
  final Dinosaur dinosaur;

  const ARViewBase({super.key, required this.dinosaur});
}

abstract class ARViewBaseState<T extends ARViewBase> extends State<T> {
  void onARViewCreated();
  void onAddLocalObject(Vector3 position);
}
