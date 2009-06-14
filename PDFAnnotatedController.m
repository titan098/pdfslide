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


#pragma mark Actions

/**
 * cleanup close the window
 */
- (IBAction)closeWindow:(id)sender {
	[[self window] close];
	[NSApp stopModal];
	//[NSApp endSheet:[self window]];
}

@end
