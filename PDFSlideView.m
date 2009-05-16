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

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    //set the view to initially be black
	NSRect bounds = [self bounds];
	[[NSColor blackColor] set];	//set the drawing color
	[NSBezierPath fillRect:bounds];
}

@end
