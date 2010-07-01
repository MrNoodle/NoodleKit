//
//  NSResponder-ModalExtensions.m
//  NoodleKit
//
//  Created by Paul Kim on 3/6/08.
//  Copyright 2008-2009 Noodlesoft, LLC. All rights reserved.
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

#import "NSResponder-NoodleModalExtensions.h"


@implementation NSResponder (NoodleModalExtensions)


- (void)confirmModal:(id)sender
{
	[[self nextResponder] confirmModal:sender];
}
		
- (void)cancelModal:(id)sender
{
	[[self nextResponder] cancelModal:sender];
}

@end

@implementation NSWindow (NoodleModalExtensions)

- (BOOL)stopModalWindowOrSheetWithCode:(NSInteger)returnCode sender:(id)sender
{
	if ([NSApp modalWindow] == self)
	{
		[self orderOut:sender];
		[NSApp stopModalWithCode:returnCode];
		return YES;
	}
	else if ([self isSheet])
	{
		[self orderOut:sender];			
		[NSApp endSheet:self returnCode:returnCode];
		return YES;
	}
	else if ([self attachedSheet] != nil)
	{
		NSWindow	*sheet;
		
		sheet = [self attachedSheet];
		[sheet orderOut:sender];
		[NSApp endSheet:sheet returnCode:returnCode];
	}	
	return NO;
}

- (void)confirmModal:(id)sender
{
	if (![self stopModalWindowOrSheetWithCode:NSOKButton sender:sender])
	{
		[[self nextResponder] confirmModal:sender];
	}
}

- (void)cancelModal:(id)sender
{
	if (![self stopModalWindowOrSheetWithCode:NSCancelButton sender:sender])
	{
		[[self nextResponder] cancelModal:self];
	}
}

@end
