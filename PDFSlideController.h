//
//  PDFSlideController.h
//  PDFSlide
//
//  Created by David on 2009/05/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Slide.h"
#import "PDFSlideView.h"
#import "PDFDisplayController.h"

//define notifications
extern NSString * const ControllerSlideNumberNotification;
extern NSString * const ControllerRedrawSlideNotification;

@interface PDFSlideController : NSWindowController {
	//IBOutlet NSWindow *window;
	IBOutlet NSLevelIndicator *pageLevel;
	IBOutlet NSTextView	*tvNotes;
	
	IBOutlet PDFSlideView *currentSlide;
	IBOutlet PDFSlideView *nextSlide;
	
	Slide *slides;
	PDFSlideController *pdfDisplay;
}

- (void)dealloc;

- (void)openPanelDidEnd:(NSOpenPanel *)openPanel returnCode:(int)returnCode	contextInfo:(void *)x;
- (IBAction)openDocument:(id)sender;

- (void)initiliseWindow;

- (IBAction)playSlides:(id)sender;
- (void)displaySlide:(NSUInteger)slideNum;
- (IBAction)advanceSlides:(id)sender;
- (IBAction)reverseSlides:(id)sender;

- (void)postSlideChangeNotification;

- (void)keyDown:(NSEvent *)theEvent;

@end
