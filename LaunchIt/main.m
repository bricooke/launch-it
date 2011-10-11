//
//  main.m
//  Launchables
//
//  Created by Brian Cooke on 12/14/10.
//  Copyright Made By Rocket, Inc. 2010. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "validatereceipt.h"

int main(int argc, char *argv[])
{
  @autoreleasepool {
  
	// put the example receipt on the desktop (or change that path)
#ifdef LI_APPSTORE
#ifndef DEBUG
	if (!validateReceiptAtPath([NSString stringWithFormat:@"%@/../_MASReceipt/receipt", [[NSBundle mainBundle] resourcePath]]))
		exit(173);
#endif
#endif
  
    int ret = NSApplicationMain(argc,  (const char **) argv);
    return ret;
  }
}
