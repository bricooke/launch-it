//
//  rooSmoothImageView.m
//  launchables
//
//  Created by Brian Cooke on 5/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "rooSmoothImageView.h"


@implementation rooSmoothImageView


- (void) drawRect:(NSRect)aRect
{
    // assume oldImage already has been created containing the full-size image
    NSImageRep *sourceImageRep = [[self image] bestRepresentationForRect:NSMakeRect(0, 0, 48, 48) context:nil hints:nil];
    NSImage *newImage = [[NSImage alloc] initWithSize:NSMakeSize(48,48)];
    // those numbers are the desired width and height of the scaled image in pixels
    
    [newImage lockFocus];
    {
        [[NSGraphicsContext currentContext] setImageInterpolation: NSImageInterpolationHigh];
        [sourceImageRep drawInRect:NSMakeRect(0, 0, 48, 48)];
        // those numbers should match the numbers above
    }
    [newImage unlockFocus];
    [self setImage:newImage];
    [super drawRect:aRect];
}



@end
