//
//  BWSplitView.h
//  BWToolkit
//
//  Created by Brandon Walkin (www.brandonwalkin.com) and Fraser Kuyvenhoven.
//  All code is provided under the New BSD license.
//

#import <Cocoa/Cocoa.h>

@interface BWSplitView : NSSplitView 
{
	NSColor *color;
	BOOL colorIsEnabled, checkboxIsEnabled, dividerCanCollapse, collapsibleSubviewCollapsed;
	id secondaryDelegate;
	NSMutableDictionary *minValues, *maxValues, *minUnits, *maxUnits;
	NSMutableDictionary *resizableSubviewPreferredProportion, *nonresizableSubviewPreferredSize;
	NSArray *stateForLastPreferredCalculations;
	int collapsiblePopupSelection;
	float uncollapsedSize;
	
	// Collapse button
	NSButton *toggleCollapseButton;
	BOOL isAnimating;
}

@property (nonatomic, retain) NSMutableDictionary *minValues, *maxValues, *minUnits, *maxUnits;
@property (nonatomic, retain) NSMutableDictionary *resizableSubviewPreferredProportion, *nonresizableSubviewPreferredSize;
@property (nonatomic, retain) NSArray *stateForLastPreferredCalculations;
@property (nonatomic, retain) NSButton *toggleCollapseButton;
@property (nonatomic, assign) id secondaryDelegate;
@property (nonatomic) BOOL collapsibleSubviewCollapsed;
@property (nonatomic) int collapsiblePopupSelection;
@property (nonatomic) BOOL dividerCanCollapse;

// The split view divider color
@property (nonatomic, copy) NSColor *color;

// Flag for whether a custom divider color is enabled. If not, the standard divider color is used.
@property (nonatomic) BOOL colorIsEnabled;

// Call this method to collapse or expand a subview configured as collapsible in the IB inspector.
- (IBAction)toggleCollapse:(id)sender;

@end
