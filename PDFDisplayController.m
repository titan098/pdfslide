//
//  PDFDisplayController.m
//  PDFSlide
//
//  Created by David on 2009/05/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PDFDisplayController.h"

//The notifications
NSString * const DisplaySlideNumberNotification = @"DisplaySlideNumberChanged";

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
	
	//register observer to listen for slide obj changes
	[nc addObserver:self
		   selector:@selector(handleSlideObjChange:)
			   name:ControllerSlideObjectNotification
			 object:nil];
	
	NSLog(@"Notify Display: Slide Notification Observer Registered");
	
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
	NSLog(@"Nofity Display: Slide Change Notification Recieved");
	NSNumber *slideNum = [[note userInfo] objectForKey:@"SlideNumber"];
	
	[pdfSlides setSlideNumber:[slideNum intValue]];
	[pdfSlides setNeedsDisplay:YES];
}

- (void)handleSlideObjChange:(NSNotification *)note {
	NSLog(@"Notify Display: Slide Object Change Notification Recieved");
	Slide *newSlides = [[note userInfo] objectForKey:@"SlideObject"];
	
	slides = newSlides;
	[pdfSlides setSlide:slides];
}
	 
/*
 * Post a notification informating objservers that the slide has changed.
 */
- (void)postSlideChangeNotification {
	//Send a notification to the main window that the slide has changed
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		NSLog(@"Notify Display: Slide Changed");
		
		NSDictionary *d = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:[pdfSlides slideNumber]] 
													  forKey:@"SlideNumber"];
		
		[nc postNotificationName:DisplaySlideNumberNotification
						  object:self
						userInfo:d];
}

- (void) windowDidLoad {
	//NSLog(@"Nib file is loaded");
	[pdfSlides setSlide:slides];
}

//Advance the slides
- (IBAction)advanceSlides:(id)sender {
	[pdfSlides incrSlide:self];
	[pdfSlides setNeedsDisplay:YES];
	
	[self postSlideChangeNotification];
}

//Reverse the slides
- (IBAction)reverseSlides:(id)sender {
	[pdfSlides decrSlide:self];
	[pdfSlides setNeedsDisplay:YES];
	
	[self postSlideChangeNotification];
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

/*
 *	Handle the keydown events on the main window
 */
- (void)keyDown:(NSEvent *)theEvent {
	unsigned int keycode = [theEvent keyCode];
	switch (keycode) {
		case 123:
			//Left arrow
			NSLog(@"Keydown Event - Left Arrow");
			[self reverseSlides:self];
			break;
		case 124:
			//Right arrow
			NSLog(@"Keydown Event - Right Arrow");
			[self advanceSlides:self];
			break;
		default:
			NSLog(@"Keydown Event - %d", keycode);
			break;
	}
}
@end
