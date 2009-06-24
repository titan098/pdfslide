//
//  PSBezierPath.h
//  PDFSlide
//
//  Created by David on 2009/06/24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PSBezierPath : NSBezierPath {
	NSColor *colour;
}

@property(copy) NSColor* colour;

@end
