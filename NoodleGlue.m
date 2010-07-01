//
//  NoodleBlockAction.m
//  NoodleKit
//
//  Created by Paul Kim on 6/30/10.
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

#import "NoodleGlue.h"

#if defined(NS_BLOCKS_AVAILABLE) && (NS_BLOCKS_AVAILABLE == 1)


@implementation NoodleGlue

+ (NoodleGlue *)glueWithBlock:(NoodleGlueBlock)glueBlock
{
	return [self glueWithBlock:glueBlock cleanupBlock:nil];
}

+ (NoodleGlue *)glueWithBlock:(NoodleGlueBlock)glueBlock cleanupBlock:(NoodleGlueCleanupBlock)cleanupBlock
{
	return [[[NoodleGlue alloc] initWithBlock:glueBlock cleanupBlock:cleanupBlock] autorelease];
}

- (id)initWithBlock:(NoodleGlueBlock)glueBlock cleanupBlock:(NoodleGlueCleanupBlock)cleanupBlock
{
	if ((self = [super init]) != nil)
	{
		_glueBlock = [glueBlock copy];
		_cleanupBlock = [cleanupBlock copy];
	}
	return self;
}

- (void)dealloc
{
	if (_cleanupBlock != NULL)
	{
		_cleanupBlock(self);
	}
	
	[_glueBlock release];
	[_cleanupBlock release];
	
	[super dealloc];
}

- (void)finalize
{
	if (_cleanupBlock != NULL)
	{
		_cleanupBlock(self);
	}
	
	[super finalize];
}

- (void)invoke:(id)object
{
	_glueBlock(self, object);
}


@end

#endif
