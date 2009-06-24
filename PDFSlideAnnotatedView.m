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
@synthesize penSize;

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
		[[NSGraphicsContext currentContext] setShouldAntialias:YES];
		for (PSBezierPath *path in pageArray) {
			[[path colour] set];
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
- (NSMutableArray *)createNewPath {
	NSMutableArray *pageArray = [pathDict objectForKey:[NSNumber numberWithInt:slideNumber]];

	//if doesn't exist -- create it
	if (!pageArray) {
		pageArray = [[NSMutableArray alloc] init];
		[pathDict setObject:pageArray forKey:[NSNumber numberWithInt:slideNumber]];
	}
	
	//create a new path in this array
	PSBezierPath *newPath = [[PSBezierPath alloc] init];
	[newPath setColour:toolColour];
	[newPath setFlatness:0.1];
	[pageArray addObject:newPath];
	
	return pageArray;
}

/**
 * Gets the last point draw drawn on the display
 */
- (NSPoint)getLastPenPoint {
	NSMutableArray *pageArray = [pathDict objectForKey:[NSNumber numberWithInt:slideNumber]];
	return [[pageArray objectAtIndex:([pageArray count]-1)] currentPoint];
}

/**
 * Gets the current path
 */
- (PSBezierPath *)getCurrentPath {
	NSMutableArray *pageArray = [pathDict objectForKey:[NSNumber numberWithInt:slideNumber]];
	return [pageArray objectAtIndex:([pageArray count]-1)];;
}

/**
 * Adds a BezierPath to the current Path
 */
- (void)addPath:(PSBezierPath *)path {
	NSMutableArray *pageArray = [pathDict objectForKey:[NSNumber numberWithInt:slideNumber]];
	
	//if doesn't exist -- create it
	if (!pageArray) {
		pageArray = [[NSMutableArray alloc] init];
		[pathDict setObject:pageArray forKey:[NSNumber numberWithInt:slideNumber]];
	}
	
	//add the path to the dictionary for this page
	[pageArray addObject:path];
}

/**
 * Gets the current bounds of the current path
 */
- (NSRect)currentPathBounds {
	NSMutableArray *pageArray = [pathDict objectForKey:[NSNumber numberWithInt:slideNumber]];
	
	//get the last path in the array - will be the current one
	NSBezierPath *currentPath = [pageArray objectAtIndex:([pageArray count]-1)];
	//[currentPath setFlatness:0.1];
	return [currentPath bounds];
}

/**
 * Returns YES if the current path has one element
 */
- (BOOL)isNewPath {
	NSMutableArray *pageArray = [pathDict objectForKey:[NSNumber numberWithInt:slideNumber]];
	NSBezierPath *currentPath = [pageArray objectAtIndex:([pageArray count]-1)];
	return ([currentPath elementCount] == 1);
}

/**
 * Adds a point to the current path
 */
- (BOOL)addPointToPath:(NSPoint)point {
	NSMutableArray *pageArray = [pathDict objectForKey:[NSNumber numberWithInt:slideNumber]];
	
	//check to see if the array exists
	if (!pageArray) {
		pageArray = [self createNewPath];
		return NO;
	}
	
	//get the last path in the array - will be the current one
	NSBezierPath *currentPath = [pageArray objectAtIndex:([pageArray count]-1)];
	
	//check to see if this is the first point added to the path
	if (![currentPath elementCount])
		[currentPath moveToPoint:point];
	else  if ([currentPath elementCount] == 200) {
		//create a new path and add the points to it
		[currentPath lineToPoint:point];
		sendPath = YES;
		[self postAnnotationNotification];	//send the finished current path to the recievers
		
		[self createNewPath];
		return [self addPointToPath:point];		
	} else {
		[currentPath lineToPoint:point];
	}
	
	return YES;
}

/**
 * Clear all the paths from the view
 */
- (void)clearPaths {
	//disgard and refresh
	NSMutableArray *pageArray = [pathDict objectForKey:[NSNumber numberWithInt:slideNumber]];
	[pageArray removeAllObjects];
	
	[super setNeedsDisplay:YES];
	
	if (canSendNotifications) {
		clear=YES;
		[self postAnnotationNotification]; //tell recievers to clear the current slide
	}
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
 * Scale a NSRect by the bounds of the view
 * Get range between 0 and 1
 */
/*
- (NSPoint)scaleDownNSPoint:(NSPoint)point {
	NSPoint newPoint;
	newPoint.x = (point.x-pagebounds.origin.x)/pagebounds.size.width;
	newPoint.y = (point.y-pagebounds.origin.y)/pagebounds.size.height;
	return newPoint;
}
 */

/**
 * Scale a NSRect by the bounds of the view
 * Get range between 0 and 1
 */
/*
- (NSPoint)scaleUpNSPoint:(NSPoint)point {
	NSPoint newPoint;
	newPoint.x = (point.x*pagebounds.size.width)+pagebounds.origin.x;
	newPoint.y = (point.y*pagebounds.size.height)+pagebounds.origin.y;
	return newPoint;
}
 */

/**
 * Scale a NSBezierPath by the bounds of the page
 */
- (PSBezierPath *)scaleDownPSBezierPath:(PSBezierPath *)path {
	NSAffineTransform* xform = [NSAffineTransform transform];
	[xform scaleXBy:(1/pagebounds.size.width)
				yBy:(1/pagebounds.size.height)];
	[xform translateXBy:-pagebounds.origin.x 
					yBy:-pagebounds.origin.y];
	
	//get new bezierpath
	PSBezierPath* newPath = [path copy];
	[path bounds];
	[newPath bounds];
	[newPath transformUsingAffineTransform:xform];
	[newPath bounds];
	return newPath;
};

/**
 * Scale up a NSBezierPath by the bounds of the page
 */
- (PSBezierPath *)scaleUpPSBezierPath:(PSBezierPath *)path {
	NSAffineTransform* xform = [NSAffineTransform transform];
	[xform translateXBy:pagebounds.origin.x
					yBy:pagebounds.origin.y];
	[xform scaleXBy:pagebounds.size.width 
				yBy:pagebounds.size.height];
	
	//get the new bezierpath and transform
	PSBezierPath *newPath = [path copy];
	[path bounds];
	[newPath bounds];
	[newPath transformUsingAffineTransform:xform];
	[newPath bounds];
	return newPath;
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
	[d setObject:[NSNumber numberWithBool:clear] forKey:@"AnnotationClear"];
	
	if (clear) clear=NO; //clear the 'clear' flag
	
	switch (annotationTool) {
		case ANNOTATE_POINTER:
			//send the pointers new location
			[d setObject:[NSNumber numberWithInt:pointerStyle] forKey:@"PointerStyle"];
			[d setObject:[NSNumber numberWithBool:showPointer] forKey:@"PointerShow"];
			[d setObject:NSStringFromRect([self scaleDownNSRect:pointerLocation]) forKey:@"PointerLocation"];
			break;
		case ANNOTATE_PEN:
			if (sendPath) {
				[d setObject:[self scaleDownPSBezierPath:[self getCurrentPath]] forKey:@"PenPath"];
				sendPath = NO;
			}
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
	PSBezierPath *path;
	//get the tool that was being used
	NSUInteger tool = [[[note userInfo] objectForKey:@"AnnotationTool"] intValue];
	toolColour = [[note userInfo] objectForKey:@"AnnotationColour"];
	
	//clear the paths if requested
	if ([[[note userInfo] objectForKey:@"AnnotationClear"] boolValue])
		[self clearPaths];
	
	//NSRect OriginalBounds = NSRectFromString([[note userInfo] objectForKey:@"OriginalViewBounds"]);
	NSRect oldBounds;
	NSRect newBounds = pagebounds;
	
	switch (tool) {
		case ANNOTATE_POINTER:
			showPointer = [[[note userInfo] objectForKey:@"PointerShow"] boolValue];
			pointerStyle = [[[note userInfo] objectForKey:@"PointerStyle"] intValue];
			oldBounds = pointerLocation;	//save the old pointer location
			pointerLocation = [self scaleUpNSRect:NSRectFromString([[note userInfo] objectForKey:@"PointerLocation"])];
			newBounds = pointerLocation;	//record the new pointer location
			break;
		case ANNOTATE_PEN:
			//create a new path if the sender created a new path
			path = [[note userInfo] objectForKey:@"PenPath"];
			if (path) {
				[self addPath:[self scaleUpPSBezierPath:path]];
				newBounds = pagebounds;
			}
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
			
			[super setNeedsDisplayInRect:oldBounds];			
			break;
		case ANNOTATE_PEN:
			[self addPointToPath:viewPoint];
			newBounds = [self currentPathBounds];
			break;
		default:
			break;
	}
	
	//redraw the view
	[self setNeedsDisplayInRect:newBounds];
	[self postAnnotationNotification];
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
			sendPath = YES;
			oldBounds = pagebounds;
			break;
		default:
			break;
	}	
	
	//update the view
	[self postAnnotationNotification];
	[self setNeedsDisplayInRect:oldBounds];
}

@end
