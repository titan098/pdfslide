//
//  AboutController.m
//  PDFSlide
//
//  Created by David on 2009/05/29.
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

#import "AboutController.h"


@implementation AboutController

- (id)init {
	if (![super initWithWindowNibName:@"About"])
		return nil;
	return self;
}

- (void)dealloc {
	[super dealloc];
}

/**
 * Gets executed when the window loads
 */
- (void)windowDidLoad {
	NSBundle* bundle = [NSBundle mainBundle];
	NSString* creditsPath = [bundle pathForResource:@"Credits" ofType:@"rtf"];
	NSString* productIconPath = [[bundle infoDictionary] objectForKey:@"CFBundleIconFile"];
	
	[productName setStringValue:[[bundle infoDictionary] objectForKey:(NSString *)kCFBundleNameKey]];
	[versionNumber setStringValue:[@"Version " stringByAppendingString:
								   [[bundle infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]]];
	[copyrightInfo setStringValue:[[bundle infoDictionary] objectForKey:(NSString *)@"NSHumanReadableCopyright"]];
	[productIcon setImage:[[NSImage alloc] initWithContentsOfFile:productIconPath]];
	[credits readRTFDFromFile:creditsPath];
}

@end
