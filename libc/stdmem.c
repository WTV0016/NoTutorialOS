#include"stdmem.h"

void* memcpySwap(void* restrict dstptr, const void* restrict srcptr, int size) {
	unsigned int* dst = (unsigned int*) dstptr;
	const unsigned int* src = (const unsigned int*) srcptr;
	for (int i = 0; i < size; i++)
		dst[i] = src[i];
	return dstptr;
}

void memmove(void *dst, const void *src, int n)
{

}

void memset(void *dst, int c, int n)
{

}

void memclear(void *dst, int n)
{

}