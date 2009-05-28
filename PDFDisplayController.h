//
//  PDFDisplayController.h
//  PDFSlide
//
//  Created by David on 2009/05/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Slide.h"
#import "PDFSlideView.h"
#import "PDFSlideController.h"

//define notifications
extern NSString * const DisplaySlideNumberNotification;

@class PDFSlideController;

@interface PDFDisplayController : NSWindowController {
	IBOutlet PDFSlideView *pdfSlides;
	
	Slide *slides;
	NSUInteger displayScreen;
	CGDisplayFadeReservationToken displayFadeToken;
}

- (id)init;
- (id)initWithSlidesScreen:(id)slidesObj screen:(NSUInteger)screen;
- (void)dealloc;

- (void)switchFullScreen;

- (void)handleSlideChange:(NSNotification *)note;
- (void)handleSlideObjChange:(NSNotification *)note;
- (void)handleSlideStop:(NSNotification *)note;

- (void)postSlideChangeNotification; 
- (void)postKeyPressedNotification:(NSUInteger)keycode;

- (IBAction)advanceSlides:(id)sender;
- (IBAction)reverseSlides:(id)sender;

- (void)setSlideNumber:(NSUInteger)num;
- (void)redrawSlide;

@end
