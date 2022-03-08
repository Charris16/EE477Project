#include <stdio.h>
int main(int argc, char** argv) {
    int reg[32] = {0};
    
    for(int i = 0; i < 31; i++){
        reg[i] = i;
    }

    for(int i = 0; i < 32; i++) {
        reg[1] += reg[i];
    }

    printf("The sum is %d \n", reg[1]);
    

    return 0;
}