#include "types.h"

// #define UP_ARROW 226
// #define DOWN_ARROW 227
// #define LEFT_ARROW 228
// #define RIGHT_ARROW 229
#define UP_ARROW 72
#define DOWN_ARROW 80
#define LEFT_ARROW 75
#define RIGHT_ARROW 77
#define MAX_HISTORY 16

void earaseCurrentLineOnScreen(void);
void copyCharsToBeMovedToOldBuf(void);
void earaseContentOnInputBuf();
void copyBufferToScreen(char *bufToPrintOnScreen, uint length);
void copyBufferToInputBuf(char *bufToSaveInInput, uint length);
void saveCommandInHistory();
int history(char *buffer, int historyId);
