import 'game_map.dart';
import 'ghost.dart';
import 'position.dart';

class Game {
  final map = GameMap.common;
  var _pacman = const Position(x: 0, y: 0);
  final _ghosts = <SpawnedGhost>[];
  late final _stars = {
    for (var x = 0; x < map.width; ++x) ...[
      for (var y = 0; y < map.height; ++y)
        if (x > 0 || y > 0) Position(x: x, y: y),
    ]
  };

  Position get pacman => _pacman;
  Iterable<SpawnedGhost> get ghosts => _ghosts;
  Iterable<Position> get stars => _stars;

  bool move(Position position) {
    if (getMoves(pacman).contains(position)) {
      _pacman = position;
      _stars.remove(position);
      _moveGhosts();

      return true;
    }

    return false;
  }

  bool get lost =>
      getMoves(pacman).isEmpty ||
      ghosts.any((ghost) => ghost.position == pacman);

  int get score => map.width * map.height - stars.length - 1;

  void spawn(Ghost ghost, Position position) {
    _ghosts.add(SpawnedGhost(ghost, position));
  }

  Iterable<Position> getMoves(Position position) sync* {
    for (final position in map.getAdjacent(position)) {
      if (!ghosts.any((ghost) => ghost.position == position)) {
        yield position;
      }
    }
  }

  void _moveGhosts() {
    for (final spawnedGhost in ghosts) {
      spawnedGhost._position = spawnedGhost.ghost.getMove(
        this,
        spawnedGhost._position,
      );
    }
  }
}

class SpawnedGhost {
  final Ghost ghost;
  Position _position;

  Position get position => _position;

  SpawnedGhost(this.ghost, this._position);
}
