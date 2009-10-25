//
//  Controller.m
//  NoodleKit
//
//  Created by Paul Kim on 10/21/09.
//  Copyright 2009 Noodlesoft, LLC. All rights reserved.
//
//  Created by Paul Kim on 10/20/09.
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

#import "Controller.h"
#import "NoodleTableView.h"

#define ARTIST_KEY		@"artist"
#define ARTWORK_KEY		@"artwork"
#define ALBUM_KEY		@"album"
#define SONGCOUNT_KEY	@"songCount"

@implementation Controller


//@synthesize window;
@synthesize entries = _entries;

- (void)awakeFromNib
{
	[_tableView setIntercellSpacing:NSMakeSize(0.0, 0.0)];
	[_tableView setShowsStickyRowHeader:YES];
	[_tableView setRowSpanningEnabledForCapableColumns:YES];
	_number = [NSNumber numberWithInt:5];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	_entries = [[NSArray alloc] initWithObjects:
				[NSDictionary dictionaryWithObjectsAndKeys:
				 @"Mr Disco", ARTIST_KEY,
				 [NSImage imageNamed:NSImageNameFolderBurnable], ARTWORK_KEY,
				 @"Burn Baby Burn", ALBUM_KEY,
				 [NSNumber numberWithInteger:9], SONGCOUNT_KEY, nil],
				[NSDictionary dictionaryWithObjectsAndKeys:
				 @"Pierre LeMac", ARTIST_KEY,
				 [NSImage imageNamed:NSImageNameBonjour], ARTWORK_KEY,
				 @"Bonjour Ma Cherie", ALBUM_KEY,
				 [NSNumber numberWithInteger:13], SONGCOUNT_KEY, nil],
				[NSDictionary dictionaryWithObjectsAndKeys:
				 @"M.C. Mac", ARTIST_KEY,
				 [NSImage imageNamed:NSImageNameDotMac], ARTWORK_KEY,
				 @"Dot Mackin'", ALBUM_KEY,
				 [NSNumber numberWithInteger:7], SONGCOUNT_KEY, nil],
				[NSDictionary dictionaryWithObjectsAndKeys:
 				 @"M.C. Mac", ARTIST_KEY,
				 [NSImage imageNamed:NSImageNameFolderSmart], ARTWORK_KEY,
				 @"You Think You're So Smart", ALBUM_KEY,
				 [NSNumber numberWithInteger:14], SONGCOUNT_KEY, nil],
				[NSDictionary dictionaryWithObjectsAndKeys:
				 @"ComputerHead", ARTIST_KEY,
				 [NSImage imageNamed:NSImageNameComputer], ARTWORK_KEY,
				 @"Cancel Computer", ALBUM_KEY,
				 [NSNumber numberWithInteger:12], SONGCOUNT_KEY, nil],
				nil];
	
	[(NoodleTableColumn *)[_tableView tableColumnWithIdentifier:@"Album"] setRowSpanningEnabled:NO];
	[_tableView reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return [[_entries valueForKeyPath:@"@sum.songCount"] integerValue];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	NSInteger		tally, songCount;
	id				identifier;
	
	tally = 0;
	identifier = [aTableColumn identifier];
	for (NSDictionary *dict in _entries)
	{
		songCount = [[dict objectForKey:SONGCOUNT_KEY] integerValue];
		
		if (rowIndex < tally + songCount)
		{
			if ([identifier isEqual:@"Artwork"])
			{
				return [dict objectForKey:ARTWORK_KEY];
			}
			else if ([identifier isEqual:@"Album"])
			{
				return [dict objectForKey:ALBUM_KEY];
			}
			else if ([identifier isEqual:@"Artist"])
			{
				return [dict objectForKey:ARTIST_KEY];
			}
			else if ([identifier isEqual:@"Song"])
			{
				return [NSString stringWithFormat:@"Song #%d", rowIndex - tally + 1];
			}
		}
		tally += songCount;
	}
	return nil;
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn
{
	if ([[tableColumn identifier] isEqual:@"Album"])
	{
		[(NoodleTableColumn *)tableColumn setRowSpanningEnabled:![(NoodleTableColumn *)tableColumn isRowSpanningEnabled]];
		[_tableView reloadData];
	}
}

- (BOOL)tableView:(NSTableView *)tableView isStickyRow:(NSInteger)row
{
	id				value, newValue;
	NSTableColumn	*column;
	
	column = [tableView tableColumnWithIdentifier:@"Artist"];
	value = [self tableView:tableView objectValueForTableColumn:column row:row];
	
	if (row > 0)
	{
		newValue = [self tableView:tableView objectValueForTableColumn:column row:row - 1];
		if (![value isEqual:newValue])
		{
			return YES;
		}
		return NO;
	}
	return YES;
}

- (BOOL)tableView:(NSTableView *)tableView shouldDisplayCellInStickyRowHeaderForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex
{
	return [[tableColumn identifier] isEqual:@"Artist"];
}

@end
