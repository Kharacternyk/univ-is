from pprint import pprint

teachers = {
    "greg": [12, ["math", "programming"]],
    "steve": [12, ["programming", "physics"]],
    "rhod": [8, ["physics", "math"]],
    "sean": [15, ["physics", "calculus", "programming"]],
    "tom": [4, ["linguistics"]],
    "neil": [9, ["physics"]],
    "rick": [10, ["calculus"]],
    "phil": [10, ["linguistics", "math", "calculus"]],
}

groups = {
    "mathematicians": {
        "math": 8,
        "calculus": 6,
        "physics": 4,
        "linguistics": 2,
    },
    "programmers": {
        "math": 2,
        "calculus": 2,
        "programming": 12,
        "physics": 2,
        "linguistics": 2,
    },
    "physicists": {
        "math": 1,
        "calculus": 5,
        "programming": 4,
        "physics": 10,
    },
    "data-scientists": {
        "math": 7,
        "calculus": 2,
        "programming": 7,
        "physics": 1,
        "linguistics": 3,
    },
}

schedule = {group: [None for _ in range(20)] for group in groups}


def get_teachers(subject, hour):
    return sorted(
        (
            teacher
            for teacher in teachers
            if teachers[teacher][0]
            and subject in teachers[teacher][1]
            and not any(
                hours[hour] and hours[hour][1] == teacher for hours in schedule.values()
            )
        ),
        key=teacher_sorting_key,
    )


def teacher_sorting_key(teacher):
    return len([subject for subject in teachers[teacher][1] if subject_demand[subject]])


subject_demand = {}
subject_supply = {}

for group in groups:
    for subject in groups[group]:
        if subject not in subject_demand:
            subject_demand[subject] = 0
        subject_demand[subject] += groups[group][subject]

for teacher in teachers:
    for subject in teachers[teacher][1]:
        if subject not in subject_supply:
            subject_supply[subject] = 0
        subject_supply[subject] += teachers[teacher][0]


def propagate_constraints(subject, teacher, delta):
    subject_demand[subject] -= delta

    for subject in teachers[teacher][1]:
        subject_supply[subject] -= delta


def forward_check():
    for subject in subject_demand:
        if subject_demand[subject] > subject_supply[subject]:
            return False
    return True


def solve():
    for group in groups:
        for hour in range(len(schedule[group])):
            if schedule[group][hour]:
                continue

            for subject in groups[group]:
                if not groups[group][subject]:
                    continue

                for teacher in get_teachers(subject, hour):
                    schedule[group][hour] = (subject, teacher)
                    groups[group][subject] -= 1
                    teachers[teacher][0] -= 1
                    propagate_constraints(subject, teacher, 1)

                    if forward_check():
                        pprint(schedule)

                        if solve():
                            return True

                    schedule[group][hour] = None
                    groups[group][subject] += 1
                    teachers[teacher][0] += 1
                    propagate_constraints(subject, teacher, -1)

    return not any(any(groups[group].values()) for group in groups)


if not solve():
    print(":(")
