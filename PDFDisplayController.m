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

- (id)initWithSlidesScreen:(id)slidesObj screen:(NSUInteger)screen{
	if (![self init])
		return nil;
	slides = slidesObj;
	displayScreen = screen;
	return self;
}

- (void)dealloc {
	slides = nil;
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	[super dealloc];
}


/*
 * Display the View in fullscreen mode
 */
- (void)enterFullScreen {
	//NSScreen
	NSScreen *screen = [[NSScreen screens] objectAtIndex:displayScreen];
	
	//move the window to the right screen
	NSWindow *window = [self window];
	[window setFrame:[screen frame] display:YES];

	//enter fullscreen
	NSDictionary *d = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
												  forKey:NSFullScreenModeAllScreens];
	[pdfSlides enterFullScreenMode:screen
					   withOptions:d];
}

/**
 * Handle if a SlideChange notification arrives
 */
- (void)handleSlideChange:(NSNotification *)note {
	NSLog(@"Nofity Display: Slide Change Notification Recieved");
	NSNumber *slideNum = [[note userInfo] objectForKey:@"SlideNumber"];
	
	[pdfSlides setSlideNumber:[slideNum intValue]];
	[pdfSlides setNeedsDisplay:YES];
}

/**
 * Handle Slide Object Change notification
 */
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

/**
 * Perform any window components initialisation
 */
- (void) windowDidLoad {
	//NSLog(@"Nib file is loaded");
	[pdfSlides setSlide:slides];
	
	[self enterFullScreen];
	
	//make the view respond to events passed in this window
	[[self window] makeFirstResponder:pdfSlides];
}

/**
 * Advance the slides and post a notification
 */
- (IBAction)advanceSlides:(id)sender {
	[pdfSlides incrSlide:self];
	[pdfSlides setNeedsDisplay:YES];
	
	[self postSlideChangeNotification];
}

/**
 * Reverse the slides and post a notification
 */
- (IBAction)reverseSlides:(id)sender {
	[pdfSlides decrSlide:self];
	[pdfSlides setNeedsDisplay:YES];
	
	[self postSlideChangeNotification];
}

/**
 * set the slides number to display
 */
- (void)setSlideNumber:(NSUInteger)num {
	[pdfSlides setSlideNumber:num];
	//return Nil;
}

/**
 * tell the slide window to redraw
 */
- (void)redrawSlide {
	[pdfSlides setNeedsDisplay:YES];
	//return Nil;
}

/*
 * Handle any keypresses that are sent to the view
 */
- (void)keyDown:(NSEvent *)theEvent {
	NSUInteger keycode = [theEvent keyCode];
	[self postKeyPressedNotification:keycode];
}

@end
