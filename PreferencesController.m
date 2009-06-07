//
//  PreferencesController.m
//  PDFSlide
//
//  Created by David on 2009/06/07.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PreferencesController.h"


@implementation PreferencesController

/**
 * Initilises this window
 */
- (id) init
{
	self = [super init];
	if (self != nil) {
		//init
		[NSBundle loadNibNamed:@"Preferences" owner:self];
	}
	return self;
}

/**
 * Closes the window
 */
- (IBAction)closeWindow:(id)sender {
	[window close];
}

/**
 * Returns the NSWindow assosiated with this object
 */
- (NSWindow*)window {
	return window;
}

@end
