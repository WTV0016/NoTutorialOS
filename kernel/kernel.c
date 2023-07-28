#include"../libc/stdserialio.h"

char * VidMem;
char * BackBuffer[1024 * 768 * 2];
 
unsigned short ScrW, ScrH;
unsigned char Bpp, PixelStride;
int Pitch;
 
/*
 * Initializes video, creates a back buffer, changes video modes.
 * Remember that you need some kind of memory allocation!
 */
void InitVideo(unsigned short ScreenWidth, unsigned short ScreenHeight, unsigned char BitsPerPixel)
{
        /* The pitch is the amount of bytes between the start of each row. This isn't always bytes * width. */
        /* This should work for the basic 16 and 32 bpp modes (but not 24) */
        Pitch = ScreenWidth * 2;
 
	/* Warning: 0xEEEEEEE servces as an example, you should fill in the address of your video memory here. */
    unsigned int* lfb_address_ptr = (unsigned int*)0x400;
    unsigned int lfb_address = *lfb_address_ptr;

    VidMem = ((char *) lfb_address);
 
	ScrW = ScreenWidth;
	ScrH = ScreenHeight;
	Bpp = BitsPerPixel;
 
	/* Switch resolutions if needed... */
	/* Do some more stuff... */
}
 
/*
 * Draws a pixel onto the backbuffer.
 */
void SetPixel(unsigned short X, unsigned short Y, unsigned short Colour)
{	
        int offset = X * PixelStride + Y * Pitch;

        BackBuffer[offset] = Colour;
 
        /* Put a pixel onto the back buffer here. */
	/* Remember to write to the BACK buffer instead of the FRONT buffer (the front buffer represents your video memory). */
        /* Take care of writing exactly PixelStride bytes as well */
}
 
/*
 * Swaps the back and front buffer.
 * Most commonly done by simply copying the back buffer to the front buffer.
 */
void SwapBuffers()
{
	/* Copy the contents of the back buffer to the front buffer. */
	memcpy(VidMem, BackBuffer, ScrH * Pitch);
}
 
/*
 * An example of how to use these functions.
 */


unsigned short doubleBuffer[1024 * 768];

void kernel_main()
{
    // Create a pointer to access the address 0x400
    unsigned int* lfb_address_ptr = (unsigned int*)0x400;

    // Dereference the pointer to get the value stored at address 0x400
    unsigned int lfb_address = *lfb_address_ptr;

    unsigned short lfb_address_s = (unsigned short*)lfb_address_ptr;


    for(int x = 0; x < 1024; x++) {
        for(int y = 0; y < 768; y++) {
            SetPixel(x,y, 0xF800);
        }
    }

    SwapBuffers();


    // for(int i = 0; i < 1024 * 768; i++) {
    //     ((unsigned short*)lfb_address)[i] = doubleBuffer[i];
    // }

    // memcpy((unsigned short*)lfb_address, doubleBuffer, 1024 * 768);

    serialPrintChar('J');
    serialPrintString("Hello, World!");
    serialPrintInt(69, 10);
    serialPrintInt(105, 16);

    while (1)
    {
    }
    
}