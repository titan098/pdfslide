 //
//  PDFSlideView.m
//  PDFSlide
//
//  Created by David on 2009/05/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
//	Control the display of a PDF file using a custom panel
//

#import "PDFSlideView.h"


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
	
	if (slide != NULL) {
		//draw the current slide as indicated by the slide object
		NSAffineTransform *xform = [NSAffineTransform transform];
		//[xform translateXBy:50.0 yBy:20.0];
		//[xform scaleXBy:2.0 yBy:2.0];
		PDFPage *slidePage = [slide pageAtIndex:slideNumber];
				
		//calculate the correct transformation and scaling values
		NSRect pagebounds = [slidePage boundsForBox:kPDFDisplayBoxMediaBox];
		
		CGFloat xscale = bounds.size.width / pagebounds.size.width;
		CGFloat yscale = bounds.size.height / pagebounds.size.height;
		
		//scale the pdf by the smallest scaling value - retain the aspect
		[xform scaleBy:(xscale < yscale ? xscale : yscale)];
		
		[xform concat];
		[slidePage drawWithBox:kPDFDisplayBoxMediaBox];
	}
	
	//draw the view
	[NSGraphicsContext restoreGraphicsState];
}

- (void)setSlide:(Slide *)newSlide {
	slide = newSlide;
}

@end
