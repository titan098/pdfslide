//
//  PDFSlideView.m
//  PDFSlide
//
//  Created by David on 2009/05/16.
//  Copyright 2009 David Ellefsen. All rights reserved.
//
//	Control the display of a PDF file using a custom panel
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

#import "PDFSlideView.h"

NSString * const PDFViewKeyPressNotification = @"PDFViewKeyPressed";

@implementation PDFSlideView

@synthesize slideNumber;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSlide:NULL];
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    //set the view to initially be black
	[NSGraphicsContext saveGraphicsState];
	
	NSRect bounds = [self bounds];
	[[NSColor blackColor] set];	//set the drawing color
	[NSBezierPath fillRect:bounds];
	
	if ((slide != NULL) && (slideNumber < [slide pageCount])) {
		//draw the current slide as indicated by the slide object
		NSAffineTransform *xform = [NSAffineTransform transform];
		//[xform translateXBy:50.0 yBy:20.0];
		//[xform scaleXBy:2.0 yBy:2.0];
		PDFPage *slidePage = [slide pageAtIndex:slideNumber];
		
		//calculate the correct transformation and scaling values
		pagebounds = [slidePage boundsForBox:kPDFDisplayBoxMediaBox];
		CGFloat rotation = [slidePage rotation];
		
		// if the pdfpage is rotated by 90deg swap the height and width
		if (rotation == 90 || rotation == 270) {
			CGFloat temp = pagebounds.size.width;
			pagebounds.size.width = pagebounds.size.height;
			pagebounds.size.height = temp;
		}
		
		CGFloat xscale = bounds.size.width / pagebounds.size.width;
		CGFloat yscale = bounds.size.height / pagebounds.size.height;
		CGFloat scale = (xscale < yscale ? xscale : yscale);
		
		//draw the pdf page in the middle of the view
		CGFloat deltaX = (bounds.size.width - (pagebounds.size.width*scale))/2.0;
		CGFloat deltaY = (bounds.size.height - (pagebounds.size.height*scale))/2.0;
		[xform translateXBy:deltaX
						yBy:deltaY];
		
		//scale the pdf by the smallest scaling value - retain the aspect
		[xform scaleBy:scale];
		[xform concat];
		
		//set the background color (of the page) to white
		[[NSColor whiteColor] set];
		[NSBezierPath fillRect:pagebounds];
		
		//draw a black line around the slide - should hide the edge of the page
		[[NSColor blackColor] set];
		NSBezierPath *box = [NSBezierPath bezierPathWithRect:pagebounds];
		[box stroke];
		
		[slidePage drawWithBox:kPDFDisplayBoxMediaBox];
		
		//store the scaled pagebounds
		pagebounds.origin.x = deltaX;
		pagebounds.origin.y = deltaY;
		pagebounds.size.width *= scale;
		pagebounds.size.height *= scale;
	} 
	
	//draw the view
	[NSGraphicsContext restoreGraphicsState];
}

/**
 * Sets the Slide object to display from
 */
- (void)setSlide:(Slide *)newSlide {
	slide = newSlide;
}


/**
 * Increase the slide number to display
 */
- (IBAction)incrSlide:(id)sender {
	if (slideNumber < [slide pageCount]) {
		slideNumber++;	
	}
}

/**
 * Decrement the slide number to display
 */
-(IBAction)decrSlide:(id)sender {
	if (slideNumber > 0) {
		slideNumber--;
	}
}

/*
 * Post a notification informating objservers that a key was pressed.
 */
- (void)postKeyPressedNotification:(NSUInteger)keycode {
	//Send a notification to the main window that the slide has changed
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	NSLog(@"Notify Display: Key Pressed");
	
	NSDictionary *d = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:keycode] 
												  forKey:@"KeyCode"];
	
	[nc postNotificationName:PDFViewKeyPressNotification
					  object:self
					userInfo:d];
}

/*
 * Handle any keypresses that are sent to the view
 */
- (void)keyDown:(NSEvent *)theEvent {
	NSUInteger keycode = [theEvent keyCode];
	[self postKeyPressedNotification:keycode];
}

@end
