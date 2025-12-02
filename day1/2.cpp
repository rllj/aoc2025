#include <cstdint>
#include <iostream>

int main() {
  uint32_t result = 0;
  int32_t cnt = 50;

  char type;
  int32_t amount;
  while (std::cin >> type >> amount) {
    cnt += type == 'R' ? amount : -amount;
    int32_t full_turns = cnt / 100;
    if (type == 'L') {
      result += cnt == 0;
      if (cnt < 0) {
        result = result - full_turns + (cnt + amount != 0);
        int32_t rem = cnt - full_turns * 100;
        cnt = rem >= 0 ? rem : rem + 100;
      }
    } else {
      result += full_turns;
      cnt -= 100 * full_turns;
    }
  }

  std::cout << result << "\n";
}
