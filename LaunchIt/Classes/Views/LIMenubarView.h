//
//  LIMenubarView.h
//  LaunchIt
//
//  Created by Brian Cooke on 1/17/11.
//  Copyright 2011 Made By Rocket, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LIWindowController;

@interface LIMenubarView : NSView {
  LIWindowController *__unsafe_unretained controller;
  BOOL clicked;
}

@property (nonatomic, unsafe_unretained) LIWindowController *controller;

- (id)initWithFrame:(NSRect)frame controller:(LIWindowController *)ctrlr;

@end
