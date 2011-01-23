//
//  LISelectableView.m
//  Launch it!
//
//  Created by Brian Cooke on 1/22/11.
//  Copyright 2011 Made By Rocket, Inc. All rights reserved.
//

#import "LISelectableView.h"
#import "Website.h"

@implementation LISelectableView


- (id)initWithFrame:(NSRect)frame {
  if ((self = [super initWithFrame:frame])) {
  }
  
  return self;
}


- (void) setSelected:(BOOL)selected
{
  _selected = selected;
  NSImageView *backgroundImageView = [self viewWithTag:97];
  [backgroundImageView setImage:[NSImage imageNamed:self.selected ? @"bg_list_selected.png" : @"bg_list.png"]];
}


- (NSTextField *)nameField
{
  if (_nameField) return _nameField;
  _nameField = [self viewWithTag:9];
  [_nameField setDrawsBackground:YES];
  [_nameField setDelegate:self];
  
  [[NSNotificationCenter defaultCenter] addObserverForName:NSControlTextDidEndEditingNotification object:_nameField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notif) {
    [self.nameField setEditable:NO];
    [self.nameField setSelectable:NO];
    [self.nameField resignFirstResponder];
    [self.nameField setDrawsBackground:NO];
    [self.nameField setTextColor:[NSColor whiteColor]];
    [self.nameField setBezeled:NO];
  }];
  
  return _nameField;
}


- (void) mouseDown:(NSEvent *)theEvent
{
  [super mouseDown:theEvent];
  
  NSDictionary *bindingInfo = [self.nameField infoForBinding:NSValueBinding];
  if ([[[bindingInfo valueForKey:NSObservedObjectKey] representedObject] isKindOfClass:[Website class]] == NO)
    return; 
    
  if ([theEvent clickCount] == 2) {
    [self.nameField setEditable:![self.nameField isEditable]];
  }
  
  if ([self.nameField isEditable]) {
    [self edit];
  } else {
    [self.nameField setBezeled:NO];
    [self.nameField setSelectable:NO];
    [self.nameField resignFirstResponder];
    [self.nameField setDrawsBackground:NO];
    [self.nameField setTextColor:[NSColor whiteColor]];
  }
}


- (void) edit
{
  [self.nameField setBezelStyle:NSTextFieldSquareBezel];
  [self.nameField setBezeled:YES];
  [self.nameField setEditable:YES];
  [self.nameField setDrawsBackground:YES];
  [self.nameField setBackgroundColor:[NSColor whiteColor]];
  [self.nameField setTextColor:[NSColor blackColor]];
  [self.nameField becomeFirstResponder];  
}


#pragma mark -
#pragma mark NSTextFieldDelegate
//- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
//{
////  [self setSelected:NO];
//  [self.nameField setDrawsBackground:NO];
//  [self.nameField setTextColor:[NSColor whiteColor]];
//  [self.nameField setSelectable:NO];
//    
//  return YES;
//}



@synthesize selected = _selected, nameField = _nameField;
@end
