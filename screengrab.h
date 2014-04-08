/* Simple Screengrabs for OSX */

#include <Cocoa/Cocoa.h>
#include <CoreFoundation/CoreFoundation.h>
#include <stdio.h>
/* #include <AppKit/AppKit.h> */

void sg_swizzleBitmap(void *data, int rowBytes, int height);   
CGFloat sg_screenWidth();
CGFloat sg_screenHeight();
size_t sg_bitsPerPixel();
int64_t sg_grabScreen(void* buf, int64_t buflen);
