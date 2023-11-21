import 'university.dart';

extension PrintSchedule on University {
  void printSchedule(Schedule schedule, int generation) {
    final slots = getSlots(schedule);
    final teacherPenalty = getTeacherPenalty(schedule);
    final coursePenalty = getCoursePenalty(schedule);
    final slotPenalty = getSlotPenalty(schedule);
    final penalty = teacherPenalty + coursePenalty + slotPenalty;

    print('');
    print('Schedule $schedule (generation $generation)');
    print(
      'Penalty: $teacherPenalty + $coursePenalty + $slotPenalty = $penalty',
    );

    for (var i = 0; i < slots.length; ++i) {
      print('Slot ${i + 1}');
      slots[i].forEach(print);
    }
  }
}
