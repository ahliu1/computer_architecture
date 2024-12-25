#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

typedef struct golfer {
    //char name[64];
    char name[64]; // why can't i set this to a size
    int stats;
    struct golfer * next;
} golfer_type;

bool compare(golfer_type * golfer_1, golfer_type * golfer_2) {
    if (golfer_2 == NULL) { // if golfer_2 is null, then golfer_1 has to be inserted
        return true; 
    } else if (golfer_1->stats < golfer_2->stats) {
        return true;
    } else if (golfer_1->stats == golfer_2->stats) {
        if (strcmp(golfer_1->name, golfer_2->name) < 0){
            return true; 
        }
        return false;
    } else {
        return false;
    }
}

void freeList(golfer_type *golfer){
    while (golfer != NULL) {
        golfer_type * temp = golfer;
        golfer = golfer -> next;
        free(temp);
    }
}

void printList(golfer_type* golfer){
    while (golfer != NULL){
        if (golfer -> stats > 0){
            printf("%s +%d\n", golfer->name, golfer->stats);
        }
        else {
            printf("%s %d\n", golfer->name, golfer->stats);
        }
        golfer = golfer->next;
    }
}
   
golfer_type * insertGolfer(golfer_type * head, golfer_type * golfer){
    if (compare(golfer, head)){
        golfer->next = head;
        head = golfer;
        return head;
    }
    golfer_type * before = head;
    while (1){
        golfer_type * next = before->next;
        if (compare(golfer, next)){
            golfer->next = next;
            before->next = golfer;
            return head;
        }
    before = next;
    }
}

int main(int argc, char *argv[]){
    if (argc != 2) {
        return EXIT_SUCCESS;
    }
    FILE *file = fopen(argv[1], "r");
    if (file == NULL) {
        return EXIT_FAILURE;
    }
    char line[64];
    int first;
    int points;
    golfer_type * head = NULL;
    //golfer_type* golfer = malloc(sizeof(golfer_type));
    //while(*(fgets(line, 64, file)) != "DONE"){
    fscanf(file, "%d", &first);
    while(1){
        fscanf(file, "%s", line);
        if (strcmp(line, "DONE") == 0) break;
        else {
            golfer_type* golfer = (golfer_type*)malloc(sizeof(golfer_type));
            golfer->next = NULL; // 9/19- DELETE IF WRONG
            // implement loop logic - if remainder is 0 it's a stirng, 
            // if reminder is 1 it's an int
            strcpy(golfer->name, line);
            fscanf(file, "%d", &points);
            golfer->stats = points - first;
            //fscanf(file, "%d", &golfer->stats); 
            head = insertGolfer(head, golfer);
            golfer = golfer->next;
        }
    }

    // loop thru each node, deallocate memory
    fclose(file);
    printList(head);
    freeList(head);
    return EXIT_SUCCESS; 
}