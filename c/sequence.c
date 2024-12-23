#include <stdio.h>
#include <stdlib.h>

long long seq(long long n) {
  if (n == 0){
    return -2;
  }
  long long num;
  num = 1;

  long long cnt;
  cnt = 1;
  while (cnt <= n) {
    num = 3 * num;
    cnt++;
  }
  return num - 3;
}


int main(int argc, char const *argv[]){
    if (argc != 2) {
        return EXIT_SUCCESS;
    }
    long long n;
    if (sscanf(argv[1], "%lld", &n) != 1) {
        return EXIT_SUCCESS;
    }

    long long sequence= seq(n);
    printf("%lld\n", sequence);

    return EXIT_SUCCESS;
}