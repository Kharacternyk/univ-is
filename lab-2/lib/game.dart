import 'door.dart';
import 'game_map.dart';
import 'ghost.dart';
import 'position.dart';

class Game {
  final GameMap map = GameMap(
    doors: {
      const NorthSouthDoor(x: 0, northY: 0),
      const NorthSouthDoor(x: 0, northY: 1),
      const WestEastDoor(westX: 0, y: 0),
      const WestEastDoor(westX: 0, y: 2),
      const NorthSouthDoor(x: 1, northY: 0),
      const WestEastDoor(westX: 1, y: 0),
      const WestEastDoor(westX: 1, y: 1),
      const WestEastDoor(westX: 1, y: 2),
      const NorthSouthDoor(x: 1, northY: 2),
      const NorthSouthDoor(x: 1, northY: 3),
      const NorthSouthDoor(x: 1, northY: 4),
      const NorthSouthDoor(x: 1, northY: 5),
      const NorthSouthDoor(x: 1, northY: 6),
      const NorthSouthDoor(x: 0, northY: 2),
      const NorthSouthDoor(x: 0, northY: 3),
      const NorthSouthDoor(x: 0, northY: 4),
      const NorthSouthDoor(x: 0, northY: 5),
      const NorthSouthDoor(x: 0, northY: 6),
      const WestEastDoor(westX: 0, y: 6),
      const WestEastDoor(westX: 0, y: 7),
      const WestEastDoor(westX: 1, y: 4),
      const WestEastDoor(westX: 2, y: 4),
      const WestEastDoor(westX: 3, y: 4),
      const WestEastDoor(westX: 1, y: 7),
      const WestEastDoor(westX: 2, y: 7),
      const WestEastDoor(westX: 3, y: 7),
      const NorthSouthDoor(x: 4, northY: 4),
      const NorthSouthDoor(x: 4, northY: 6),
      const NorthSouthDoor(x: 3, northY: 5),
      const NorthSouthDoor(x: 2, northY: 5),
      const WestEastDoor(westX: 3, y: 5),
      const WestEastDoor(westX: 2, y: 5),
      const WestEastDoor(westX: 3, y: 6),
      const WestEastDoor(westX: 2, y: 6),
      const NorthSouthDoor(x: 3, northY: 0),
      const NorthSouthDoor(x: 3, northY: 1),
      const NorthSouthDoor(x: 3, northY: 2),
      const NorthSouthDoor(x: 3, northY: 3),
      const WestEastDoor(westX: 2, y: 0),
      const WestEastDoor(westX: 2, y: 1),
      const WestEastDoor(westX: 2, y: 2),
      const WestEastDoor(westX: 2, y: 3),
      const NorthSouthDoor(x: 2, northY: 2),
      const WestEastDoor(westX: 3, y: 3),
      const WestEastDoor(westX: 5, y: 3),
      const WestEastDoor(westX: 6, y: 3),
      const WestEastDoor(westX: 3, y: 0),
      const WestEastDoor(westX: 4, y: 0),
      const WestEastDoor(westX: 5, y: 0),
      const WestEastDoor(westX: 6, y: 0),
      const NorthSouthDoor(x: 6, northY: 0),
      const NorthSouthDoor(x: 7, northY: 0),
      const WestEastDoor(westX: 4, y: 1),
      const WestEastDoor(westX: 5, y: 1),
      const WestEastDoor(westX: 6, y: 1),
      const NorthSouthDoor(x: 4, northY: 1),
      const NorthSouthDoor(x: 4, northY: 2),
      const NorthSouthDoor(x: 6, northY: 1),
      const NorthSouthDoor(x: 6, northY: 2),
      const NorthSouthDoor(x: 6, northY: 3),
      const NorthSouthDoor(x: 6, northY: 4),
      const WestEastDoor(westX: 4, y: 6),
      const WestEastDoor(westX: 5, y: 6),
      const WestEastDoor(westX: 6, y: 6),
      const WestEastDoor(westX: 5, y: 7),
      const WestEastDoor(westX: 6, y: 7),
      const NorthSouthDoor(x: 5, northY: 6),
      const NorthSouthDoor(x: 6, northY: 6),
      const NorthSouthDoor(x: 7, northY: 6),
      const NorthSouthDoor(x: 6, northY: 5),
      const NorthSouthDoor(x: 5, northY: 5),
      const NorthSouthDoor(x: 5, northY: 4),
      const NorthSouthDoor(x: 5, northY: 3),
      const NorthSouthDoor(x: 7, northY: 4),
      const WestEastDoor(westX: 6, y: 5),
      const WestEastDoor(westX: 6, y: 4),
      const NorthSouthDoor(x: 7, northY: 1),
      const NorthSouthDoor(x: 7, northY: 2),
      const WestEastDoor(westX: 4, y: 3),
      const WestEastDoor(westX: 5, y: 2),
      const NorthSouthDoor(x: 5, northY: 1),
      const NorthSouthDoor(x: 3, northY: 4),
    },
    width: 8,
    height: 8,
  );
  var pacman = const Position(x: 0, y: 0);
  final ghosts = <Ghost>[];
  late final stars = {
    for (var x = 0; x < map.width; ++x) ...[
      for (var y = 0; y < map.height; ++y)
        if (x > 0 || y > 0) Position(x: x, y: y),
    ]
  };

  bool move(Position position) {
    if (_getMoves(pacman).contains(position)) {
      pacman = position;
      stars.remove(position);
      _moveGhosts();

      return true;
    }

    return false;
  }

  bool get lost =>
      _getMoves(pacman).isEmpty ||
      ghosts.any((ghost) => ghost.position == pacman);

  int get score => map.width * map.height - stars.length - 1;

  void _moveGhosts() {
    for (final ghost in ghosts) {
      switch (ghost) {
        case RandomGhost _:
          final moves = _getMoves(ghost.position).toList();

          moves.shuffle();
          ghost.position = moves.firstOrNull ?? ghost.position;
      }
    }
  }

  Iterable<Position> _getMoves(Position position) sync* {
    for (final position in _getAdjacent(position)) {
      if (!ghosts.any((ghost) => ghost.position == position)) {
        yield position;
      }
    }
  }

  Iterable<Position> _getAdjacent(Position position) sync* {
    final (x, y) = (position.x, position.y);

    if (map.doors.contains(NorthSouthDoor(x: x, northY: y - 1))) {
      yield Position(x: x, y: y - 1);
    }
    if (map.doors.contains(NorthSouthDoor(x: x, northY: y))) {
      yield Position(x: x, y: y + 1);
    }
    if (map.doors.contains(WestEastDoor(westX: x - 1, y: y))) {
      yield Position(x: x - 1, y: y);
    }
    if (map.doors.contains(WestEastDoor(westX: x, y: y))) {
      yield Position(x: x + 1, y: y);
    }
  }
}
