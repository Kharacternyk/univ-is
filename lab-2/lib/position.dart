class Position {
  final int x;
  final int y;

  const Position({required this.x, required this.y});

  @override
  operator ==(other) => other is Position && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}
