import 'dart:math';

import 'package:sqlite3/sqlite3.dart';

import 'fixture.dart';
import 'identity.dart';
import 'query.dart';

class University {
  late final _database = sqlite3.openInMemory()..execute(_schema);
  static const _schema = '''
    create table subjects(
      identity integer primary key,
      lab integer
    ) strict;

    create table teachers(
      identity integer primary key,
      hours integer not null
    ) strict;

    create table courses(
      identity integer primary key
    ) strict;

    create table schedules(
      identity integer primary key
    ) strict;

    create table competencies(
      subject integer not null references subjects,
      teacher integer not null references teachers,
      unique(subject, teacher)
    ) strict;

    create table allocations(
      course integer not null references courses,
      subject integer not null references subjects,
      hours integer not null,
      unique(course, subject)
    ) strict;

    create table fixtures(
      schedule integer not null references schedules on delete cascade,
      course integer not null references courses,
      teacher integer not null references teachers,
      subject integer not null references subjects,
      slot integer not null,
      lab integer,
      unique(schedule, course, slot),
      unique(schedule, teacher, lab, slot)
    ) strict;
  ''';

  final int slotCount;

  University(this.slotCount);

  late final _createSubject = Query(_database, '''
    insert into subjects(lab) values(?) returning identity
  ''');
  Subject createSubject({bool lecture = false}) {
    return Subject._(
      _createSubject.select([lecture ? null : 1]).first.first as int,
    );
  }

  late final _createTeacher = Query(_database, '''
    insert into teachers(hours) values(?) returning identity
  ''');
  Teacher createTeacher({required int hours}) {
    return Teacher._(_createTeacher.select([hours]).first.first as int);
  }

  late final _createCourse = Query(_database, '''
    insert into courses default values returning identity
  ''');
  Course createCourse() {
    return Course._(_createCourse.select().first.first as int);
  }

  late final _createSchedule = Query(_database, '''
    insert into schedules default values returning identity
  ''');
  Schedule createSchedule() {
    return Schedule._(_createSchedule.select().first.first as int);
  }

  late final _addCompetency = Query(_database, '''
    insert into competencies(teacher, subject) values(?, ?)
  ''');
  void addCompetency(Teacher teacher, Subject subject) {
    _addCompetency.select([teacher.value, subject.value]);
  }

  late final _allocate = Query(_database, '''
    insert into allocations(course, subject, hours) values(?, ?, ?)
  ''');
  void allocate(Course course, Subject subject, int hours) {
    _allocate.select([course.value, subject.value, hours]);
  }

  late final _addFixture = Query(_database, '''
    insert or ignore
    into fixtures(schedule, course, teacher, subject, slot, lab)
    values (?, ?, ?, ?, ?, ?)
  ''');
  void addFixture(
    Schedule schedule,
    Fixture fixture,
    int slot,
  ) {
    _addFixture.select([
      schedule.value,
      fixture.course.value,
      fixture.teacher.value,
      fixture.subject.value,
      slot,
      fixture.lab ? 1 : null,
    ]);
  }

  late final _possibleFixtures = Query(_database, '''
    select courses.identity, teachers.identity, competencies.subject, lab
    from courses
    join allocations
    on courses.identity = allocations.course
    join competencies
    on allocations.subject = competencies.subject
    join teachers
    on teachers.identity = competencies.teacher
    join subjects
    on competencies.subject = subjects.identity
  ''');
  late final possibleFixtures = _possibleFixtures.select().map((values) {
    final [course, teacher, subject, lab] = values;

    return Fixture(
      Course._(course as int),
      Teacher._(teacher as int),
      Subject._(subject as int),
      (lab as int?) != null,
    );
  }).toList();

  late final _getSlots = Query(_database, '''
    select course, teacher, subject, slot, lab
    from fixtures
    where schedule = ?
  ''');
  List<List<Fixture>> getSlots(Schedule schedule) {
    final result = <int, List<Fixture>>{};

    for (final [course, teacher, subject, slot, lab]
        in _getSlots.select([schedule.value])) {
      result[slot as int] ??= [];
      result[slot]!.add(Fixture(
        Course._(course as int),
        Teacher._(teacher as int),
        Subject._(subject as int),
        (lab as int?) != null,
      ));
    }

    return result.values.toList();
  }

  late final _getTeacherPenalty = Query(_database, '''
    select sum(
      abs(
        teachers.hours - (
          select count(distinct slot)
          from fixtures
          where fixtures.teacher = teachers.identity
          and fixtures.schedule = ?
        )
      )
    )
    from teachers
  ''');
  int getTeacherPenalty(Schedule schedule) {
    return _getTeacherPenalty.select([schedule.value]).first.first as int;
  }

  late final _getCoursePenalty = Query(_database, '''
    select sum(
      abs(
        allocations.hours - (
          select count()
          from fixtures
          where fixtures.subject = allocations.subject
          and fixtures.course = allocations.course
          and fixtures.schedule = ?
        )
      )
    )
    from allocations
  ''');
  int getCoursePenalty(Schedule schedule) {
    return _getCoursePenalty.select([schedule.value]).first.first as int;
  }

  late final _getSlotPenalty = Query(_database, '''
    select count(distinct slot)
    from fixtures
    where schedule = ?
  ''');
  int getSlotPenalty(Schedule schedule) {
    return max(
      0,
      (_getSlotPenalty.select([schedule.value]).first.first as int) - slotCount,
    );
  }

  late final _deleteFixtures = Query(_database, '''
    delete from fixtures
    where schedule = ?
  ''');
  void deleteFixtures(Schedule schedule) {
    _deleteFixtures.select([schedule.value]);
  }

  late final _deleteRandomFixtures = Query(_database, '''
    delete from fixtures
    where schedule = ?
    and abs(random()) % 100 <= ?
  ''');
  void deleteRandomFixtures(Schedule schedule, int percentage) {
    _deleteRandomFixtures.select([schedule.value, percentage]);
  }

  late final _moveRandomFixtures = Query(_database, '''
    update or replace fixtures
    set slot = slot - 1 + 2 * (abs(random()) % 2)
    where schedule = ?
    and abs(random()) % 100 <= ?
  ''');
  void moveRandomFixtures(Schedule schedule, int percentage) {
    _moveRandomFixtures.select([schedule.value, percentage]);
  }
}

class Subject extends Identity {
  Subject._(super.value);
}

class Teacher extends Identity {
  Teacher._(super.value);
}

class Course extends Identity {
  Course._(super.value);
}

class Schedule extends Identity {
  Schedule._(super.value);
}
