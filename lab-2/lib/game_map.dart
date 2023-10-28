import 'door.dart';

class GameMap {
  final Set<Door> doors;
  final int width;
  final int height;

  const GameMap({
    required this.doors,
    required this.width,
    required this.height,
  });
}
