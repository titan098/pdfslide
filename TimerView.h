//
//  TimerView.h
//  PDFSlide
//
//  Created by David on 2009/05/24.
//  Copyright 2009 David Ellefsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TimerView : NSView {
	NSFont* font;
	NSTimer* timer;
	
	NSUInteger elapsed;
	NSString* displayTime;
	NSDictionary* fontAttr;
	NSDate* viewTime;
}

- (void)setAsCounter:(BOOL)yesno;

- (void)startTimer:(NSUInteger)interval;
- (void)stopTimer;

- (BOOL)isCounting;

- (void)handleTimerFire:(NSTimer*)thetimer;

@end
