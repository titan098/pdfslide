//
//  AboutController.h
//  PDFSlide
//
//  Created by David on 2009/05/29.
//  Copyright 2009 David Ellefsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AboutController : NSWindowController {
	IBOutlet NSTextField *productName;
	IBOutlet NSTextField *versionNumber;
	IBOutlet NSTextField *copyrightInfo;
	IBOutlet NSImageView *productIcon;
	IBOutlet NSTextView *credits;
}

@end
