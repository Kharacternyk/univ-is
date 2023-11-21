import 'university.dart';

extension Penalty on University {
  int getPenalty(Schedule schedule) {
    return getTeacherPenalty(schedule) +
        getCoursePenalty(schedule) +
        getSlotPenalty(schedule);
  }
}
