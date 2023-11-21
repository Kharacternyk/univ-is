import 'dart:math';

import 'university.dart';

extension RandomSchedules on University {
  static final _random = Random();

  List<Schedule> randomSchedules(int count) {
    final schedules = [for (var i = 0; i < count; ++i) createSchedule()];

    for (final schedule in schedules) {
      for (var slot = 0; slot < slotCount; ++slot) {
        final fixture =
            possibleFixtures[_random.nextInt(possibleFixtures.length)];

        addFixture(schedule, fixture, slot);
      }
    }

    return schedules;
  }
}
