/* Simple Screengrabs for OSX */

#include <Cocoa/Cocoa.h>
#include <CoreFoundation/CoreFoundation.h>
/* #include <AppKit/AppKit.h> */

void swizzleBitmap(void *data, int rowBytes, int height);   
CVImageBufferRef grabViaOpenGL();
