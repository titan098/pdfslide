//
//  PDFAnnotatedController.m
//  PDFSlide
//
//  Created by David on 2009/06/14.
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

#import "PDFAnnotatedController.h"

@implementation PDFAnnotatedController

- (id) init
{
	self = [super initWithWindowNibName:@"Annotate"];
	if (self != nil) {
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}

/**
 * Setup all the window components
 */
- (void)windowDidLoad {
	//This view can send annotations to a reciever
	[annotatedView setCanSendNotifications:YES];
}

/**
 * Load the window and set the preferences
 * @return The window object assosiated with this controller
 */
- (NSWindow*)window {
	NSWindow* win = [super window];
	if (!win)
		return nil;
		
	//set the preferences
	NSUserDefaults *sharedDefaults = [NSUserDefaults standardUserDefaults];
	
	//set the pointer size and style
	NSUInteger pointerSize = [sharedDefaults integerForKey:@"PSPointerSize"];
	[annotatedView setPointerSize:pointerSize];	
	[annotatedView setPointerStyle:[sharedDefaults integerForKey:@"PSPointerStyle"]];
	[annotatedView setPenSize:[sharedDefaults integerForKey:@"PSAnnotatePenSize"]];
	[annotatedView setAnnotationTool:[sharedDefaults integerForKey:@"PSAnnotateTool"]];
	
	return win;
}

/**
 * Redraw the slide in the view
 */
- (void)redraw {
	[annotatedView setNeedsDisplay:YES];
}

#pragma mark Actions

/**
 * See the annotation tool based on the index of the segment
 */
- (IBAction)choosePointerTool:(id)sender {
	switch ([annotateTool selectedSegment]) {
		case 0:
			//The pointer was selected
			[annotatedView setAnnotationTool:ANNOTATE_POINTER];
			break;
		case 1:
			[annotatedView setAnnotationTool:ANNOTATE_PEN];
			break;
		default:
			break;
	}
}

/**
 * The colour of the tool was changed
 */
- (IBAction)toolColourChanged:(id)sender {
	[annotatedView setToolColour:[toolColour color]];
}

/**
 * Instruct the view to clear the paths and refresh
 */
- (IBAction)clearPaths:(id)sender {
	[annotatedView clearPaths];
}

/**
 * cleanup close the window
 */
- (IBAction)closeWindow:(id)sender {
	[[self window] close];
	//[NSApp stopModal];
	[NSApp endSheet:[self window]];
}

#pragma mark Slide Control

- (void)setSlides:(Slide*)slides slideNumber:(NSUInteger)slideNumber {
	[annotatedView setSlide:slides];
	[annotatedView setSlideNumber:slideNumber];
}

- (void)setSlideNumber:(NSUInteger)slideNumber {
	[annotatedView setSlideNumber:slideNumber];
}

@end
