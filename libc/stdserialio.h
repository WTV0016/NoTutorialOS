#ifndef STDSERIALIO_H
#define STDSERIALIO_H

#define SERIAL_PORT 0x3F8

void serialPrintChar(char c);
void serialPrintString(char *s);
void serialPrintInt(int i, int base);

void reverseString(char* str);

#endif