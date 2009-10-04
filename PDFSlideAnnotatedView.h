//
//  PDFSlideAnnotatedView.h
//  PDFSlide
//
//  Created by David on 2009/06/13.
//  Copyright 2009 David Ellefsen. All rights reserved.
//
// This file is part of PDFSlide.
//
// PDFSlide is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// PDFSlide is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with PDFSlide.  If not, see <http://www.gnu.org/licenses/>.
//

#import <Cocoa/Cocoa.h>
#import "PDFSlideView.h"
#import "PSBezierPath.h"

//define the type of annotation
#define ANNOTATE_POINTER 0
#define ANNOTATE_PEN 1

//define pointer styles
#define ANNOTATE_POINTER_STYLE_CIRCLE 0
#define ANNOTATE_POINTER_STYLE_SQUARE 1

//set a notification string
extern NSString * const AnnotationNotification;

@interface PDFSlideAnnotatedView : PDFSlideView {
	NSUInteger annotationTool;
	
	NSColor* toolColour;
	
	NSRect pointerLocation;
	NSUInteger pointerStyle;
	BOOL showPointer;
	
	NSMutableDictionary* pathDict;
	NSUInteger penSize;
	
	BOOL refresh;
	BOOL clear;
	BOOL sendPath;
	BOOL canSendNotifications;
	BOOL canRecieveNotifications;
}

@property(readwrite) NSUInteger penSize;
@property(readwrite) NSUInteger annotationTool;
@property(readwrite) NSUInteger pointerStyle;
@property(readwrite) BOOL showPointer;

#pragma mark Tool Methods

- (void)setToolColour:(NSColor*) colour;
- (void)setPointerLocation:(NSPoint)pointer;
- (void)setPointerSize:(NSUInteger)size;

- (NSMutableArray *)newPath;
- (NSRect)currentPathBounds;
- (BOOL)addPointToPath:(NSPoint)point;
- (void)clearPaths;

#pragma mark Notification Methods
- (void)setCanSendNotifications:(BOOL) yesno;
- (void)setCanRecieveNotifications:(BOOL) yesno;

- (void)postAnnotationNotification;
- (void)handleAnnotationNotification:(NSNotification *)note;

@end
