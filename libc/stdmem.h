#ifndef STDMEM_H
#define STDMEM_H

void* memcpy(void* restrict dstptr, const void* restrict srcptr, int size);
void memmove(void *dst, const void *src, int n);
void memset(void *dst, int c, int n);
void memclear(void *dst, int n);

#endif