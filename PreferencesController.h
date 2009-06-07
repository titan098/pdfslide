//
//  PreferencesController.h
//  PDFSlide
//
//  Created by David on 2009/06/07.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PreferencesController : NSObject {
	IBOutlet NSWindow *window;
	IBOutlet NSView *generalView;
}

- (IBAction)closeWindow:(id)sender;

- (NSWindow*)window;
@end
