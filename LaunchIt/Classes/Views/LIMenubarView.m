//
//  LIMenubarView.m
//  LaunchIt
//
//  Created by Brian Cooke on 1/17/11.
//  Copyright 2011 roobasoft, LLC. All rights reserved.
//

#import "LIMenubarView.h"
#import "LIWindowController.h"


@implementation LIMenubarView

- (id)initWithFrame:(NSRect)frame controller:(LIWindowController *)ctrlr
{
  if ((self = [super initWithFrame:frame])) {
    self.controller = ctrlr;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSWindowDidResignKeyNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *arg1) {
      clicked = YES; // force it to go away.
      [self mouseDown:nil];
    }];
  }
  
  return self;
}


- (void)dealloc
{
  controller = nil;
  [super dealloc];
}


- (void)drawRect:(NSRect)rect {
  // Draw background if appropriate.
  if (clicked) {
    [[NSColor selectedMenuItemColor] set];
    NSRectFill(rect);
  }
  
  // Draw some text, just to show how it's done.
  rect = NSMakeRect(rect.origin.x+2, rect.origin.y+2, 18, 18);
  NSImage *image = nil;
  if (clicked)
    image = [NSImage imageNamed:@"menubar_white.png"];
  else
    image = [NSImage imageNamed:@"menubar_bw.png"];
  
  [image drawInRect:rect fromRect:NSMakeRect(0, 0, 18, 18) operation:NSCompositeSourceOver fraction:1.0];
}


- (void)mouseDown:(NSEvent *)event
{
  NSRect frame = [[self window] frame];
  NSPoint pt = NSMakePoint(NSMidX(frame), NSMinY(frame));
  clicked = !clicked;
  [controller toggleWindowAtPoint:pt makeVisible:clicked];
  [self setNeedsDisplay:YES];
}

@synthesize controller;

@end
