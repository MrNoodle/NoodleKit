//
//  NSObject-IdleExtensions.m
//  NoodleKit
//
//  Created by Paul Kim on 12/30/07.
//  Copyright 2007-2012 Noodlesoft, LLC. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// nLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NSObject-NoodlePerformWhenIdle.h"
#import <ApplicationServices/ApplicationServices.h>

@implementation NSObject (NoodlePerformWhenIdle)

// Heard somewhere that this prototype may be missing in some cases so adding it here just in case.
CG_EXTERN CFTimeInterval CGEventSourceSecondsSinceLastEventType( CGEventSourceStateID source, CGEventType eventType )  AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER;


// Semi-private method. Used by the public methods
- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterSystemIdleTime:(NSTimeInterval)delay withinTimeLimit:(NSTimeInterval)maxTime startTime:(NSTimeInterval)startTime
{
	CFTimeInterval	idleTime;
	NSTimeInterval	timeSinceInitialCall;	

    timeSinceInitialCall = [NSDate timeIntervalSinceReferenceDate] - startTime;
    
	if (maxTime > 0)
	{
		if (timeSinceInitialCall >= maxTime)
		{
			[self performSelector:aSelector withObject:anArgument];
			return;
		}
	}
	
	idleTime = CGEventSourceSecondsSinceLastEventType(kCGEventSourceStateHIDSystemState, kCGAnyInputEventType);
	if (idleTime < delay)
	{
		NSTimeInterval		fireTime;
		NSMethodSignature	*signature;
		NSInvocation		*invocation;
		
		signature = [self methodSignatureForSelector:@selector(performSelector:withObject:afterSystemIdleTime:withinTimeLimit:startTime:)];
		invocation = [NSInvocation invocationWithMethodSignature:signature];
		[invocation setSelector:@selector(performSelector:withObject:afterSystemIdleTime:withinTimeLimit:startTime:)];
		[invocation setTarget:self];
		[invocation setArgument:&aSelector atIndex:2];
		[invocation setArgument:&anArgument atIndex:3];
		[invocation setArgument:&delay atIndex:4];
		[invocation setArgument:&maxTime atIndex:5];
		[invocation setArgument:&startTime atIndex:6];
		
		fireTime = delay - idleTime;
		if (maxTime > 0)
		{
			fireTime = MIN(fireTime, maxTime - timeSinceInitialCall);
		}
		
		// Not idle for long enough. Set a timer and check back later
		[NSTimer scheduledTimerWithTimeInterval:fireTime invocation:invocation repeats:NO];
	}
	else
	{
		[self performSelector:aSelector withObject:anArgument];
	}
}


- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterSystemIdleTime:(NSTimeInterval)delay
{
	[self performSelector:aSelector withObject:anArgument afterSystemIdleTime:delay withinTimeLimit:-1];
}


- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterSystemIdleTime:(NSTimeInterval)delay withinTimeLimit:(NSTimeInterval)maxTime
{
	SInt32	version;
	
	// NOTE: Even though CGEventSourceSecondsSinceLastEventType exists on Tiger,
	// it appears to hang on some Tiger systems. For now, only enabling for Leopard or later.
	if ((Gestalt(gestaltSystemVersion, &version) == noErr) && (version >= 0x1050))
	{
		NSTimeInterval		startTime;
		
		startTime = [NSDate timeIntervalSinceReferenceDate];
		
		[self performSelector:aSelector withObject:anArgument afterSystemIdleTime:delay withinTimeLimit:maxTime startTime:startTime];
	}
	else
	{
		// For pre-10.5, just call it after a delay. Change this if you want to throw an exception
		// instead.
		[self performSelector:aSelector withObject:anArgument afterDelay:delay];
	}
}


@end
