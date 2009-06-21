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
@synthesize pointerStyle;
@synthesize showPointer;

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
		
		//init a new path Dictionary
		pathDict = [[NSMutableDictionary alloc] init];
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
		[toolColour set];
		[[NSGraphicsContext currentContext] setShouldAntialias:YES];
		//display the pointer on the screen
		if (showPointer) {
			NSBezierPath* pointerPath = [NSBezierPath bezierPath];
			if (pointerStyle == ANNOTATE_POINTER_STYLE_CIRCLE)
				[pointerPath appendBezierPathWithOvalInRect:pointerLocation];
			if (pointerStyle == ANNOTATE_POINTER_STYLE_SQUARE)
				[pointerPath appendBezierPathWithRect:pointerLocation];
			[pointerPath fill];
		}
		
		//draw any paths assositated with this page
		NSArray *pageArray = [pathDict objectForKey:[NSNumber numberWithInt:slideNumber]];
		[toolColour set];
		[[NSGraphicsContext currentContext] setShouldAntialias:NO];
		for (NSBezierPath *path in pageArray) {
			[path stroke];
		}
	}
}

#pragma mark Tool Methods

- (void)setToolColour:(NSColor*)colour {
	toolColour = colour;
}

/**
 * Sets the location of the "pointer" on the view
 */
- (void)setPointerLocation:(NSPoint)pointer {
	pointerLocation.origin.x = (pointer.x)-(pointerLocation.size.width/2);
	pointerLocation.origin.y = (pointer.y)-(pointerLocation.size.height/2);
}

/**
 * Sets the size of the pointer
 */
- (void)setPointerSize:(NSUInteger)size {
	pointerLocation.size.width = size;
	pointerLocation.size.height = size;
}

/**
 * Creates a new path for this slide
 */
- (NSBezierPath *)createNewPath {
	NSMutableArray *pageArray = [pathDict objectForKey:[NSNumber numberWithInt:slideNumber]];

	//if doesn't exist -- create it
	if (!pageArray) {
		pageArray = [[NSMutableArray alloc] init];
		[pathDict setObject:pageArray forKey:[NSNumber numberWithInt:slideNumber]];
	}
	
	//create a new path in this array
	NSBezierPath *newPath = [[NSBezierPath alloc] init];
	[pageArray addObject:newPath];
	
	return newPath;
}

/**
 * Gets the current bounds of the current path
 */
- (NSRect)currentPathBounds {
	NSMutableArray *pageArray = [pathDict objectForKey:[NSNumber numberWithInt:slideNumber]];
	
	//get the last path in the array - will be the current one
	NSBezierPath *currentPath = [pageArray objectAtIndex:([pageArray count]-1)];
	return [currentPath bounds];
}

/**
 * Adds a point to the current path
 */
- (BOOL)addPointToPath:(NSPoint)point {
	NSMutableArray *pageArray = [pathDict objectForKey:[NSNumber numberWithInt:slideNumber]];
	
	//check to see if the array exists
	if (!pageArray)
		return NO;
	
	//get the last path in the array - will be the current one
	NSBezierPath *currentPath = [pageArray objectAtIndex:([pageArray count]-1)];
	
	//check to see if this is the first point added to the path
	if (![currentPath elementCount])
		[currentPath moveToPoint:point];
	else
		[currentPath lineToPoint:point];
	
	return YES;
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
	newRect.size = rect.size;
	newRect.origin.x = (rect.origin.x-pagebounds.origin.x)/pagebounds.size.width;
	newRect.origin.y = (rect.origin.y-pagebounds.origin.y)/pagebounds.size.height;
	return newRect;
}

/**
 * Scale a NSRect by the bounds of the view
 * Get range between 0 and 1
 */
