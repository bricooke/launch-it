//
//  LISelectableView.h
//  Launch it!
//
//  Created by Brian Cooke on 1/22/11.
//  Copyright 2011 Made By Rocket, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LISelectableView : NSView {
  BOOL _selected;
}

@property (nonatomic, readwrite) BOOL selected;

@end
