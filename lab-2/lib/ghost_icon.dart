import 'package:flutter/material.dart';

import 'core/ghost.dart';

class GhostIcon extends StatelessWidget {
  final Ghost ghost;

  const GhostIcon(this.ghost, {super.key});

  @override
  build(context) {
    return IconTheme(
      data: const IconThemeData(size: 48),
      child: switch (ghost) {
        RandomGhost _ => const Icon(
            Icons.pest_control_rodent,
            color: Colors.blueGrey,
          ),
        DefenseGhost _ => const Icon(
            Icons.savings,
            color: Colors.pink,
          ),
        AStarGhost _ => const Icon(
            Icons.smart_toy,
            color: Colors.blue,
          ),
        VisionGhost _ => const Icon(
            Icons.emoji_nature,
            color: Colors.orange,
          ),
        BarrierGhost _ => const Icon(
            Icons.forest,
            color: Colors.green,
          ),
      },
    );
  }
}
