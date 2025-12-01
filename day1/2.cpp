#include <cstdint>
#include <iostream>

int main() {
  uint32_t result = 0;
  int32_t cnt = 50;

  char type;
  int32_t amount;
  while (std::cin >> type >> amount) {
    if (type == 'L') {
      cnt -= amount;
      if (cnt == 0) {
        result++;
      } else if (cnt < 0) {
        int32_t inc = cnt / 100;
        result = result - inc + (cnt + amount != 0);
        int32_t rem = cnt - inc * 100;
        cnt = rem >= 0 ? rem : rem + 100;
      }
    } else {
      cnt += amount;
      int32_t inc = cnt / 100;
      result += inc;
      cnt -= 100 * inc;
    }
  }

  std::cout << result << "\n";
}
