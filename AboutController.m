//
//  AboutController.m
//  PDFSlide
//
//  Created by David on 2009/05/29.
//  Copyright 2009 David Ellefsen. All rights reserved.
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
