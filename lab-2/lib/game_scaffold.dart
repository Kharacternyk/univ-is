import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/door.dart';
import 'core/game.dart';
import 'core/ghost.dart';
import 'core/position.dart';
import 'ghost_icon.dart';
import 'scaled_draggable.dart';
import 'wall.dart';

class GameScaffold extends StatefulWidget {
  const GameScaffold({super.key});

  @override
  createState() => _State();
}

class _State extends State<GameScaffold> {
  var game = Game();

  @override
  initState() {
    super.initState();
    RawKeyboard.instance.addListener(_move);
  }

  @override
  dispose() {
    RawKeyboard.instance.removeListener(_move);
    super.dispose();
  }

  @override
  build(context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            FloatingActionButton.extended(
              icon: const Icon(Icons.refresh),
              label: Text(game.score.toString()),
              onPressed: () {
                setState(() {
                  game = Game();
                });
              },
            ),
            const Spacer(),
            for (final ghost in [
              const BarrierGhost(),
              const AStarGhost(),
              GreedyGhost(),
              DefenseGhost(),
              const VisionGhost(),
              const RandomGhost(),
            ]) ...[
              const SizedBox(width: 8),
              ScaledDraggable(
                dragData: ghost,
                child: GhostIcon(ghost),
              ),
            ],
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                const Wall.westEast(),
                for (var x = 0; x < game.map.width; ++x) ...[
                  const Wall.northSouth(),
                  const Wall.westEast(),
                ]
              ],
            ),
          ),
          for (var y = 0; y < game.map.height; ++y) ...[
            Expanded(
              flex: 10,
              child: Row(
                children: [
                  const Wall.westEast(),
                  for (var x = 0; x < game.map.width; ++x) ...[
                    _getCell(Position(x: x, y: y)),
                    game.map.doors.contains(WestEastDoor(westX: x, y: y))
                        ? const Spacer()
                        : const Wall.westEast(),
                  ],
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  const Wall.westEast(),
                  for (var x = 0; x < game.map.width; ++x) ...[
                    game.map.doors.contains(NorthSouthDoor(x: x, northY: y))
                        ? const Spacer(flex: 10)
                        : const Wall.northSouth(),
                    _getJunction(Position(x: x, y: y)),
                  ]
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _getCell(Position position) {
    if (position == game.pacman) {
      return Expanded(
        flex: 10,
        child: FittedBox(
          child: Icon(
            game.lost ? Icons.sentiment_very_dissatisfied_outlined : Icons.face,
            color: Colors.yellow,
          ),
        ),
      );
    }

    final spawnedGhost =
        game.ghosts.where((ghost) => ghost.position == position).firstOrNull;

    if (spawnedGhost != null) {
      return Expanded(
        flex: 10,
        child: FittedBox(child: GhostIcon(spawnedGhost.ghost)),
      );
    }

    return Expanded(
      flex: 10,
      child: DragTarget<Ghost>(
        builder: (context, candidate, rejected) {
          return SizedBox.expand(
            child: Ink(
              color: candidate.isNotEmpty ? Colors.white38 : null,
              child: game.stars.contains(position)
                  ? const FittedBox(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                      ),
                    )
                  : null,
            ),
          );
        },
        onAccept: (ghost) {
          setState(() {
            game.spawn(ghost, position);
          });
        },
      ),
    );
  }

  Widget _getJunction(Position position) {
    final (x, y) = (position.x, position.y);
    final doors = {
      NorthSouthDoor(x: x, northY: y),
      NorthSouthDoor(x: x + 1, northY: y),
      WestEastDoor(westX: x, y: y),
      WestEastDoor(westX: x, y: y + 1),
    };

    doors.removeAll(game.map.doors);

    return doors.isEmpty ? const Spacer() : const Wall.westEast();
  }

  void _move(RawKeyEvent event) {
    if (event case RawKeyDownEvent event when !game.lost) {
      final (x, y) = (game.pacman.x, game.pacman.y);
      final position = switch (event.logicalKey) {
        LogicalKeyboardKey.keyW => Position(x: x, y: y - 1),
        LogicalKeyboardKey.keyD => Position(x: x + 1, y: y),
        LogicalKeyboardKey.keyS => Position(x: x, y: y + 1),
        LogicalKeyboardKey.keyA => Position(x: x - 1, y: y),
        LogicalKeyboardKey.keyX => game.pacman,
        _ => null,
      };

      if (position != null && game.move(position)) {
        setState(() {});
      }
    }
  }
}
