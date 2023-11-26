from pprint import pprint

teachers = {
    "greg": [7, ["math", "programming"]],
    "steve": [7, ["programming", "physics"]],
    "rhod": [7, ["physics", "math"]],
    "tom": [3, ["linguistics"]],
}

groups = {
    "mathematicians": {
        "math": 6,
        "physics": 1,
        "linguistics": 1,
    },
    "programmers": {
        "math": 2,
        "programming": 4,
        "physics": 1,
        "linguistics": 1,
    },
    "physicists": {
        "math": 2,
        "programming": 1,
        "physics": 4,
        "linguistics": 1,
    },
}

schedule = {group: [None for _ in range(10)] for group in groups}


def get_teachers(subject, hour):
    return [
        teacher
        for teacher in teachers
        if teachers[teacher][0]
        and subject in teachers[teacher][1]
        and not any(
            hours[hour] and hours[hour][1] == teacher for hours in schedule.values()
        )
    ]


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
                    subject_demand[subject] -= 1

                    for subject in teachers[teacher][1]:
                        subject_supply[subject] -= 1

                    if forward_check():
                        pprint(schedule)

                        if solve():
                            return True

                    schedule[group][hour] = None
                    groups[group][subject] += 1
                    teachers[teacher][0] += 1
                    subject_demand[subject] += 1

                    for subject in teachers[teacher][1]:
                        subject_supply[subject] += 1

    return not any(any(groups[group].values()) for group in groups)


if not solve():
    print(":(")
