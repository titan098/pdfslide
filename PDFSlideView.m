//
//  PDFSlideView.m
//  PDFSlide
//
//  Created by David on 2009/05/16.
//  Copyright 2009 David Ellefsen. All rights reserved.
//
//	Control the display of a PDF file using a custom panel
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
	//[NSGraphicsContext saveGraphicsState];
	
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
		NSRect pagebounds = [slidePage boundsForBox:kPDFDisplayBoxMediaBox];
		
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
		[slidePage drawWithBox:kPDFDisplayBoxMediaBox];
	} 
	
	//draw the view
	//[NSGraphicsContext restoreGraphicsState];
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
