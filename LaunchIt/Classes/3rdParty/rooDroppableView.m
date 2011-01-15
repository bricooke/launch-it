//
//  rooDroppableView.m
//  Blinders
//
//  Created by Brian Cooke on 6/11/09.
//  Copyright 2009 roobasoft, LLC. All rights reserved.
//

#import "rooDroppableView.h"

@interface NSBezierPath(RCKTAdditions)
+ (NSBezierPath*)bezierPathWithRoundRectInRect:(NSRect)aRect radius:(float)radius;
@end


@implementation NSBezierPath(RCKTAdditions)
+ (NSBezierPath*)bezierPathWithRoundRectInRect:(NSRect)aRect radius:(float)radius
{
  NSBezierPath* path = [self bezierPath];
  radius = MIN(radius, 0.5f * MIN(NSWidth(aRect), NSHeight(aRect)));
  NSRect rect = NSInsetRect(aRect, radius, radius);
  [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect), NSMinY(rect)) radius:radius startAngle:180.0 endAngle:270.0];
  [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rect), NSMinY(rect)) radius:radius startAngle:270.0 endAngle:360.0];
  [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rect), NSMaxY(rect)) radius:radius startAngle:  0.0 endAngle: 90.0];
  [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect), NSMaxY(rect)) radius:radius startAngle: 90.0 endAngle:180.0];
  [path closePath];
  return path;
}
@end


@implementation rooDroppableView

@synthesize delegate = _delegate;
@synthesize dropPoint = _dropPoint;

- (NSDragOperation) draggingEntered:(id < NSDraggingInfo >)sender
{
    return [self.delegate draggingEntered:sender];
}

- (NSDragOperation) draggingUpdated:(id < NSDraggingInfo >)sender
{
    return [self.delegate draggingUpdated:sender];
}

- (void) draggingExited:(id < NSDraggingInfo >)sender
{
    return [self.delegate draggingExited:sender];
}

- (BOOL) prepareForDragOperation:(id < NSDraggingInfo >)sender
{
    return [self.delegate prepareForDragOperation:sender];
}

- (BOOL) performDragOperation:(id < NSDraggingInfo >)sender
{
    return [self.delegate performDragOperation:sender];
}

- (void) concludeDragOperation:(id < NSDraggingInfo >)sender
{
    return [self.delegate concludeDragOperation:sender];
}

//- (void) drawRect:(NSRect)rect
//{
//    [super drawRect:rect];
//    
//    if (self.dropPoint.y > 0 || YES) {
//        [[NSColor selectedControlColor] setStroke];
//        
//        NSBezierPath *circle = [NSBezierPath bezierPathWithRoundRectInRect:NSMakeRect(2, self.dropPoint.y-4, 8, 8) radius:4.0];
//        [circle setLineWidth:2.0];
//        [circle stroke];
//        
//      //        [[NSBezierPath bezierPathWithRect:NSMakeRect(9, self.dropPoint.y, rect.size.width, 1.0)] stroke];
//        [[NSBezierPath bezierPathWithRect:rect] stroke];
//    }
//}

@end
