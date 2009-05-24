//
//  TimerView.h
//  PDFSlide
//
//  Created by David on 2009/05/24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TimerView : NSView {
	NSTimer* timer;
}

- (void)startTimer:(NSUInteger)interval;
- (void)stopTimer;
- (void)handleTimerFire:(NSTimer*)thetimer;

@end
