//
//  TimeLabAppDelegate.m
//  TimerLab
//
//  Created by Paul Kim on 6/30/10.
//  Copyright 2010 Noodlesoft, LLC. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

#import "TimerLabAppDelegate.h"
#import <NoodleKit/NSTimer-NoodleExtensions.h>

@implementation TimerLabAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[_picker setObjectValue:[NSDate date]];
	[self syncPickers:_picker];
	
	// We use -delayedRefresh: here instead of refresh: because NSTimer will be watching for these same notifications
	// and we can't guarantee the order in which the observers are notified (we want the refresh to happen after
	// the timer adjusts).
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delayedRefresh:) name:NSSystemTimeZoneDidChangeNotification object:nil];
	[[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(delayedRefresh:) name:NSWorkspaceDidWakeNotification object:nil];
}


- (IBAction)startTimer:(id)sender
{
	NSDate		*date;
	
	date = [NSDate date];
	[_initialDateField setObjectValue:date];
	[_regularInitialDateField setObjectValue:date];
	
	date = [_picker objectValue];
	
	[_initialFireDateField setObjectValue:date];
	[_regularInitialFireDateField setObjectValue:date];
	
	[_absoluteTimer invalidate];
	[_absoluteTimer release];
	_absoluteTimer = [[NSTimer alloc] initWithAbsoluteFireDate:date block:
			  ^ (NSTimer *timer)
			  {
				  [_fireDateField setObjectValue:[NSDate date]];
			  }];
	
	[_fireDateField setObjectValue:nil];
	[_currentFireDateField setObjectValue:[_absoluteTimer fireDate]];
	
	[[NSRunLoop currentRunLoop] addTimer:_absoluteTimer forMode:NSDefaultRunLoopMode];

	[_regularTimer invalidate];
	[_regularTimer release];
	_regularTimer = [[NSTimer alloc] initWithFireDate:date interval:0 repeats:NO block:
					 ^ (NSTimer *timer)
					 {
						 [_regularFireDateField setObjectValue:[NSDate date]];
					 }];

	[_regularFireDateField setObjectValue:nil];	
	[_regularCurrentFireDateField setObjectValue:[_regularTimer fireDate]];

	[[NSRunLoop currentRunLoop] addTimer:_regularTimer forMode:NSDefaultRunLoopMode];
}

- (IBAction)syncPickers:(id)sender
{
	NSDate		*date;
	
	date = [sender objectValue];
	[_picker setObjectValue:date];
	[_datePicker setObjectValue:date];
	[_timePicker setObjectValue:date];
}

- (IBAction)refresh:(id)sender
{
	[_currentFireDateField setObjectValue:[_absoluteTimer fireDate]];
	[_regularCurrentFireDateField setObjectValue:[_regularTimer fireDate]];
}

- (IBAction)delayedRefresh:(id)sender
{
	[self performSelector:@selector(refresh:) withObject:nil afterDelay:1.0];
}


@end
