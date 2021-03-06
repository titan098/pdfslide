//
//  PDFSlideController.h
//  PDFSlide
//
//  Created by David on 2009/05/16.
//  Copyright 2009 David Ellefsen. All rights reserved.
//
// This file is part of PDFSlide.
//
// PDFSlide is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// PDFSlide is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with PDFSlide.  If not, see <http://www.gnu.org/licenses/>.
//

#import <Cocoa/Cocoa.h>
#import "AppleRemote/AppleRemote.h"
#import "PSSlide.h"
#import "PDFSlideView.h"
#import "PDFSlideAnnotatedView.h"
#import "PSTimerView.h"
#import "PDFDisplayController.h"
#import "PDFAboutController.h"
#import "PDFPreferencesController.h"
#import "PDFAnnotatedController.h"

//define notifications
extern NSString * const ControllerSlideNumberNotification;
extern NSString * const ControllerSlideObjectNotification;
extern NSString * const ControllerSlideStopNotification;

@interface PDFSlideController : NSWindowController {
	//IBOutlet NSWindow *window;
	IBOutlet NSLevelIndicator *pageLevel;
	IBOutlet NSTextView	*tvNotes;
	IBOutlet NSPopUpButton *displayMenu;
	
	IBOutlet PSTimerView *currentTime;
	IBOutlet PSTimerView *counterView;
	IBOutlet PDFSlideView *currentSlide;
	IBOutlet PDFSlideView *nextSlide;
	
	IBOutlet NSWindow* PDFPasswordWindow;
	IBOutlet NSSecureTextField* pdfPassword;
	
	IBOutlet NSButton* annotatedButton;
	
	PSSlide *slides;
	NSWindowController *pdfDisplay;
	PDFAboutController *aboutWindow;
	
	PDFAnnotatedController *annotatedWindow;
	
	AppleRemote* remoteControl;

	BOOL faded;
}

- (void)dealloc;

- (void) showEncryptedSheet;
- (IBAction) endEncryptedSheet:(id)sender;

- (BOOL)performOpenPDF:(NSString *)filename;
- (IBAction)openDocument:(id)sender;

- (IBAction)showAboutWindow:(id)sender;
- (IBAction)showPreferencesWindow:(id)sender;

/*- (void)endAnnotatedSheet:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;*/
- (IBAction)showAnnotateWindow:(id)sender;

- (void)initiliseWindow;

- (void)fadeOut;
- (void)fadeIn;

- (IBAction)playSlides:(id)sender;
- (IBAction)stopSlides:(id)sender;

- (void)displaySlide:(NSUInteger)slideNum;
- (IBAction)detectDisplays:(id)sender;
- (IBAction)advanceSlides:(id)sender;
- (IBAction)reverseSlides:(id)sender;

- (void)handleSlideChange:(NSNotification *)note;
- (void)handleKeyPress:(NSNotification *)note;

- (void)postSlideChangeNotification;
- (void)postSlideObjectChangeNotification;
- (void)postSlideStopNotification;

- (void)manageKeyDown:(NSUInteger)keycode;
- (void)keyDown:(NSEvent *)theEvent;

@end
