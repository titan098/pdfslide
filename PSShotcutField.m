//
//  PSShotcutKey.m
//  PDFSlide
//
//  Created by David Ellefsen on 2009/09/30.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PSShotcutField.h"


@implementation PSShotcutField

-(void)keyUp:(NSEvent *)theEvent {
	NSUInteger modifier = [theEvent modifierFlags];
	NSString *str = [theEvent charactersIgnoringModifiers];
	
	unichar keyCode = [str characterAtIndex:0];
}

@end
