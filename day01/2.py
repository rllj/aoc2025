import sys

cnt = 50

result = 0

for line in sys.stdin:
    if line[0] == 'L':
        amount = int(line[1:])
        if cnt == amount:
            result += 1
        elif cnt - amount <= 0:
            result += (amount - cnt) // 100
        cnt = (cnt - amount) % 100
    else:
        result += (cnt + amount) // 100
        cnt = (cnt + amount) % 100

print(result)

