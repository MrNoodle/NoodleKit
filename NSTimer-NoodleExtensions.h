//
//  NSTimer-NoodleExtensions.h
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

#import <Cocoa/Cocoa.h>

#if defined(NS_BLOCKS_AVAILABLE) && (NS_BLOCKS_AVAILABLE == 1)

typedef void	(^NoodleTimerBlock)(NSTimer *timer);


@interface NSTimer (NoodleExtensions)

/*
 Creates and schedules a timer which will *not* adjust its fire date when the machine is put to sleep or if the clock
 is changed. It will fire on the given date to the best of its abilities. If the time has somehow passed (the fire date
 occurred when the machine was asleep or the clock was suddenly set to a time past the fire time), the timer will fire
 immediately upon wake/clock change.
 
 Note that calling -setFireTime: may not work properly on this timer. A new timer should be created if you wish to have
 it fire at a different time after initial creation.
 
 For more details, check out the related blog post at http://www.noodlesoft.com/blog/2010/07/01/playing-with-nstimer/
 */
+ (NSTimer *)scheduledTimerWithAbsoluteFireDate:(NSDate *)fireDate target:(id)target selector:(SEL)aSelector userInfo:(id)userInfo;
+ (NSTimer *)scheduledTimerWithAbsoluteFireDate:(NSDate *)fireDate block:(NoodleTimerBlock)block;


+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(NoodleTimerBlock)block;

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(NoodleTimerBlock)block;

- (id)initWithAbsoluteFireDate:(NSDate *)date target:(id)target selector:(SEL)aSelector userInfo:(id)userInfo;

- (id)initWithAbsoluteFireDate:(NSDate *)date block:(NoodleTimerBlock)block;

- (id)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(NoodleTimerBlock)block;

@end

#endif
