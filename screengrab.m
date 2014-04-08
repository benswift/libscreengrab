#include "screengrab.h"

void swizzleBitmap(void *data, int rowBytes, int height) {
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

CVImageBufferRef grabViaOpenGL() {
    int bytewidth;

    CGImageRef image = CGDisplayCreateImage(kCGDirectMainDisplay);    // Main screenshot capture call

    CGSize frameSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));    // Get screenshot bounds

    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithBool:NO], kCVPixelBufferCGImageCompatibilityKey,
                            [NSNumber numberWithBool:NO], kCVPixelBufferCGBitmapContextCompatibilityKey,
                            nil];

    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, frameSize.width,
                                          frameSize.height,  kCVPixelFormatType_32ARGB, (CFDictionaryRef) options,
                                          &pxbuffer);

    
    if(status!=kCVReturnSuccess){
      printf("Problem creating pixel buffer, error code: %d", status);
    }
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);

    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, frameSize.width,
                                                 frameSize.height, 8, 4*frameSize.width, rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipLast);

    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);

    bytewidth = frameSize.width * 4; // Assume 4 bytes/pixel for now
    bytewidth = (bytewidth + 3) & ~3; // Align to 4 bytes
    swizzleBitmap(pxdata, bytewidth, frameSize.height);     // Solution for ARGB madness

    CGColorSpaceRelease(rgbColorSpace);
    CGImageRelease(image);
    CGContextRelease(context);

    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);

    return pxbuffer;
}
