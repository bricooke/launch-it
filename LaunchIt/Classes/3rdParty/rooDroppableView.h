//
//  rooDroppableView.h
//  Blinders
//
//  Created by Brian Cooke on 6/11/09.
//  Copyright 2009 roobasoft, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface rooDroppableView : NSView {
    id      _delegate;
    NSPoint _dropPoint;
}

@property (nonatomic, retain)   id delegate;
@property (assign)              NSPoint dropPoint;

@end
