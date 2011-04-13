//
//  NSTimer-NoodleExtensions.m
//  NoodleKit
//
//  Created by Paul Kim on 6/29/10.
//  Copyright 2010 Noodlesoft, LLC. All rights reserved.
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
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NSTimer-NoodleExtensions.h"
#import <objc/runtime.h>
#import "NoodleGlue.h"

#if defined(NS_BLOCKS_AVAILABLE) && (NS_BLOCKS_AVAILABLE == 1)

static char originalDateKey;
static char observerKey;

@implementation NSTimer (NoodleExtensions)

+ (NSTimer *)scheduledTimerWithAbsoluteFireDate:(NSDate *)fireDate target:(id)target selector:(SEL)aSelector userInfo:(id)userInfo
{
	__block NSTimer		*timer;
	
	timer = [[[NSTimer alloc] initWithAbsoluteFireDate:fireDate target:target selector:aSelector userInfo:userInfo] autorelease];
	
	if (timer != nil)
	{
		[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
	}
	return timer;
}

+ (NSTimer *)scheduledTimerWithAbsoluteFireDate:(NSDate *)fireDate block:(NoodleTimerBlock)block
{
	NoodleGlue		*glue;
	
	glue = [NoodleGlue glueWithBlock:
			^(NoodleGlue *blockGlue, id object)
			{
				block(object);
			}];
	
	return [self scheduledTimerWithAbsoluteFireDate:fireDate target:glue selector:@selector(invoke:) userInfo:nil];
}


+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(NoodleTimerBlock)block
{	
	NoodleGlue		*glue;
	
	glue = [NoodleGlue glueWithBlock:
			^(NoodleGlue *blockGlue, id object)
			{
				block(object);
			}];
	
	return [self scheduledTimerWithTimeInterval:seconds target:glue selector:@selector(invoke:) userInfo:nil repeats:repeats];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(NoodleTimerBlock)block
{
	NoodleGlue		*glue;
	
	glue = [NoodleGlue glueWithBlock:
			^(NoodleGlue *blockGlue, id object)
			{
				block(object);
			}];
	
	return [self timerWithTimeInterval:seconds target:glue selector:@selector(invoke:) userInfo:nil repeats:repeats];
}

- (id)initWithAbsoluteFireDate:(NSDate *)date target:(id)target selector:(SEL)aSelector userInfo:(id)userInfo
{
	self = [self initWithFireDate:date interval:0 target:target selector:aSelector userInfo:userInfo repeats:NO];

	if (self != nil)
	{
		__block NSTimer		*blockSelf;
		id					observer;
		
		blockSelf = self;
		objc_setAssociatedObject(self, &originalDateKey, date, OBJC_ASSOCIATION_RETAIN);
		
		// We create a special observer object instead of using self. Since we are doing a category here, we can't 
		// override -invalidate or -dealloc and do proper unregistering from notifications. Instead, we create an
		// intermediary observer that handles the notifications and unregisters itself when it is dealloced. We set
		// this observer as an associated object which is the only place where it is retained.
		// Note that the timer variable used is declared __block so that it is not retained by the block which would
		// result in a retain cycle.
		observer = [NoodleGlue glueWithBlock:
					^(NoodleGlue *glue, id object) {
						[blockSelf setFireDate:(NSDate *)objc_getAssociatedObject(blockSelf, &originalDateKey)];
					}
					cleanupBlock:
					^(NoodleGlue *glue) {
						[[NSNotificationCenter defaultCenter] removeObserver:glue];
						[[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:glue];
					}];
		
		objc_setAssociatedObject(self, &observerKey, observer, OBJC_ASSOCIATION_RETAIN);
		
		[[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(invoke:) name:NSSystemTimeZoneDidChangeNotification object:nil];
		[[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:observer selector:@selector(invoke:) name:NSWorkspaceDidWakeNotification object:nil];
	}
	return self;
}

- (id)initWithAbsoluteFireDate:(NSDate *)date block:(NoodleTimerBlock)block
{
    NoodleGlue      *glue;
    
    glue = [NoodleGlue glueWithBlock:
            ^(NoodleGlue *blockGlue, id object)
            {
                block(object);
            }];
	return [self initWithAbsoluteFireDate:date target:glue selector:@selector(invoke:) userInfo:nil];
}

- (id)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(NoodleTimerBlock)block
{	
    NoodleGlue      *glue;
    
    glue = [NoodleGlue glueWithBlock:
            ^(NoodleGlue *blockGlue, id object)
            {
                block(object);
            }];
	return [self initWithFireDate:date interval:seconds target:glue selector:@selector(invoke:) userInfo:nil repeats:repeats];
}


@end

#endif
