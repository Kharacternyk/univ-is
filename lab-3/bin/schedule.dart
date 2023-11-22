import 'package:schedule/crossover.dart';
import 'package:schedule/mutate.dart';
import 'package:schedule/penalty.dart';
import 'package:schedule/print_schedule.dart';
import 'package:schedule/random_schedules.dart';
import 'package:schedule/university.dart';

const slotCount = 15;
const populationSize = 1000;
const mutantCount = 100;

void main() {
  final university = University(slotCount);

  final math = university.createSubject();
  final programming = university.createSubject();
  final physics = university.createSubject();
  final mathLectures = university.createSubject(lecture: true);
  final programmingLectures = university.createSubject(lecture: true);

  final greg = university.createTeacher(hours: 6);
  final rhod = university.createTeacher(hours: 6);
  final steve = university.createTeacher(hours: 10);
  final josh = university.createTeacher(hours: 2);
  final tom = university.createTeacher(hours: 2);

  university
    ..addCompetency(greg, math)
    ..addCompetency(greg, physics)
    ..addCompetency(rhod, programming)
    ..addCompetency(rhod, physics)
    ..addCompetency(steve, math)
    ..addCompetency(steve, programming)
    ..addCompetency(josh, mathLectures)
    ..addCompetency(tom, programmingLectures);

  final mathematicians = university.createCourse();
  final programmers = university.createCourse();
  final physicists = university.createCourse();

  university
    ..allocate(mathematicians, mathLectures, 2)
    ..allocate(mathematicians, math, 5)
    ..allocate(mathematicians, physics, 2)
    ..allocate(mathematicians, programmingLectures, 1)
    ..allocate(programmers, mathLectures, 1)
    ..allocate(programmers, programmingLectures, 2)
    ..allocate(programmers, programming, 6)
    ..allocate(programmers, physics, 1)
    ..allocate(physicists, mathLectures, 1)
    ..allocate(physicists, physics, 8)
    ..allocate(physicists, programmingLectures, 1);

  final population = university.randomSchedules(populationSize);

  for (var generation = 1;; ++generation) {
    population.sort((first, second) {
      return university
          .getPenalty(second)
          .compareTo(university.getPenalty(first));
    });

    university.printSchedule(population.last, generation);

    if (university.getPenalty(population.last) == 0) {
      break;
    }

    final children = population.sublist(0, populationSize - mutantCount);
    final mutants = population.sublist(populationSize - mutantCount);

    for (final mutant in mutants) {
      university.mutate(mutant);
    }
    for (final child in children) {
      university.crossover(child, mutants);
    }
  }
}
