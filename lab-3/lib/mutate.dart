import 'dart:math';

import 'university.dart';

extension Mutate on University {
  static final _random = Random();

  void mutate(Schedule schedule) {
    deleteRandomFixtures(schedule, 1);
    moveRandomFixtures(schedule, 1);

    for (var slot = 0; slot < slotCount; ++slot) {
      if (_random.nextDouble() < 0.5) {
        final fixture =
            possibleFixtures[_random.nextInt(possibleFixtures.length)];

        addFixture(schedule, fixture, _random.nextInt(slotCount));
      }
    }
  }
}
