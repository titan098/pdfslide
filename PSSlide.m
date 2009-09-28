//
//  Slide.m
//  PDFSlide
//
//  Created by David on 2009/05/17.
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

#import "PSSlide.h"


@implementation PSSlide

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
