import 'package:collection/collection.dart';

import 'game.dart';
import 'position.dart';

sealed class Ghost {
  const Ghost();

  Position getMove(Game game, Position position) {
    return (game.getMoves(position).toList()..shuffle()).firstOrNull ??
        position;
  }
}

class RandomGhost extends Ghost {
  const RandomGhost();
}

class DefenseGhost extends Ghost {
  final _directions = ([
    [(0, 1), (1, 0), (0, -1), (-1, 0)],
    [(0, 1), (-1, 0), (0, -1), (1, 0)],
  ]..shuffle())
      .first;

  var _index = ([0, 1, 2, 3]..shuffle()).first;

  int get _nextIndex => (_index + 1) % (_directions.length);
  int get _previousIndex => (_index - 1) % (_directions.length);

  Position _add(Position position, int index) {
    final (x, y) = _directions[index];

    return Position(
      x: position.x + x,
      y: position.y + y,
    );
  }

  @override
  getMove(game, position) {
    final moves = game.getMoves(position);

    if (moves.contains(game.pacman)) {
      return game.pacman;
    }
    if (moves.contains(_add(position, _nextIndex))) {
      _index = _nextIndex;

      return _add(position, _index);
    }
    if (moves.contains(_add(position, _index))) {
      return _add(position, _index);
    }
    if (moves.contains(_add(position, _previousIndex))) {
      _index = _previousIndex;

      return _add(position, _index);
    }

    return super.getMove(game, position);
  }
}

class AStarGhost extends Ghost {
  const AStarGhost();

  @override
  getMove(game, position) {
    final set = <Position>{};
    final queue = PriorityQueue<List<Position>>((first, second) {
      return (first.length + _estimateLength(first.last, game.pacman))
          .compareTo(second.length + _estimateLength(second.last, game.pacman));
    });

    for (final move in game.getMoves(position)) {
      set.add(move);
      queue.add([move]);
    }

    while (queue.isNotEmpty) {
      final entry = queue.removeFirst();

      if (entry.last == game.pacman) {
        return entry.first;
      }

      for (final move in game.getMoves(entry.last)) {
        if (!set.contains(move)) {
          set.add(move);
          queue.add([...entry, move]);
        }
      }
    }

    return super.getMove(game, position);
  }

  int _estimateLength(Position from, Position to) {
    return (to.x - from.x).abs() + (to.y - from.y).abs();
  }
}

class VisionGhost extends Ghost {
  const VisionGhost();

  static const _directions = [(0, 1), (0, -1), (1, 0), (-1, 0)];

  @override
  getMove(game, position) {
    for (final direction in _directions) {
      final path = [position];

      for (;;) {
        final moves = game.getMoves(path.last);
        final move = moves.where((move) {
          return (move.x - path.last.x, move.y - path.last.y) == direction;
        }).firstOrNull;

        if (move == null) {
          break;
        } else {
          path.add(move);
        }

        if (path.last == game.pacman) {
          return path[1];
        }
      }
    }

    return super.getMove(game, position);
  }
}

class BarrierGhost extends Ghost {
  const BarrierGhost();

  @override
  getMove(game, position) => position;
}