- (NSRect)scaleUpNSRect:(NSRect)rect {
	NSRect newRect;
	newRect.size = rect.size;
	newRect.origin.x = (rect.origin.x*pagebounds.size.width)+pagebounds.origin.x;
	newRect.origin.y = (rect.origin.y*pagebounds.size.height)+pagebounds.origin.y;
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
			[d setObject:[NSNumber numberWithInt:pointerStyle] forKey:@"PointerStyle"];
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
	NSRect oldBounds;
	NSRect newBounds;
	
	switch (tool) {
		case ANNOTATE_POINTER:
			showPointer = [[[note userInfo] objectForKey:@"PointerShow"] boolValue];
			pointerStyle = [[[note userInfo] objectForKey:@"PointerStyle"] intValue];
			oldBounds = pointerLocation;	//save the old pointer location
			pointerLocation = [self scaleUpNSRect:NSRectFromString([[note userInfo] objectForKey:@"PointerLocation"])];
			newBounds = pointerLocation;	//record the new pointer location
			break;
		default:
			break;
	}
	
	//redraw the display
	[super setNeedsDisplayInRect:oldBounds];
	[self setNeedsDisplayInRect:newBounds];
}

#pragma mark Event Handlers

/**
 * Handle a mouse down event
 */
- (void)mouseDown:(NSEvent *)theEvent {
	NSPoint windowMouseLocation = [theEvent locationInWindow];
	NSPoint viewPoint = [self convertPoint:windowMouseLocation fromView:nil];
	NSRect oldBounds;
	NSRect newBounds;	
	
	switch (annotationTool) {
		case ANNOTATE_POINTER:
			//set the pointers location on the screen
			oldBounds = pointerLocation;
			[self setPointerLocation:viewPoint];
			[self setShowPointer:YES];
			newBounds = pointerLocation;
			break;
		case ANNOTATE_PEN:
			//create a new path
			[self createNewPath];
			[self addPointToPath:viewPoint];
			newBounds = [self currentPathBounds];
			oldBounds = newBounds;
			break;
		default:
			break;
	}
		
	oldBounds.origin.x--;
	oldBounds.origin.y--;
	oldBounds.size.width++;
	oldBounds.size.height++;
	newBounds.origin.x--;
	newBounds.origin.y--;
	newBounds.size.width++;
	newBounds.size.height++;
	
	//redraw the display
	[self postAnnotationNotification];
	[super setNeedsDisplayInRect:oldBounds];
	[self setNeedsDisplayInRect:newBounds];
}

/**
 * Handle a mouse dragged event
 */
- (void)mouseDragged:(NSEvent *)theEvent {
	NSPoint windowMouseLocation = [theEvent locationInWindow];
	NSPoint viewPoint = [self convertPoint:windowMouseLocation fromView:nil];
	NSRect oldBounds;
	NSRect newBounds;	

	switch (annotationTool) {
		case ANNOTATE_POINTER:
			//update the pointers location on the screen
			oldBounds = pointerLocation;
			[self setPointerLocation:viewPoint];
			newBounds = pointerLocation;
			break;
		case ANNOTATE_PEN:
			[self addPointToPath:viewPoint];
			newBounds = [self currentPathBounds];
			oldBounds = newBounds;
			break;
		default:
			break;
	}
	
	oldBounds.origin.x--;
	oldBounds.origin.y--;
	oldBounds.size.width++;
	oldBounds.size.height++;
	newBounds.origin.x--;
	newBounds.origin.y--;
	newBounds.size.width++;
	newBounds.size.height++;
	
	//redraw the view
	[self postAnnotationNotification];
	[super setNeedsDisplayInRect:oldBounds];
	[self setNeedsDisplayInRect:newBounds];
}

/**
 * Handle a mouse up event
 */
- (void)mouseUp:(NSEvent *)theEvent {
	NSRect oldBounds;
	
	switch (annotationTool) {
		case ANNOTATE_POINTER:
			//hide the pointer
			oldBounds = pointerLocation;
			[self setShowPointer:NO];
			break;
		case ANNOTATE_PEN:
			oldBounds = [self currentPathBounds];
			break;
		default:
			break;
	}	
	
	oldBounds.origin.x--;
	oldBounds.origin.y--;
	oldBounds.size.width++;
	oldBounds.size.height++;
	
	//update the view
	[self postAnnotationNotification];
	[self setNeedsDisplayInRect:oldBounds];
}

@end
