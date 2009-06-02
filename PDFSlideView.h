//
//  PDFSlideView.h
//  PDFSlide
//
//  Created by David on 2009/05/16.
//  Copyright 2009 David Ellefsen. All rights reserved.
//
//	Control the display of a PDF file using a custom panel
//

#import <Cocoa/Cocoa.h>
#import "Slide.h"

extern NSString * const PDFViewKeyPressNotification;

@interface PDFSlideView : NSView {
	Slide *slide;
	NSUInteger slideNumber;
}

@property(readwrite) NSUInteger slideNumber;

- (void)setSlide:(Slide *)newSlide;

- (IBAction)incrSlide:(id)sender;
- (IBAction)decrSlide:(id)sender;

- (void)postKeyPressedNotification:(NSUInteger)keycode;

@end
