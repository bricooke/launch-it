//
//  LIWindowController.h
//  LaunchIt
//
//  Created by Brian Cooke on 1/15/11.
//  Copyright 2011 roobasoft, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Application, LIEditApplicationViewController;

@interface LIWindowController : NSWindowController {
  NSCollectionView *collectionView;
  NSView *containerView;
  LIEditApplicationViewController *editAppController;
  NSButton *cancelButton;
  NSButton *saveButton;
}

@property (nonatomic, retain) IBOutlet NSCollectionView *collectionView;
@property (nonatomic, retain) IBOutlet NSView *containerView;
@property (nonatomic, retain) LIEditApplicationViewController *editAppController;
@property (nonatomic, retain) IBOutlet NSButton *cancelButton;
@property (nonatomic, retain) IBOutlet NSButton *saveButton;

- (void) editApplication:(Application *)anApp;

@end
