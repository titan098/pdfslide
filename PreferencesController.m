//
//  PreferencesController.m
//  PDFSlide
//
//  Created by David on 2009/06/07.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PreferencesController.h"


@implementation PreferencesController

- (void)setupToolbar {
	[self addView:updateView label:@"Updates" image:[NSImage imageNamed:@"Updates.icns"]];
}

@end
