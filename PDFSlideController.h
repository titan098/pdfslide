//
//  PDFSlideController.h
//  PDFSlide
//
//  Created by David on 2009/05/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Slide.h"

@interface PDFSlideController : NSObject {
	IBOutlet NSWindow *window;
	IBOutlet NSLevelIndicator *pageLevel;
	IBOutlet NSTextView	*tvNotes;
	
	Slide *slides;
}

- (void)openPanelDidEnd:(NSOpenPanel *)openPanel returnCode:(int)returnCode	contextInfo:(void *)x;
- (IBAction)openDocument:(id)sender;

- (void)initiliseWindow;

@end
