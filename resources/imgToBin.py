from PIL import Image, ImageOps
import glob, os
import numpy as np


def encode_image(image):
    encoded_image = []
    i = 0
    while (i <= len(image)-1):
        count = 1
        ch = image[i]
        j = i
        while (j < len(image)-1): 
            if (image[j] == image[j + 1]): 
                count = count + 1
                j = j + 1
            else: 
                break
        '''the count and the character is concatenated to the encoded string'''
        encoded_image.append(count)
        encoded_image.append(ch)
        i = j + 1
    return encoded_image

def decode(encoded_image):
    decoded_image = []
    i = 0
    j = 0
    # splitting the encoded message into respective counts
    while (i <= len(encoded_image) - 1):
        run_count = encoded_image[i]
        run_num = encoded_image[i + 1]
        # displaying the character multiple times specified by the count
        for j in range(run_count):
            # concatenated with the decoded message
            decoded_image.append(run_num)
            j = j + 1
        i = i + 2
    return decoded_image
final_bin = []
current_image = []
current_image_compressed = []

for infile in glob.glob("*.bmp"):
    with Image.open(infile) as im:
        im = ImageOps.grayscale(im)

        for i in range(0, im.size[0]):
            for j in range(0, im.size[1]):
                if(im.getpixel((i,j)) > 127):
                    current_image.append(2)
                else:
                    current_image.append(1)
        current_image_compressed = encode_image(current_image)
        current_image_compressed.append(0)

        final_bin.extend(current_image_compressed)



data_bytes = np.array(final_bin, dtype=np.uint8).tobytes()

file_path = 'resources.bin'
with open(file_path, 'wb') as binary_file:
    binary_file.write(data_bytes)

        
