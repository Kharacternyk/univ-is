class Position {
  final int x;
  final int y;

  const Position({required this.x, required this.y});

  int getManhattanDistance(Position other) {
    return (x - other.x).abs() + (y - other.y).abs();
  }

  @override
  operator ==(other) => other is Position && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  toString() => '($x, $y)';
}
