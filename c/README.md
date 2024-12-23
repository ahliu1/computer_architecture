# Homework 3: Introduction to C

## Sequence
Write a non-recursive C program called sequence.c that prints out the Nth number of a sequence, where N is an integer that is input to the program on the command line. Each number in the sequence, S_N, is defined as S_N = 3^N – 3. The input value of N will be greater than or equal to zero. (Prohibited from using `math.h` and `pow` libraries)

## Recursion
Write a recursive C program called recurse.c that computes f(N), where N is an integer greater than zero that is input to the program on the command line. `f(N) = 2*(N+1) + 3*[f(N-1)] - 17`. The base case is f(0)=2.

## Golf
Write a C program called golf.c to rank golfers based on their relationship to par. The program will take a file as an input (eg., “./golf golferstats.txt”). The format of this file is as follows:

The file starts with an integer that is “par”. The rest is a series of per-golfer stats, where each entry is 2 lines long. The first line is the golfer’s last name, the second line is how many shots the golfer took. After the last golfer in the list, the last line of the file is the string “DONE”. For example:
70<br />
Woods<br />
68<br />
Wie<br />
65<br />
Scrub<br />
73<br />
DONE

The program outputs a number of lines equal to the number of players, and each line is the golfer’s name and their relationship to par, which is computed as: (shots taken by golfer) – (par).
If the result is positive, you must put a plus sign (+) before the metric. (Note that 0 is neither positive nor negative).

The lines should be sorted in ascending order based on this metric, and you must write your own sorting function. Golfers with equal metrics should be sorted alphabetically (e.g., based on the `strcmp` function). For example:
Wie -5<br />
Woods -2<br />
Scrub +3<br />

You may assume that golfer names will be fewer than 63 characters and that all numbers will fit into an int. Empty files and files of the wrong format will not be fed to your program. In all cases, your program should exit with status 0 (i.e., main should return 0).