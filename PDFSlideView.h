//
//  PDFSlideView.h
//  PDFSlide
//
//  Created by David on 2009/05/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
//	Control the display of a PDF file using a custom panel
//

#import <Cocoa/Cocoa.h>
#import "Slide.h"


@interface PDFSlideView : NSView {
	Slide *slide;
	NSUInteger slideNumber;
}

@property(readwrite) NSUInteger slideNumber;

- (void)setSlide:(Slide *)newSlide;

@end
