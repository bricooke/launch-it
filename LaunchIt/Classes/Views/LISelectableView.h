//
//  LISelectableView.h
//  Launch it!
//
//  Created by Brian Cooke on 1/22/11.
//  Copyright 2011 Made By Rocket, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LISelectableView : NSView<NSTextFieldDelegate> {
  BOOL _selected;
  NSTextField *_nameField;
}

@property (nonatomic, readwrite) BOOL selected;
@property (nonatomic, strong) NSTextField *nameField;

- (void) edit;

@end
