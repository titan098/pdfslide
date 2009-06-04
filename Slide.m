//
//  Slide.m
//  PDFSlide
//
//  Created by David on 2009/05/17.
//  Copyright 2009 David Ellefsen. All rights reserved.
//

#import "Slide.h"


@implementation Slide

//initialse the Slide object with a pdf
- (id)initWithURL:(NSURL *)url {
	if (![super init])
		return nil;
	
	document = [[PDFDocument alloc] initWithURL:url];
	return self;
}

//opens a PDF document
- (void)openPDF:(NSString *)filename {
	document = [[PDFDocument alloc] initWithURL:[NSURL fileURLWithPath:filename]];
}

/**
 * Return YES if the pdf is encrypted
 */
- (BOOL) isEncrypted {
	return [document isEncrypted];
}

/**
 * Returns YES if the pdf ls locked
 */
- (BOOL) isLocked {
	return [document isLocked];
}

/**
 * Decrypt the pdf with a password
 */
- (BOOL) decryptPDF:(NSString *)password {
	return [document unlockWithPassword:password];
}

//Gets the page count for the PDF Document
- (NSUInteger)pageCount {
	return [document pageCount];
}

//return the PDFPage listed at the current index
- (PDFPage *)pageAtIndex:(NSUInteger)index {
	PDFPage *page = [document pageAtIndex:index];
	return page;
}

@end
