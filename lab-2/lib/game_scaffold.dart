import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'door.dart';
import 'game.dart';
import 'ghost.dart';
import 'position.dart';
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
            ScaledDraggable(
              dragData: RandomGhost(const Position(x: 0, y: 0)),
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                onPressed: () {},
                heroTag: null,
                child: const Icon(Icons.pest_control_rodent),
              ),
            ),
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
                    {
                              NorthSouthDoor(x: x, northY: y),
                              NorthSouthDoor(x: x + 1, northY: y),
                              WestEastDoor(westX: x, y: y),
                              WestEastDoor(westX: x, y: y + 1),
                            }.intersection(game.map.doors).length ==
                            4
                        ? const Spacer()
                        : const Wall.westEast(),
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

    final ghost =
        game.ghosts.where((ghost) => ghost.position == position).firstOrNull;

    if (ghost != null) {
      return const Expanded(
        flex: 10,
        child: FittedBox(
          child: Icon(
            Icons.pest_control_rodent,
            color: Colors.red,
          ),
        ),
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
          ghost.position = position;
          setState(() {
            game.ghosts.add(ghost);
          });
        },
      ),
    );
  }

  void _move(RawKeyEvent event) {
    if (event case RawKeyDownEvent event when !game.lost) {
      final (x, y) = (game.pacman.x, game.pacman.y);
      final position = switch (event.logicalKey) {
        LogicalKeyboardKey.keyW => Position(x: x, y: y - 1),
        LogicalKeyboardKey.keyD => Position(x: x + 1, y: y),
        LogicalKeyboardKey.keyS => Position(x: x, y: y + 1),
        LogicalKeyboardKey.keyA => Position(x: x - 1, y: y),
        _ => null,
      };

      if (position != null && game.move(position)) {
        setState(() {});
      }
    }
  }
}
