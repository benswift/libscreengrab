#include "screengrab.h"

void sg_swizzleBitmap(void *data, int rowBytes, int height) {
    int top, bottom;
    void * buffer;
    void * topP;
    void * bottomP;
    void * base;

    top = 0;
    bottom = height - 1;
    base = data;
    buffer = malloc(rowBytes);

    while (top < bottom) {
        topP = (void *)((top * rowBytes) + (intptr_t)base);
        bottomP = (void *)((bottom * rowBytes) + (intptr_t)base);

        memcpy( topP, buffer, rowBytes );
        memcpy( bottomP, topP, rowBytes );
        memcpy( buffer, bottomP, rowBytes );

        ++top;
        --bottom;
    }   
    free(buffer);
}   

CGFloat sg_screenWidth() {
  CGImageRef image = CGDisplayCreateImage(kCGDirectMainDisplay);
  if(image){
    CGFloat width = CGImageGetWidth(image);
    CGImageRelease(image);
    return width;  
  }else{
    CGImageRelease(image);
    printf("Error, display is NULL.\n");
    return 0.0;
  }
}

CGFloat sg_screenHeight() {
  CGImageRef image = CGDisplayCreateImage(kCGDirectMainDisplay);
  if(image){
    CGFloat height = CGImageGetHeight(image);
    CGImageRelease(image);
    return height;  
  }else{
    CGImageRelease(image);
    printf("Error, display is NULL.\n");
    return 0.0;
  }
}

size_t sg_bitsPerPixel() {
  CGImageRef image = CGDisplayCreateImage(kCGDirectMainDisplay);
  if(image){
    size_t bpp = CGImageGetBitsPerPixel(image);
    CGImageRelease(image);
    return bpp;  
  }else{
    CGImageRelease(image);
    printf("Error, display is NULL.\n");
    return 0;
  }
}

int64_t sg_grabScreen(void* buf, int64_t buflen) {
  // Main screenshot capture call
  CGImageRef image = CGDisplayCreateImage(kCGDirectMainDisplay);
  CFDataRef rawData = CGDataProviderCopyData(CGImageGetDataProvider(image));
  CGImageRelease(image);
  int64_t length = CFDataGetLength(rawData);

  if(length > buflen){
    printf("Warning: data (%lld bytes) is too big for supplied buffer (%lld bytes)\n", length, buflen);
  }
  // copy the data into a buffer that we own
  CFDataGetBytes(rawData, CFRangeMake(0,CFDataGetLength(rawData)), buf);
  
  return length;
}
