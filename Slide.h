//
//  Slide.h
//  PDFSlide
//
//  Created by David on 2009/05/17.
//  Copyright 2009 David Ellefsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface Slide : NSObject {
	PDFDocument *document;
}

- (id)initWithURL:(NSURL *)url;

- (void)openPDF:(NSString *)filename;
- (BOOL)isEncrypted;
- (BOOL)isLocked;
- (BOOL)decryptPDF:(NSString *)password;
- (NSUInteger)pageCount;
- (PDFPage *)pageAtIndex:(NSUInteger)index;

@end
