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
		NSDate* now = [NSDate date];
		
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
