//
//  PDFDisplayController.h
//  PDFSlide
//
//  Created by David on 2009/05/17.
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
