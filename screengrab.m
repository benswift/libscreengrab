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

// a utility function for printing all the details about the
// screengrab image
void sg_printScreenImageInfo(){
  CGImageRef image = CGDisplayCreateImage(kCGDirectMainDisplay);

  size_t width  = CGImageGetWidth(image);
  size_t height = CGImageGetHeight(image);
  size_t bpr = CGImageGetBytesPerRow(image);
  size_t bpp = CGImageGetBitsPerPixel(image);
  size_t bpc = CGImageGetBitsPerComponent(image);
  
  CGBitmapInfo info = CGImageGetBitmapInfo(image);

  printf("          CGImageGetHeight: %d\n"
         "           CGImageGetWidth: %d\n"
         "     GImageGetBitsPerPixel: %d\n"
         "CGImageGetBitsPerComponent: %d\n"
         "     CGImageGetBytesPerRow: %d\n"
         "      CGImageGetBitmapInfo: 0x%.8X\n"
         "    kCGBitmapAlphaInfoMask: %s\n"
         "  kCGBitmapFloatComponents: %s\n"
         "    kCGBitmapByteOrderMask: 0x%.8X\n"
         " kCGBitmapByteOrderDefault: %s\n"
         "kCGBitmapByteOrder16Little: %s\n"
         "kCGBitmapByteOrder32Little: %s\n"
         "   kCGBitmapByteOrder16Big: %s\n"
         "   kCGBitmapByteOrder32Big: %s\n",
         (int)width,
         (int)height,
         (int)bpp,
         (int)bpc,
         (int)bpr,
         (unsigned)info,
         (info & kCGBitmapAlphaInfoMask)     ? "YES" : "NO",
         (info & kCGBitmapFloatComponents)   ? "YES" : "NO",
         (info & kCGBitmapByteOrderMask),
         ((info & kCGBitmapByteOrderMask) == kCGBitmapByteOrderDefault)  ? "YES" : "NO",
         ((info & kCGBitmapByteOrderMask) == kCGBitmapByteOrder16Little) ? "YES" : "NO",
         ((info & kCGBitmapByteOrderMask) == kCGBitmapByteOrder32Little) ? "YES" : "NO",
         ((info & kCGBitmapByteOrderMask) == kCGBitmapByteOrder16Big)    ? "YES" : "NO",
         ((info & kCGBitmapByteOrderMask) == kCGBitmapByteOrder32Big)    ? "YES" : "NO");

  // CFRelease(info);
  CGImageRelease(image);
}
