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

- (void)setPointerLocation:(NSPoint) pointer {
	pointerLocation.origin = pointer;
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
	[self setNeedsDisplay:YES];
}

@end
