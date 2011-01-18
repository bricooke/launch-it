//
//  LIMenubarView.h
//  LaunchIt
//
//  Created by Brian Cooke on 1/17/11.
//  Copyright 2011 roobasoft, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LIWindowController;

@interface LIMenubarView : NSView {
  LIWindowController *controller;
  BOOL clicked;
}

@property (nonatomic, assign) LIWindowController *controller;

- (id)initWithFrame:(NSRect)frame controller:(LIWindowController *)ctrlr;

@end
