//
//  PDFSlideAnnotatedView.m
//  PDFSlide
//
//  Created by David on 2009/06/13.
//  Copyright 2009 David Ellefsen. All rights reserved.
//
// This file is part of PDFSlide.
//
// PDFSlide is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// PDFSlide is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with PDFSlide.  If not, see <http://www.gnu.org/licenses/>.
//

#import "PDFSlideAnnotatedView.h"

//define notification strings
NSString * const AnnotationNotification = @"AnnotationNotification";

@implementation PDFSlideAnnotatedView

@synthesize annotationTool;
@synthesize showPointer;
@synthesize toolColour;

/**
 * Initilise the View
 */
- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		annotationTool = ANNOTATE_POINTER;
		canSendNotifications = YES;
		canRecieveNotifications = NO;
		
		pointerLocation.size.height = 10;
		pointerLocation.size.width = 10;
		
		[self setToolColour:[NSColor redColor]];
    }
    return self;
}

/**
 * Draws the Slide on the screen with any annotations
 */
- (void)drawRect:(NSRect)rect {
	//draw the slide
	[super drawRect:rect];
	
	//draw any annotations - if the slide object exists
	if (slide) {
		[[NSGraphicsContext currentContext] setShouldAntialias:YES];
		[toolColour set];
		
		//display the pointer on the screen
		if (showPointer) {
			NSBezierPath* pointerPath = [NSBezierPath bezierPath];
			[pointerPath appendBezierPathWithOvalInRect:pointerLocation];
			[pointerPath fill];
		}
	}
}

#pragma mark Tool Methods

/**
 * Sets the location of the "pointer" on the view
 */
- (void)setPointerLocation:(NSPoint) pointer {
	pointerLocation.origin = pointer;
}


#pragma mark Notification Methods

/**
 * Sets this view to send annotation notifications
 */
- (void)setCanSendNotifications:(BOOL) yesno {
	canSendNotifications = yesno;
	canRecieveNotifications = !yesno;
	
	//remove the notifcation observer - if exists
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self
				  name:AnnotationNotification
				object:nil];
}


/**
 * Sets this view to recieve annotation notifications
 */
- (void)setCanRecieveNotifications:(BOOL) yesno {
	canRecieveNotifications = yesno;
	canSendNotifications = !yesno;
	
	//add a notification observer
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
		   selector:@selector(handleAnnotationNotification:)
			   name:AnnotationNotification
			 object:nil];
}

/**
 * Scale a NSRect by the bounds of the view
 * Get range between 0 and 1
 */
- (NSRect)scaleDownNSRect:(NSRect)rect {
	NSRect newRect;
	NSRect bounds = [self bounds];
	newRect.size = rect.size;
	newRect.origin.x = rect.origin.x/bounds.size.width;
	newRect.origin.y = rect.origin.y/bounds.size.height;
	return newRect;
}

/**
 * Scale a NSRect by the bounds of the view
 * Get range between 0 and 1
 */
- (NSRect)scaleUpNSRect:(NSRect)rect {
	NSRect newRect;
	NSRect bounds = [self bounds];
	newRect.size = rect.size;
	newRect.origin.x = rect.origin.x*bounds.size.width;
	newRect.origin.y = rect.origin.y*bounds.size.height;
	return newRect;
}

/**
 * Posts an annotation notification
 */
- (void)postAnnotationNotification {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	
	//sets the user options dictionary
	NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:2];
	
	//populate the dictionary based on the tool being used
	//need to send the bounds of this view to calculate where to draw the annotations
	//[d setObject:NSStringFromRect([self bounds]) forKey:@"OriginalViewBounds"];
	[d setObject:[NSNumber numberWithInt:annotationTool] forKey:@"AnnotationTool"];
	[d setObject:toolColour forKey:@"AnnotationColour"];
	
	switch (annotationTool) {
		case ANNOTATE_POINTER:
			//send the pointers new location
			[d setObject:[NSNumber numberWithBool:showPointer] forKey:@"PointerShow"];
			[d setObject:NSStringFromRect([self scaleDownNSRect:pointerLocation]) forKey:@"PointerLocation"];
			break;
		default:
			break;
	}
	
	//post the notification
	[nc postNotificationName:AnnotationNotification
					  object:self
					userInfo:d];
}

/**
 * Handle a annotation notification that has been recieved
 */
- (void)handleAnnotationNotification:(NSNotification *)note {
	//get the tool that was being used
	NSUInteger tool = [[[note userInfo] objectForKey:@"AnnotationTool"] intValue];
	toolColour = [[note userInfo] objectForKey:@"AnnotationColour"];
	//NSRect OriginalBounds = NSRectFromString([[note userInfo] objectForKey:@"OriginalViewBounds"]);
	
	switch (tool) {
		case ANNOTATE_POINTER:
			showPointer = [[[note userInfo] objectForKey:@"PointerShow"] boolValue];
			pointerLocation = [self scaleUpNSRect:NSRectFromString([[note userInfo] objectForKey:@"PointerLocation"])];
			break;
		default:
			break;
	}
	
	//redraw the display
	[self setNeedsDisplay:YES];
}

#pragma mark Event Handlers

/**
 * Handle a mouse down event
 */
- (void)mouseDown:(NSEvent *)theEvent {
	NSPoint windowMouseLocation = [theEvent locationInWindow];
	NSPoint viewPoint = [self convertPoint:windowMouseLocation fromView:nil];
	
	switch (annotationTool) {
		case ANNOTATE_POINTER:
			//set the pointers location on the screen
			[self setPointerLocation:viewPoint];
			[self setShowPointer:YES];
			break;
		default:
			break;
	}
		
	//redraw the display
	[self postAnnotationNotification];
	[self setNeedsDisplay:YES];
}

- (void)mouseDragged:(NSEvent *)theEvent {
	NSPoint windowMouseLocation = [theEvent locationInWindow];
	NSPoint viewPoint = [self convertPoint:windowMouseLocation fromView:nil];

	switch (annotationTool) {
		case ANNOTATE_POINTER:
			//update the pointers location on the screen
			[self setPointerLocation:viewPoint];
			break;
		default:
			break;
	}
	
	//redraw the view
	[self postAnnotationNotification];
	[self setNeedsDisplay:YES];
}

/**
 * Handle a mouse up event
 */
- (void)mouseUp:(NSEvent *)theEvent {
	switch (annotationTool) {
		case ANNOTATE_POINTER:
			//hide the pointer
			[self setShowPointer:NO];
			break;
		default:
			break;
	}	
	
	//update the view
	[self postAnnotationNotification];
	[self setNeedsDisplay:YES];
}

@end
