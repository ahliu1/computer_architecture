#include <stdio.h>
#include <stdlib.h>

int recurse(int n){
    if (n == 0){
        return 2;
    }
    return 2 * (n+1) + 3 * recurse(n-1) - 17;
}

int main(int argc, char const *argv[]){
    if (argc != 2) {
        return EXIT_SUCCESS;
    }
    int n;
    if (sscanf(argv[1], "%d", &n) != 1) {
        return EXIT_SUCCESS;
    }

    int recursion= recurse(n);
    printf("%d\n", recursion);

    return EXIT_SUCCESS;
}