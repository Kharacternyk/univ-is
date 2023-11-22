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

    var firstCrossPoint = _random.nextInt(length);
    var secondCrossPoint = _random.nextInt(length);

    final minCrossPoint = min(firstCrossPoint, secondCrossPoint);
    final maxCrossPoint = max(firstCrossPoint, secondCrossPoint);

    for (var i = 0; i < minCrossPoint; ++i) {
      _addFixtures(child, firstParentSlots, i);
    }
    for (var i = minCrossPoint; i < maxCrossPoint; ++i) {
      _addFixtures(child, secondParentSlots, i);
    }
    for (var i = maxCrossPoint; i < firstParentSlots.length; ++i) {
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
