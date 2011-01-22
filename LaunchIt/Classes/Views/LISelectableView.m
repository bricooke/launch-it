//
//  LISelectableView.m
//  Launch it!
//
//  Created by Brian Cooke on 1/22/11.
//  Copyright 2011 Made By Rocket, Inc. All rights reserved.
//

#import "LISelectableView.h"


@implementation LISelectableView


- (void) setSelected:(BOOL)selected
{
  _selected = selected;
  NSImageView *backgroundImageView;
  for (NSView *view in [self subviews]) {
    if ([view isKindOfClass:[NSImageView class]]) {
      backgroundImageView = (NSImageView *)view;
      break;
    }
  }
  [backgroundImageView setImage:[NSImage imageNamed:self.selected ? @"bg_list_selected.png" : @"bg_list.png"]];
}

@synthesize selected = _selected;
@end
