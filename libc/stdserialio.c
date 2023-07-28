#include"stdserialio.h"
#include"stdlowlevel.h"

void serialPrintChar(char c)
{
    outb(SERIAL_PORT, c);
}

void serialPrintString(char *s)
{
    int index = 0;

    for(int i = 0; s[i] != 0 && s[i] != '\0'; i++) {
        serialPrintChar(s[i]);
    }
}

void serialPrintInt(int i, int base)
{
    char buffer[12];

    int index = 0;

    while(i != 0) {
        buffer[index] = (i % base) + '0';
        i /= base;
        index++;
    }

    if(base == 16)
    {
        buffer[index] = 'x';
        index++;
        buffer[index] = '0';
    }

    buffer[index + 1] = 0;

    reverseString(buffer);

    serialPrintString(buffer);
}

// Function to reverse a null-terminated string in place
void reverseString(char* str) {
    if (str == 0) return;

    int len = 0;
    while (str[len] != '\0') {
        len++;
    }

    int start = 0;
    int end = len - 1;

    while (start < end) {
        char temp = str[start];
        str[start] = str[end];
        str[end] = temp;
        start++;
        end--;
    }
}