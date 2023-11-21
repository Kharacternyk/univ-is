import 'university.dart';

class Fixture {
  final Course course;
  final Teacher teacher;
  final Subject subject;

  Fixture(this.course, this.teacher, this.subject);

  @override
  toString() => 'Course $course, Teacher $teacher, Subject $subject';
}
