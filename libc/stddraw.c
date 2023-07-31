#include"stddraw.h"

void* memcpySwap(void* dstptr, const void* srcptr, int size) {
	unsigned int* dst = (unsigned int*) dstptr;
	const unsigned int* src = (const unsigned int*) srcptr;
	for (int i = 0; i < size; i++)
		dst[i] = src[i];
	return dstptr;
}

void swap(short* lfb, short* backBuffer)
{
    memcpySwap(lfb, backBuffer, 1024 * 768 / 2);
}

void drawPixel(short* buffer, unsigned int x, unsigned int y, unsigned short color) {
    buffer[y * 1024 + x] = color;
}

void drawLine(short* buffer, unsigned int x0, unsigned int y0, unsigned int x1, unsigned int y1, unsigned short color)
{
    int dx = abs(x1 - x0);
    int dy = abs(y1 - y0);
    int sx = x0 < x1 ? 1 : -1;
    int sy = y0 < y1 ? 1 : -1;
    int err = dx - dy;

    while (1) {
        buffer[y0 * 1024 + x0] = color; // Set the pixel color

        if (x0 == x1 && y0 == y1) {
            break; // Reached the end point
        }

        int e2 = 2 * err;
        if (e2 > -dy) {
            err -= dy;
            x0 += sx;
        }
        if (e2 < dx) {
            err += dx;
            y0 += sy;
        }
    }
}