import 'dart:math';

import 'fixture.dart';
import 'university.dart';

extension Crossover on University {
  static final _random = Random();

  void crossover(Schedule child, List<Schedule> parentPool) {
    deleteFixtures(child);

    final firstParentSlots = _getParentSlots(parentPool);
    final secondParentSlots = _getParentSlots(parentPool);
    final length = min(firstParentSlots.length, secondParentSlots.length);

    if (length == 0) {
      return;
    }

    final firstCrossPoint = _random.nextInt(length);
    final secondCrossPoint =
        firstCrossPoint + 1 + _random.nextInt(length - firstCrossPoint);

    for (var i = 0; i < firstCrossPoint; ++i) {
      _addFixtures(child, firstParentSlots, i);
    }
    for (var i = firstCrossPoint; i < secondCrossPoint; ++i) {
      _addFixtures(child, secondParentSlots, i);
    }
    for (var i = secondCrossPoint; i < firstParentSlots.length; ++i) {
      _addFixtures(child, firstParentSlots, i);
    }
  }

  void _addFixtures(
    Schedule schedule,
    List<Iterable<Fixture>> slots,
    int slot,
  ) {
    for (final fixture in slots[slot]) {
      addFixture(schedule, fixture, slot);
    }
  }

  List<List<Fixture>> _getParentSlots(List<Schedule> parentPool) {
    return getSlots(parentPool[_random.nextInt(parentPool.length)]);
  }
}
