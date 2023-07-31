#ifndef STDDRAW_H
#define STDDRAW_H
#include"stdmem.h"
#include"stdmath.h"

void* memcpySwap(void* dstptr, const void* srcptr, int size);
void swap(short* lfb, short* backBuffer);

void drawPixel(short* buffer, unsigned int x, unsigned int y, unsigned short color);
void drawLine(short* buffer, unsigned int x1, unsigned int y1, unsigned int x2, unsigned int y2, unsigned short color);

#endif