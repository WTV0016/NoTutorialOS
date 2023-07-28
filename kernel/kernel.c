#include"../libc/stdserialio.h"

unsigned int lfb_address;
unsigned short* lfb;

unsigned short backBuffer[1024 * 768];

void draw_pixel(unsigned int x, unsigned int y, unsigned short color) {

    lfb[y * 1024 + x] = color;
}

void swap()
{
    for(int x = 0; x < 1024; x++)
    {
        for(int y = 0; y < 768; y++)
        {
            lfb[y * 1024 + x] = backBuffer[y * 1024 + x];
        }
    }
}

void kernel_main()
{
    // Create a pointer to access the address 0x400
    unsigned int* lfb_address_ptr = (unsigned int*)0x400;

    // Dereference the pointer to get the value stored at address 0x400
    lfb_address = *lfb_address_ptr;
    lfb = (unsigned char*)lfb_address;

    for(int x = 0; x < 1024; x++) {
        for(int y = 0; y < 768; y++) {
            draw_pixel(x, y, 0xF800);
        }
    }

    swap();


    serialPrintChar('J');
    serialPrintString("Hello, World!");
    serialPrintInt(69, 10);
    serialPrintInt(105, 16);

    while (1)
    {
    }
    
}