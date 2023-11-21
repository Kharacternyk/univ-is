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
  final linguistics = university.createSubject();

  final josh = university.createTeacher(12);
  final greg = university.createTeacher(8);
  final rhod = university.createTeacher(6);
  final steve = university.createTeacher(10);

  university
    ..addCompetency(josh, math)
    ..addCompetency(josh, programming)
    ..addCompetency(josh, physics)
    ..addCompetency(greg, math)
    ..addCompetency(greg, physics)
    ..addCompetency(rhod, programming)
    ..addCompetency(rhod, physics)
    ..addCompetency(steve, linguistics)
    ..addCompetency(steve, math)
    ..addCompetency(steve, programming);

  final mathematicians = university.createCourse();
  final programmers = university.createCourse();
  final physicists = university.createCourse();

  university
    ..allocate(mathematicians, math, 7)
    ..allocate(mathematicians, physics, 2)
    ..allocate(mathematicians, programming, 3)
    ..allocate(programmers, math, 3)
    ..allocate(programmers, programming, 6)
    ..allocate(programmers, linguistics, 3)
    ..allocate(physicists, math, 2)
    ..allocate(physicists, physics, 8)
    ..allocate(physicists, programming, 2);

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

    for (final child in children) {
      university.crossover(child, mutants);
    }
    for (final mutant in mutants) {
      university.mutate(mutant);
    }
  }
}
