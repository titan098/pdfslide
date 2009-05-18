//
//  PDFSlideController.m
//  PDFSlide
//
//  Created by David on 2009/05/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PDFSlideController.h"

//define the notifications
NSString * const ControllerSlideNumberNotification = @"ControllerSlideNumberChanged";
NSString * const ControllerRedrawSlideNotification = @"ControllerSlideRedraw";

@implementation PDFSlideController

/*
 * Control how the open dialog sheet will perform
 */
- (void)openPanelDidEnd:(NSOpenPanel *)openPanel
			 returnCode:(int)returnCode
			contextInfo:(void *)x {

	//was the OK Button pushed
	if (returnCode == NSOKButton) {
		NSString *filename = [openPanel filename];

		slides = [[Slide alloc] initWithURL:[NSURL fileURLWithPath:filename]];
		
		[self initiliseWindow];
	}
}


/*
 * Show the open dialog button to allow the user to select a PDF file to open
 */
- (IBAction)openDocument:(id)sender {
	NSLog(@"Open Document Clicked");
	
	//Show the NSOpenPanel to open a PDF Document
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	NSArray *fileTypes = [NSArray arrayWithObject:@"pdf"];
	
	//show the panel in a sheet
	[openPanel beginSheetForDirectory:nil
							 file:nil 
							types:fileTypes 
				   modalForWindow:[self window]
					modalDelegate:self
					didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:) 
					  contextInfo:NULL];
}

/*
 * Setup all the window components
 */
- (void) initiliseWindow {
	//setup the level indicator
	[pageLevel setMaxValue:((double)[slides pageCount]+1)];
	[pageLevel setIntValue:1];
	
	//view the slide access to the slides object
	[currentSlide setSlide:slides];
	[currentSlide setSlideNumber:0];
	[nextSlide setSlide:slides];
	[nextSlide setSlideNumber:1];
	
	//redraw the slides
	[currentSlide setNeedsDisplay:YES];
	[nextSlide setNeedsDisplay:YES];
}

/*
 * Post a notification informating objservers that the slide has changed.
 */
- (void)postSlideChangeNotification {
	//Send a notification to the main window that the slide has changed
	if (pdfDisplay) {
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		NSLog(@"Notify - Slide Changed");
		
		NSDictionary *d = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:[currentSlide slideNumber]] 
																			  forKey:@"SlideNumber"];
		
		[nc postNotificationName:ControllerSlideNumberNotification
						  object:self
						userInfo:d];	
	}
}

/*
 * Play the slide show in the primary or secondary screen
 */
- (IBAction)playSlides:(id)sender {
	//show the display window
	if (!pdfDisplay) {
		pdfDisplay = [[PDFDisplayController alloc] initWithSlides:slides];
	}
	
	NSLog(@"Showing the PDFDisplay Window");
	[pdfDisplay showWindow:self];
	
	//display the current slide
	[self postSlideChangeNotification];
}

/*
 * Move to the next slide
 */
- (IBAction)advanceSlides:(id)sender {
	[currentSlide incrSlide:self];
	[nextSlide setSlideNumber:([currentSlide slideNumber]+1)];
	
	//move the level indicator
	if ([pageLevel intValue] < [pageLevel maxValue])
		[pageLevel setIntValue:[pageLevel intValue]+1];
	
	//redraw the views
	[currentSlide setNeedsDisplay:YES];
	[nextSlide setNeedsDisplay:YES];
	
	[self postSlideChangeNotification];
}

/*
 * Move back to the previous slide
 */
- (IBAction)reverseSlides:(id)sender {
	[currentSlide decrSlide:self];
	[nextSlide setSlideNumber:([currentSlide slideNumber]+1)];
	
	//move the level indicator
	if ([pageLevel intValue] > 1)
		[pageLevel setIntValue:[pageLevel intValue]-1];
	
	//redraw the views
	[currentSlide setNeedsDisplay:YES];
	[nextSlide setNeedsDisplay:YES];

	[self postSlideChangeNotification];
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
