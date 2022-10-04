#include "types.h"
#include "user.h"
#include "stat.h"

// Defining the maximum buffer size
#define MAX 2000

int main(void){
    // Allocating memory for buffer
    void *buffer = malloc(MAX);

    // getting the size 
    int x = draw(buffer, MAX);
    if(x<0){
        printf(1, "Small buffer size");
    }else{
        // If everything is fine print the ASCII image
        printf(1,"%d\n",MAX);
        printf(1, "%s\n", (char *)buffer);
    }
    exit();
}