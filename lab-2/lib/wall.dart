import 'package:flutter/material.dart';

class Wall extends StatelessWidget {
  final int flex;

  const Wall.westEast({super.key}) : flex = 1;
  const Wall.northSouth({super.key}) : flex = 10;

  @override
  build(context) {
    return Expanded(flex: flex, child: Ink(color: Colors.white));
  }
}
