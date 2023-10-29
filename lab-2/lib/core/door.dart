sealed class Door {}

class NorthSouthDoor implements Door {
  final int x;
  final int northY;

  const NorthSouthDoor({required this.x, required this.northY});

  @override
  operator ==(other) =>
      other is NorthSouthDoor && x == other.x && northY == other.northY;

  @override
  int get hashCode => Object.hash(x, northY);
}

class WestEastDoor implements Door {
  final int westX;
  final int y;

  const WestEastDoor({required this.westX, required this.y});

  @override
  operator ==(other) =>
      other is WestEastDoor && westX == other.westX && y == other.y;

  @override
  int get hashCode => Object.hash(westX, y);
}
