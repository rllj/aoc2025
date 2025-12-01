import sys

cnt = 50

result = 0

for line in sys.stdin:
    if line[0] == 'L':
        cnt = (cnt - int(line[1:])) % 100
    else:
        cnt = (cnt + int(line[1:])) % 100

    if cnt == 0:
        result += 1

print(result)

