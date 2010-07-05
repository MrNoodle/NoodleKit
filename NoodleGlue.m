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
#import <objc/runtime.h>

#if defined(NS_BLOCKS_AVAILABLE) && (NS_BLOCKS_AVAILABLE == 1)


@implementation NoodleGlue

@synthesize glueBlock = _glueBlock;
@synthesize cleanupBlock = _cleanupBlock;

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


@implementation NSObject (NoodleCleanupGlue)

static char cleanupGlueKey;

- (id)addCleanupBlock:(void (^)(id object))block
{
	NSMutableDictionary	*glueTable;
	NoodleGlue			*glue;
	__block __weak id	blockSelf;
	id					key;
	
	blockSelf = self;
	glue = [[NoodleGlue alloc] initWithBlock:nil
						cleanupBlock:
			^(NoodleGlue *glue)
			{
				block(blockSelf);
			}];
	
	
	glueTable = objc_getAssociatedObject(self, &cleanupGlueKey);
	
	if (glueTable == nil)
	{
		glueTable = [NSMutableDictionary dictionary];
		objc_setAssociatedObject(self, &cleanupGlueKey, glueTable, OBJC_ASSOCIATION_RETAIN);
	}
	
	key = [NSString stringWithFormat:@"%p", glue];
	[glueTable setObject:glue forKey:key];
	
	[glue release];
	
	return key;
}

- (void)removeCleanupBlock:(id)identifier
{
	NSMutableDictionary		*glueTable;
	
	glueTable = objc_getAssociatedObject(self, &cleanupGlueKey);
	
	if (glueTable != nil)
	{
		NoodleGlue		*glue;
		
		glue = [glueTable objectForKey:identifier];
		
		// Clear the cleanup block since we don't want it to be invoked when it gets released when it's removed
		// from the table
		[glue setCleanupBlock:nil];
		[glueTable removeObjectForKey:identifier];
		
		if ([glueTable count] == 0)
		{
			objc_setAssociatedObject(self, &cleanupGlueKey, nil, OBJC_ASSOCIATION_RETAIN);
		}
	}
}

@end
						 

#endif
