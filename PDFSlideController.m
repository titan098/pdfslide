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
NSString * const ControllerSlideObjectNotification = @"ControllerSlideObjectChange";
NSString * const ControllerSlideStopNotification = @"ControllerSlideStop";

@implementation PDFSlideController

- (void)dealloc {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	[super dealloc];
}

/**
 * Will execute once the nib file has loaded
 */
- (void) awakeFromNib {
	//get the screen information in the display toolbar item
	NSArray *screens = [NSScreen screens];
	
	NSUInteger i, count = [screens count];
	NSMenu *popup = [displayMenu menu];
	for (i = 0; i < count; i++) {
		//NSScreen *obj = [screens objectAtIndex:i];
		//[displayMenu addItemWithTitle:[NSString stringWithFormat:@"Screen %u",i]];
		//NSMenuItem *mi = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Screen %u",i]
		//											action:@selector(handleDisplayScreenChange:)
		//									 keyEquivalent:@""];
		//[mi setTag:i];
		[popup addItemWithTitle:[NSString stringWithFormat:@"Screen %u",i]
						action:nil 
				 keyEquivalent:@""];
	}
	
	//listen for apple remote events
	remoteControl = [[AppleRemote alloc] initWithDelegate: self];
	[remoteControl startListening: self];
	
	//start the current time timer
	[currentTime startTimer:1];
}

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

/**
 * Handles any actions from the Apple Remote
 */
- (void) sendRemoteButtonEvent: (RemoteControlEventIdentifier) event 
                   pressedDown: (BOOL) pressedDown 
                 remoteControl: (RemoteControl*) remoteControl 
{
    NSLog(@"Button %d pressed down %d", event, pressedDown);
	
	if (!pressedDown) {
		//the button has been released
		switch (event) {
			case kRemoteButtonLeft:
				[self reverseSlides:self];
				break;
			case kRemoteButtonRight:
				[self advanceSlides:self];
				break;
			default:
				break;
		}
	} else {
		//the button is being held down
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
 * Setup all the window components once a slide has been opened
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
	
	//restart the counter
	//set the counter to zero and display
	[counterView setAsCounter:YES];
	[counterView setNeedsDisplay:YES];
	
	//if the display window is open then notify it of the new slides
	[self postSlideObjectChangeNotification];
	[self postSlideChangeNotification];
}

/*
 * Callback - handle a slide change notification
 */
- (void)handleSlideChange:(NSNotification *)note {
	NSLog(@"Nofity Controller: Display Change Notification Recieved");
	NSNumber *slideNum = [[note userInfo] objectForKey:@"SlideNumber"];
	
	//display the slide
	[self displaySlide:[slideNum intValue]];
}

/*
 * Callback - handle a key press notification
 */
- (void)handleKeyPress:(NSNotification *)note {
	NSLog(@"Nofity Controller: Display key pressed");
	[self manageKeyDown:[[[note userInfo] objectForKey:@"KeyCode"] intValue]];
}


/*
 * Post a notification that the slide object has changed
 */
- (void)postSlideObjectChangeNotification {
	//nofity the display that the slide obj has changed
	if (pdfDisplay) {
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		NSLog(@"Notify Controller: Slide Object Changed");
		
		NSDictionary *d = [NSDictionary dictionaryWithObject:slides
													  forKey:@"SlideObject"];
		
		[nc postNotificationName:ControllerSlideObjectNotification
						  object:self
						userInfo:d];
	}
}
	
		
/*
 * Post a notification informating objservers that the slide has changed.
 */
- (void)postSlideChangeNotification {
	//Send a notification to the main window that the slide has changed
	if (pdfDisplay) {
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		NSLog(@"Notify Controller: Slide Changed");
		
		NSDictionary *d = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:[currentSlide slideNumber]] 
																			  forKey:@"SlideNumber"];
		
		[nc postNotificationName:ControllerSlideNumberNotification
						  object:self
						userInfo:d];	
	}
}

/*
 * Post a notification informating objservers that the slide has changed.
 */
- (void)postSlideStopNotification {
	//Send a notification to the main window that the slide has changed
	if (pdfDisplay) {
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		NSLog(@"Notify Controller: Slide Stopped");
		
		[nc postNotificationName:ControllerSlideStopNotification
						  object:self
						userInfo:nil];	
	}
}

/*
 * Play the slide show in the primary or secondary screen
 */
- (IBAction)playSlides:(id)sender {
	//do nothing if the pdfdisplay is already loaded
	//show the display window
	if (!pdfDisplay) {
		//get the selected display window
		pdfDisplay = [[PDFDisplayController alloc] initWithSlidesScreen:slides
																 screen:[displayMenu indexOfSelectedItem]];
	} else {
		return; 
	}
	
	//register as an observer to listen for notifications
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
		   selector:@selector(handleKeyPress:)
			   name:PDFViewKeyPressNotification
			 object:nil];
	NSLog(@"Nofity Controller: Key Press PDFDisplay Notification Observer Registered");
	
	NSLog(@"Showing the PDFDisplay Window");
	[pdfDisplay showWindow:self];
	
	
	//display the current slide
	[self postSlideChangeNotification];
}

/**
 * Stop the slide show and kill the slideshow windoe
 */
- (IBAction)stopSlides:(id)sender {
	//close the display, it is exists, and set to nil
	if (pdfDisplay) {
		//tell the display to exit fullscreen mode
		
		[self postSlideStopNotification];
		[pdfDisplay close];
		pdfDisplay = nil;	//gc will clean up!
		
		//stop the counter
		[counterView stopTimer];
		
		//unregister the notification observer
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc removeObserver:self
					  name:PDFViewKeyPressNotification
					object:nil];
		
		//hint for the garbage collector to run
		NSGarbageCollector *gc = [NSGarbageCollector defaultCollector];
		[gc collectIfNeeded];
	}
}

/*
 * Display a specific slide number
 */
- (void)displaySlide:(NSUInteger)slideNum {
	[currentSlide setSlideNumber:slideNum];
	[nextSlide setSlideNumber:([currentSlide slideNumber]+1)];
	
	//set the level indicator
	if ([pageLevel intValue] < [pageLevel maxValue])
		[pageLevel setIntValue:(slideNum+1)];
	
	//redraw the views
	[currentSlide setNeedsDisplay:YES];
	[nextSlide setNeedsDisplay:YES];
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
	
	//start the counter if needed
	if (![counterView isCounting] && pdfDisplay)
		[counterView startTimer:1];
	
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

	//start the counter if needed only if the display is active
	if (![counterView isCounting] && pdfDisplay)
		[counterView startTimer:1];
	
	[self postSlideChangeNotification];
}

/*
 * Manage the keydown event.
 */
- (void)manageKeyDown:(NSUInteger)keycode {
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
		case 12:
			//q button - stop the slide show
			[self stopSlides:self];
			break;

		default:
			NSLog(@"Keydown Event - %d", keycode);
			break;
	}
}

/*
 *	Handle the keydown events on the main window
 */
- (void)keyDown:(NSEvent *)theEvent {
	unsigned int keycode = [theEvent keyCode];
	[self manageKeyDown:keycode];
}

@end
