import 'position.dart';

sealed class Ghost {
  Position position;

  Ghost(this.position);
}

class RandomGhost extends Ghost {
  RandomGhost(super.position);
}
