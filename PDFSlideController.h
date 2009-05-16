//
//  PDFSlideController.h
//  PDFSlide
//
//  Created by David on 2009/05/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PDFSlideController : NSObject {
	IBOutlet NSWindow *window;
	IBOutlet NSLevelIndicator *pageLevel;
	IBOutlet NSTextView	*tvNotes;
}

- (IBAction)openDocument:(id)sender;

@end
