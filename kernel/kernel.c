#include"../libc/stdserialio.h"
#include"../libc/stdmem.h"

unsigned int lfb_address;
unsigned short* lfb;

unsigned short* backBuffer;

void draw_pixel(unsigned int x, unsigned int y, unsigned short color) {

    backBuffer[y * 1024 + x] = color;
}

void swap()
{
    memcpySwap(lfb, backBuffer, 1024 * 768 / 2);
}

void kernel_main()
{
    serialPrintString("Entered kernel_main...");

    // Create a pointer to access the address 0x400
    unsigned int* lfb_address_ptr = (unsigned int*)0x400;

    // Dereference the pointer to get the value stored at address 0x400
    lfb_address = *lfb_address_ptr;
    lfb = (unsigned short*)lfb_address;

    backBuffer = (unsigned short*)(lfb + 1024 * 768);

    for(int x = 0; x < 1024; x++) {
        for(int y = 0; y < 768; y++) {
            backBuffer[y * 1024 + x] = 0;
        }
    }

    serialPrintString("backbuffer set finished...");

    swap();

    serialPrintString("swap finished...");

    serialPrintChar('J');
    serialPrintString("Hello, World!");
    serialPrintInt(69, 10);
    serialPrintInt(105, 16);

    unsigned short color = 133;

    unsigned short pos = 0;

    while (1)
    {
        pos++;

        for(int i = 0; i < 1024 * 768; i++)
        {
            backBuffer[i] = color;
            color++;
        }


        serialPrintString("Backbuffer set");

        swap();
        serialPrintString("Swapped");

    }
}