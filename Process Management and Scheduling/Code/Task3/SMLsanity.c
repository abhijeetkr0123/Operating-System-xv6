#include "types.h"
#include "user.h"

int main(int argc, char *argv[]){
  if (argc != 2){
    printf(1, "WRONG USAGE: Please use the following usage scheme\nSMLsanity [n]\n");
    exit();
  }
  int i, j = 0, k;
  int n = atoi(argv[1]);
  int retime;
  int rutime;
  int stime;
  int sums[3][3];
  for(i = 0; i < 3; i++){
    for(j = 0; j < 3; j++){
      sums[i][j] = 0;
    }
  }
  i = n; 
  int pid;
  for (i = 0; i < 3 * n; i++){
    j = i % 3;
    pid = fork();
    //child
    if (pid == 0){                         
      j = (getpid() - 4) % 3; 
      #ifdef SML
        switch (j){
        case 0:
          set_prio(1);
          break;
        case 1:
          set_prio(2);
          break;
        case 2:
          set_prio(3);
          break;
        }
      #endif
      for (k = 0; k < 100; k++){
        for (j = 0; j < 1000000; j++)
        {
          // For consuming some execution time
        }
      }
      exit();
    }
    continue;
  }
  for (i = 0; i < 3 * n; i++){
    pid = wait2(&retime, &rutime, &stime);
    int res = (pid - 4) % 3; 
    switch (res){
    case 0: // CPU bound processes
      printf(1, "Priority 1 ==> pid: %d, ready: %d, running: %d, sleeping: %d, turnaround: %d\n", pid, retime, rutime, stime, retime + rutime + stime);
      sums[0][0] += retime;
      sums[0][1] += rutime;
      sums[0][2] += stime;
      break;
    case 1: // short tasks CPU bound processes
      printf(1, "Priority 2 ==> pid: %d, ready: %d, running: %d, sleeping: %d, turnaround: %d\n", pid, retime, rutime, stime, retime + rutime + stime);
      sums[1][0] += retime;
      sums[1][1] += rutime;
      sums[1][2] += stime;
      break;
    case 2: // I/O bound processes
      printf(1, "Priority 3 ==> pid: %d, ready: %d, running: %d, sleeping: %d, turnaround: %d\n", pid, retime, rutime, stime, retime + rutime + stime);
      sums[2][0] += retime;
      sums[2][1] += rutime;
      sums[2][2] += stime;
      break;
    }
  }
  for(i = 0; i < 3; i++){
    for(j = 0; j < 3; j++){
      sums[i][j] = sums[i][j] / n;
    }
  }
  printf(1, "\nPriority 1 ==>\nAvg ready time: %d\nAvg running time: %d\nAvg sleeping time: %d\nAvg turnaround time: %d\n\n", sums[0][0], sums[0][1], sums[0][2], sums[0][0] + sums[0][1] + sums[0][2]);
  printf(1, "Priority 2 ==>\nAvg ready time: %d\nAvg running time: %d\nAvg sleeping time: %d\nAvg turnaround time: %d\n\n", sums[1][0], sums[1][1], sums[1][2], sums[1][0] + sums[1][1] + sums[1][2]);
  printf(1, "Priority 3 ==>\nAvg ready time: %d\nAvg running time: %d\nAvg sleeping time: %d\nAvg turnaround time: %d\n\n", sums[2][0], sums[2][1], sums[2][2], sums[2][0] + sums[2][1] + sums[2][2]);
  exit();
}