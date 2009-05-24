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
		viewTime = nil;
	}
    return self;
}

- (void)drawRect:(NSRect)rect {
	//create timer is does not exit
	//display if working with a timer or a counter
	if (timer || viewTime != nil) {		
		NSRect bounds = [self bounds];
		[[NSColor blackColor] set];
		
		if (viewTime == nil)
			//display the current time
			displayTime = [[NSDate date] descriptionWithCalendarFormat:@"%H:%M:%S"
															  timeZone:nil
																locale:nil];
		else {
			//display a counter
			displayTime = [[viewTime addTimeInterval:elapsed] descriptionWithCalendarFormat:@"%H:%M:%S"
														 timeZone:[NSTimeZone timeZoneWithName:@"GMT"]
														   locale:nil];
		}
			
		//Apply the font attributes
		font = [NSFont fontWithName:@"Helvetica"
							   size:40.0];		

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
 * Specifies whether this is a counter or not
 */
- (void)setAsCounter:(BOOL)yesno {
	if (yesno == YES) {
		viewTime = [NSDate dateWithString:@"1970-01-01 00:00:00 +0000"];
	} else {
		viewTime = nil;
	}
	elapsed = 0;
}

/**
 * Start the timer
 */
- (void)startTimer:(NSUInteger)interval {
	if (!timer) {
		timer = [NSTimer scheduledTimerWithTimeInterval:1
												 target:self
											   selector:@selector(handleTimerFire:)
											   userInfo:nil
												repeats:YES];
		elapsed = 0;
	}
}

/**
 * Stop the timer if it exists
 */
- (void)stopTimer {
	if (timer)
		[timer invalidate];
	timer = nil;
	elapsed = 0;
}

/**
 * Returns YES if the timer is active
 */
- (BOOL)isCounting {
	if (timer)
		return YES;
	return NO;
}

- (void)handleTimerFire:(NSTimer*)thetimer {
	if (viewTime != nil)
		elapsed++;
	[self setNeedsDisplay:YES];
}

@end
