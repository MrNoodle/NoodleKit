//
//  Controller.m
//
//  Created by Paul Kim on 8/21/09.
//  Copyright 2009 Noodlesoft, LLC. All rights reserved.
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
//

#import "Controller.h"

@implementation Controller

- (void)awakeFromNib
{
	NSString		*fileContents;
	NSUInteger		i, count;
	NSString		*temp, *prefix, *currentPrefix;
	NSArray			*words;
	
	fileContents = [NSString stringWithContentsOfFile:@"/usr/share/dict/propernames" usedEncoding:NULL error:NULL];
	words = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	
	[self willChangeValueForKey:@"names"];
	
	words = [words sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	_names = [[NSMutableArray alloc] init];
	
	count = [words count];
	currentPrefix = nil;
	for (i = 0; i < count; i++)
	{
		temp = [words objectAtIndex:i];
		
		if ([temp length] > 0)
		{
			prefix = [temp substringToIndex:1];
			
			if ((currentPrefix == nil) || 
				([currentPrefix caseInsensitiveCompare:prefix] != NSOrderedSame))
			{
				currentPrefix = [prefix uppercaseString];
				[_names addObject:currentPrefix];
			}
			[_names addObject:temp];
		}
	}

	[_stickyRowTableView reloadData];
	[_iPhoneTableView reloadData];
}

- (BOOL)_isHeader:(NSInteger)rowIndex
{
	return ((rowIndex == 0) ||
			[[[_names objectAtIndex:rowIndex] substringToIndex:1] caseInsensitiveCompare:[[_names objectAtIndex:rowIndex - 1] substringToIndex:1]] != NSOrderedSame);
}

#pragma mark NSTableDataSource methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return [_names count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	return [_names objectAtIndex:rowIndex];
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
	return [self _isHeader:row];
}

@end
