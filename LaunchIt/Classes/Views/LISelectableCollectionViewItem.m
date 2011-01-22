//
//  LISelectableCollectionViewItem.m
//  Launch it!
//
//  Created by Brian Cooke on 1/22/11.
//  Copyright 2011 Made By Rocket, Inc. All rights reserved.
//

#import "LISelectableCollectionViewItem.h"
#import "LISelectableView.h"

@implementation LISelectableCollectionViewItem

- (void)setSelected:(BOOL)flag
{
  [super setSelected:flag];
  [(LISelectableView*)[self view] setSelected:flag];
  [(LISelectableView*)[self view] setNeedsDisplay:YES];
}

@end
