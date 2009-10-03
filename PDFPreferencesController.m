//
//  PreferencesController.m
//  PDFSlide
//
//  Created by David on 2009/06/07.
//  Copyright 2009 David Ellefsen. All rights reserved.
//
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

#import "PDFPreferencesController.h"


@implementation PDFPreferencesController

/*
 * Set up the views on the toolbar
 */
- (void)setupToolbar {
	[self addView:generalView label:@"General" image:[NSImage imageNamed:@"NSPreferencesGeneral"]];
	[self addView:annotateView label:@"Annotate" image:[NSImage imageNamed:@"PSAnnotate.icns"]];
	[self addView:updateView label:@"Updates" image:[NSImage imageNamed:@"PSUpdate.icns"]];
}

/*
 * Setup the controls
 */
-(void) awakeFromNib {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	//setup the shortcut recorders
	KeyCombo advanceSRKeys, previousSRKeys, fadeSRKeys, stopSRKeys;
	advanceSRKeys.code = [defaults integerForKey:@"PSAdvanceKey"];
	advanceSRKeys.flags = [defaults integerForKey:@"PSAdvanceKeyFlags"];
	previousSRKeys.code = [defaults integerForKey:@"PSPreviousKey"];
	previousSRKeys.flags = [defaults integerForKey:@"PSPreviousKeyFlags"];
	fadeSRKeys.code = [defaults integerForKey:@"PSFadeKey"];
	fadeSRKeys.flags = [defaults integerForKey:@"PSFadeKeyFlags"];
	stopSRKeys.code = [defaults integerForKey:@"PSStopKey"];
	stopSRKeys.flags = [defaults integerForKey:@"PSStopKeyFlags"];
	
	[advanceRecorder setKeyCombo:advanceSRKeys];
	[previousRecorder setKeyCombo:previousSRKeys];
	[fadeRecorder setKeyCombo:fadeSRKeys];
	[stopRecorder setKeyCombo:stopSRKeys];
	
	//set the options for the shortcut Recorders
	[advanceRecorder setAllowsKeyOnly:TRUE escapeKeysRecord:TRUE];
	[previousRecorder setAllowsKeyOnly:TRUE escapeKeysRecord:TRUE];
	[fadeRecorder setAllowsKeyOnly:TRUE escapeKeysRecord:TRUE];
	[stopRecorder setAllowsKeyOnly:TRUE escapeKeysRecord:TRUE];
	
	//set the delegates for the Shortcut Recorders
	[advanceRecorder setDelegate:self];
	[previousRecorder setDelegate:self];
	[fadeRecorder setDelegate:self];
	[stopRecorder setDelegate:self];
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo {
	NSString *SRPreferenceCode = @"";
	NSString *SRPreferenceFlags = @"";
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	//set preference for approperate recorder
	if (aRecorder == advanceRecorder) SRPreferenceCode = @"PSAdvanceKey";
	if (aRecorder == previousRecorder) SRPreferenceCode = @"PSPreviousKey";
	if (aRecorder == fadeRecorder) SRPreferenceCode = @"PSFadeKey";
	if (aRecorder == stopRecorder) SRPreferenceCode = @"PSStopKey";
	SRPreferenceFlags = [SRPreferenceCode stringByAppendingString:@"Flags"];
	
	//save the key in shared preferences
	[defaults setInteger:newKeyCombo.code forKey:SRPreferenceCode];
	[defaults setInteger:newKeyCombo.flags forKey:SRPreferenceFlags];
}

@end
