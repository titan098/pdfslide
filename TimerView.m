//
//  TimerView.m
//  PDFSlide
//
//  Created by David on 2009/05/24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TimerView.h"


@implementation TimerView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		timer = nil;
	}
    return self;
}

- (void)drawRect:(NSRect)rect {
	//create timer is does not exit
	if (timer) {		
		NSRect bounds = [self bounds];
		[[NSColor blackColor] set];
		displayTime = [[NSDate date] descriptionWithCalendarFormat:@"%H:%M:%S"
																	timeZone:nil
																	  locale:nil];
		//Apply the font attributes
		font = [NSFont fontWithName:@"Helvetica"
							   size:36.0];		

		fontAttr = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName];
		NSSize fontSize = [displayTime sizeWithAttributes:fontAttr];
		
		//apply a transformation to get the text in the center of the rectangle
		NSAffineTransform *xform = [NSAffineTransform transform];
		CGFloat deltaX = (bounds.size.width - fontSize.width)/2.0;
		CGFloat deltaY = (bounds.size.height - fontSize.height)/2.0;
		[xform translateXBy:deltaX
						yBy:deltaY];
		[xform concat];
		
		//draw only in the space occupied by the font
		bounds.size = fontSize;
		
		[displayTime drawInRect:bounds withAttributes:fontAttr];
		//NSRectFill(bounds);
	}
}

/**
 * Start the timer
 */
- (void)startTimer:(NSUInteger)interval {
	timer = [NSTimer scheduledTimerWithTimeInterval:1
											 target:self
										   selector:@selector(handleTimerFire:)
										   userInfo:nil
											repeats:YES];
}

/**
 * Stop the timer if it exists
 */
- (void)stopTimer {
	if (timer)
		[timer invalidate];
	timer = nil;
}

- (void)handleTimerFire:(NSTimer*)thetimer {
	[self setNeedsDisplay:YES];
}

@end
