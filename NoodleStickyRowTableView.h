//
//  NoodleStickyRowTableView.h
//  NoodleKit
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

#import <Cocoa/Cocoa.h>

/*
 Categories and subclasses that provide "sticky" header rows.
 
 For more details, see the related blog post at http://www.noodlesoft.com/blog/2009/09/25/sticky-section-headers-in-nstableview/
 */

typedef NSUInteger		NoodleStickyRowTransition;

enum
{
	NoodleStickyRowTransitionNone,
	NoodleStickyRowTransitionFadeIn
};

@interface NoodleStickyRowTableView : NSTableView
{
}

@end

@interface NoodleStickyRowOutlineView : NSOutlineView
{
}

@end

/*
 The bulk of this is implemented in categories. This is so (a) it can be easily
 integrated into your own subclass and (b) it can be easily used in subclasses
 of NSOutlineView without copying and pasting large chunks of code.
 */
@interface NSTableView (NoodleStickyRowExtensions)

/*
 Currently set to any groups rows (as dictated by the delegate). The
 delegate can implement -tableView:isStickyRow: to override this.
 */
- (BOOL)isRowSticky:(NSInteger)rowIndex;

/*
 Does the actual drawing of the sticky row. Override if you want a custom look.
 You shouldn't invoke this directly. See -drawStickyRowHeader.
 */
- (void)drawStickyRow:(NSInteger)row clipRect:(NSRect)clipRect;

/*
 Draws the sticky row at the top of the table. You have to override -drawRect 
 and call this method, that being all you need to get the sticky row stuff
 to work in your subclass. Look at NoodleStickyRowTableView.
 Note that you shouldn't need to override this. To modify the look of the row,
 override -drawStickyRow: instead.
 */
- (void)drawStickyRowHeader;

/*
 Returns the rect of the sticky view header. Will return NSZeroRect if there is no current
 sticky row.
 */
- (NSRect)stickyRowHeaderRect;

/*
 Does an animated scroll to the current sticky row. Clicking on the sticky
 row header will trigger this.
 */
- (IBAction)scrollToStickyRow:(id)sender;

/*
 Returns what kind of transition you want when the row becomes sticky. Fade-in 
 is the default.
 */
- (NoodleStickyRowTransition)stickyRowHeaderTransition;

@end

@interface NSOutlineView (NoodleStickyRowExtensions)

/*
 Currently set to any groups rows (or as dictated by the delegate). The
 delegate can implement -outlineView:isStickyRow: to override this.
 */
- (BOOL)isRowSticky:(NSInteger)rowIndex;

@end

@interface NSObject (NoodleStickyRowDelegate)

/*
 Allows the delegate to specify if a row is sticky. By default, group rows
 are sticky. The delegate can override that by implementing this method.
 */
- (BOOL)tableView:(NSTableView *)tableView isStickyRow:(NSInteger)row;

/*
 Same as above but for outline views.
 */
- (BOOL)outlineView:(NSOutlineView *)outlineView isStickyItem:(id)item;

@end
