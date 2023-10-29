import 'door.dart';
import 'position.dart';

class GameMap {
  final Iterable<Door> doors;
  final int width;
  final int height;

  const GameMap({
    required this.doors,
    required this.width,
    required this.height,
  });

  Iterable<Position> getAdjacent(Position position) sync* {
    final (x, y) = (position.x, position.y);

    if (doors.contains(NorthSouthDoor(x: x, northY: y - 1))) {
      yield Position(x: x, y: y - 1);
    }
    if (doors.contains(NorthSouthDoor(x: x, northY: y))) {
      yield Position(x: x, y: y + 1);
    }
    if (doors.contains(WestEastDoor(westX: x - 1, y: y))) {
      yield Position(x: x - 1, y: y);
    }
    if (doors.contains(WestEastDoor(westX: x, y: y))) {
      yield Position(x: x + 1, y: y);
    }
  }

  static final common = GameMap(
    doors: {
      const NorthSouthDoor(x: 0, northY: 0),
      const NorthSouthDoor(x: 0, northY: 1),
      const WestEastDoor(westX: 0, y: 0),
      const WestEastDoor(westX: 0, y: 2),
      const WestEastDoor(westX: 0, y: 3),
      const NorthSouthDoor(x: 1, northY: 0),
      const WestEastDoor(westX: 1, y: 0),
      const WestEastDoor(westX: 1, y: 1),
      const WestEastDoor(westX: 1, y: 2),
      const NorthSouthDoor(x: 1, northY: 3),
      const NorthSouthDoor(x: 1, northY: 4),
      const NorthSouthDoor(x: 1, northY: 5),
      const NorthSouthDoor(x: 1, northY: 6),
      const NorthSouthDoor(x: 0, northY: 2),
      const NorthSouthDoor(x: 0, northY: 3),
      const NorthSouthDoor(x: 0, northY: 4),
      const NorthSouthDoor(x: 0, northY: 5),
      const WestEastDoor(westX: 0, y: 6),
      const WestEastDoor(westX: 0, y: 7),
      const WestEastDoor(westX: 1, y: 4),
      const WestEastDoor(westX: 2, y: 4),
      const WestEastDoor(westX: 3, y: 4),
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
      const WestEastDoor(westX: 8, y: 6),
      const WestEastDoor(westX: 7, y: 6),
      const WestEastDoor(westX: 8, y: 7),
      const NorthSouthDoor(x: 9, northY: 6),
      const NorthSouthDoor(x: 8, northY: 6),
      const NorthSouthDoor(x: 9, northY: 4),
      const NorthSouthDoor(x: 9, northY: 3),
      const NorthSouthDoor(x: 8, northY: 5),
      const WestEastDoor(westX: 7, y: 4),
      const WestEastDoor(westX: 8, y: 4),
      const WestEastDoor(westX: 8, y: 5),
      const NorthSouthDoor(x: 9, northY: 0),
      const NorthSouthDoor(x: 9, northY: 1),
      const NorthSouthDoor(x: 9, northY: 2),
      const WestEastDoor(westX: 7, y: 2),
      const WestEastDoor(westX: 7, y: 3),
      const NorthSouthDoor(x: 8, northY: 2),
      const NorthSouthDoor(x: 8, northY: 1),
      const NorthSouthDoor(x: 8, northY: 0),
      const WestEastDoor(westX: 8, y: 0),
      const WestEastDoor(westX: 8, y: 2),
      const WestEastDoor(westX: 7, y: 7),
      const WestEastDoor(westX: 0, y: 8),
      const WestEastDoor(westX: 1, y: 8),
      const WestEastDoor(westX: 2, y: 8),
      const WestEastDoor(westX: 3, y: 8),
      const WestEastDoor(westX: 4, y: 8),
      const WestEastDoor(westX: 5, y: 8),
      const WestEastDoor(westX: 6, y: 8),
      const WestEastDoor(westX: 8, y: 8),
      const WestEastDoor(westX: 0, y: 9),
      const WestEastDoor(westX: 1, y: 9),
      const WestEastDoor(westX: 3, y: 9),
      const WestEastDoor(westX: 4, y: 9),
      const WestEastDoor(westX: 5, y: 9),
      const WestEastDoor(westX: 6, y: 9),
      const WestEastDoor(westX: 7, y: 9),
      const WestEastDoor(westX: 8, y: 9),
      const NorthSouthDoor(x: 0, northY: 8),
      const NorthSouthDoor(x: 1, northY: 8),
      const NorthSouthDoor(x: 2, northY: 8),
      const NorthSouthDoor(x: 3, northY: 8),
      const NorthSouthDoor(x: 4, northY: 8),
      const NorthSouthDoor(x: 7, northY: 8),
      const NorthSouthDoor(x: 8, northY: 8),
      const NorthSouthDoor(x: 9, northY: 8),
      const NorthSouthDoor(x: 0, northY: 7),
      const NorthSouthDoor(x: 1, northY: 7),
      const NorthSouthDoor(x: 2, northY: 7),
      const NorthSouthDoor(x: 3, northY: 7),
      const NorthSouthDoor(x: 6, northY: 7),
      const NorthSouthDoor(x: 7, northY: 7),
      const NorthSouthDoor(x: 8, northY: 7),
      const NorthSouthDoor(x: 9, northY: 7),
      const NorthSouthDoor(x: 2, northY: 6),
      const WestEastDoor(westX: 8, y: 1),
      const WestEastDoor(westX: 7, y: 0),
      const WestEastDoor(westX: 7, y: 1),
    },
    width: 10,
    height: 10,
  );
}