#include"stdmem.h"

void memcpy(void* restrict dstptr, const void* restrict srcptr, int size) {
	unsigned char* dst = (unsigned char*) dstptr;
	const unsigned char* src = (const unsigned char*) srcptr;
	for (int i = 0; i < size; i++)
		dst[i] = src[i];
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