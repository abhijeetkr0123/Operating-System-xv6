#include "types.h"
#include "user.h"

int main(int argc, char *argv[]) {
    int pid;
    int status = -1, retime = 0, rutime = 0, stime = 0;
    pid = fork();
    if (pid == 0) {
        exec(argv[1], argv);
        printf(1, "exec %s failed\n", argv[1]);
    } else {
        status = wait2(&retime, &rutime, &stime);
        printf(1, " retime = %d\n rutime = %d\n stime = %d\n pid = %d\n", retime, rutime, stime, status);
    }
    exit();
}