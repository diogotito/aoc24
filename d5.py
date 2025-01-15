from collections import defaultdict

with open("input/05") as input:
    rules = defaultdict(set)
    for line in iter(input.readline, "\n"):
        lpage, rpage = map(int, line.split("|"))
        rules[lpage].add(rpage)

    updates = [[*map(int, line.split(','))] for line in input.readlines()]

def upd_is_correct(update):
    return all(rpage in rules[lpage]
               for l_idx, lpage in enumerate(update)
               for rpage in update[l_idx+1:])

print(sum(upd[len(upd) // 2] for upd in updates if upd_is_correct(upd)))
