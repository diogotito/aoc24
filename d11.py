from functools import lru_cache
from math import floor, log10

with open("in/11") as input:
    input_stones = [int(engraving) for engraving in input.readline().split()]


def blink(stone):
    if stone == 0:
        return (1,)
    if (ndigits := floor(log10(stone)) + 1) % 2 == 0:
        mag = 10 ** (ndigits // 2)
        return (stone // mag, stone % mag)
    return (stone * 2024,)


@lru_cache(maxsize=None)
def count_after(stone, blinks):
    return sum(count_after(s, blinks=blinks - 1) for s in blink(stone)) if blinks else 1


print("Part One:", sum(count_after(stone, blinks=25) for stone in input_stones))  # 187738
print("Part Two:", sum(count_after(stone, blinks=75) for stone in input_stones))  # 223767210249237
