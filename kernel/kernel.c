#include"../libc/stdserialio.h"
#include"../libc/stdmem.h"
#include"../libc/stddraw.h"

unsigned int lfb_address;
unsigned short* lfb;

unsigned short* backBuffer;

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

    drawLine(backBuffer, 0, 0, 1024, 768, 0x0000FF);
    drawLine(backBuffer, 1, 0, 1023, 768, 0x0000FF);

    swap(lfb, backBuffer);
}