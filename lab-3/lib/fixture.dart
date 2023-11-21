import 'university.dart';

class Fixture {
  final Course course;
  final Teacher teacher;
  final Subject subject;
  final bool lab;

  Fixture(this.course, this.teacher, this.subject, this.lab);

  @override
  toString() {
    final suffix = lab ? "Lab" : "Lecture";

    return 'Course $course, Teacher $teacher, Subject $subject ($suffix)';
  }
}
