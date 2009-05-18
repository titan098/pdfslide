//
//  PDFDisplayController.m
//  PDFSlide
//
//  Created by David on 2009/05/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PDFDisplayController.h"

@implementation PDFDisplayController

- (id)init {
	if (![super initWithWindowNibName:@"PDFDisplay"])
		return nil;
	
	//register as an observer to listen for notifications
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
		   selector:@selector(handleSlideChange:)
			   name:ControllerSlideNumberNotification
			 object:nil];
	NSLog(@"Registered Notification Center");
	
	return self;
}

- (id)initWithSlides:(id)slidesObj {
	if (![self init])
		return nil;
	slides = slidesObj;
	return self;
}

- (void)dealloc {
	slides = nil;
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	[super dealloc];
}

- (void)handleSlideChange:(NSNotification *)note {
	NSLog(@"Slide Change Notification Recieved");
	NSNumber *slideNum = [[note userInfo] objectForKey:@"SlideNumber"];
	
	[pdfSlides setSlideNumber:[slideNum intValue]];
	[pdfSlides setNeedsDisplay:YES];
}

- (void) windowDidLoad {
	//NSLog(@"Nib file is loaded");
	[pdfSlides setSlide:slides];
}

//Advance the slides
- (IBAction)advanceSlides:(id)sender {
	[pdfSlides incrSlide:self];
	[pdfSlides setNeedsDisplay:YES];
}

//Reverse the slides
- (IBAction)reverseSlides:(id)sender {
	[pdfSlides decrSlide:self];
	[pdfSlides setNeedsDisplay:YES];
}

//set the slides number to display
- (void)setSlideNumber:(NSUInteger)num {
	[pdfSlides setSlideNumber:num];
	//return Nil;
}

//tell the slide window to redraw
- (void)redrawSlide {
	[pdfSlides setNeedsDisplay:YES];
	//return Nil;
}

@end
