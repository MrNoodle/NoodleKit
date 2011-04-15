//
//  ImageLabAppDelegate.m
//  ImageLab
//
//  Created by Paul Kim on 3/20/11.
//  Copyright 2011 Noodlesoft, LLC. All rights reserved.
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

#import "ImageLabAppDelegate.h"
#import "NoodleCustomImageRep.h"
#import <QuartzCore/QuartzCore.h>

@implementation ImageLabAppDelegate

@synthesize window;

- (NSImage *)lockFocusImage
{
	NSImage		*image;
	NSSize		size;
	CGFloat		diameter;
	
	image = [[testImage copy] autorelease];
	
	size = [image size];
	diameter = size.width / 2.0;
	
	[image lockFocus];

	[[NSColor blackColor] set];
	[[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(diameter / 2.0, diameter / 2.0, diameter, diameter)] fill];
	
	[image unlockFocus];

	return image;
}

- (NSImage *)customRepImage
{
	NoodleCustomImageRep	*rep;
	NSSize					size;
	NSImage					*image;

	size = [testImage size];

	rep = [NoodleCustomImageRep imageRepWithDrawBlock:
		   ^(NoodleCustomImageRep *blockRep)
		   {			   
			   NSSize	repSize;
			   CGFloat	diameter;
			   
			   repSize = [blockRep size];
			   diameter = repSize.width / 2.0;
			   
			   [testImage drawInRect:NSMakeRect(0.0, 0.0, size.width, size.height) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
			   
			   [[NSColor blackColor] set];
			   [[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(diameter / 2.0, diameter / 2.0, diameter, diameter)] fill];
			   
			   [recacheIndicator setImage:[[[NSImage imageNamed:NSImageNameStatusAvailable] copy] autorelease]];
		   }];
	[rep setSize:size];
	image = [[[NSImage alloc] initWithSize:size] autorelease];
	[image addRepresentation:rep];
	
	return image;
}

- (NSImage *)lockFocusDrawnImage
{
	NSImage			*image;
	NSSize			size;
	
	size = NSMakeSize(10.0, 10.0);
	
	image = [[[NSImage alloc] initWithSize:size] autorelease];
	
	[image lockFocus];
	
	[[NSGraphicsContext currentContext] setShouldAntialias:NO];
	
	[[NSColor blueColor] set];
	NSRectFill(NSMakeRect(1.0, 1.0, 8.0, 8.0));
	
	[image unlockFocus];
	return image;
}

- (NSImage *)customRepDrawnImage
{
	NoodleCustomImageRep	*rep;
	NSSize					size;
	NSImage					*image;
	
	size = NSMakeSize(10.0, 10.0);
	
	rep = [NoodleCustomImageRep imageRepWithDrawBlock:
		   ^(NoodleCustomImageRep *blockRep)
		   {
			   [[NSColor blueColor] set];
			   NSRectFill(NSMakeRect(1.0, 1.0, 8.0, 8.0));
			   
			   [recacheIndicator setImage:[[[NSImage imageNamed:NSImageNameStatusAvailable] copy] autorelease]];
		   }];
	[rep setSize:size];
	image = [[[NSImage alloc] initWithSize:size] autorelease];
	[image addRepresentation:rep];
	
	return image;
}

- (NSImage *)coreImageTIFFRep
{
	NSImage				*image;
	NSSize				size;
	CIImage				*input, *output;
	CIFilter			*filter;
	NSCIImageRep		*rep;
	CGRect				extent;
	CGAffineTransform	transform;
	
	size = [testImage size];

	input = [CIImage imageWithData:[testImage TIFFRepresentation]];
	filter = [CIFilter filterWithName:@"CIPointillize" keysAndValues:
			  @"inputImage", input,
			  @"inputRadius", [NSNumber numberWithFloat:(float)(size.width / 10.0)],
              @"inputCenter", [CIVector vectorWithX:size.width / 2.0 Y:size.height / 2.0],
              nil];
	output = [filter valueForKey:@"outputImage"];
	
	extent = [output extent];
	transform = CGAffineTransformMakeScale(size.width / extent.size.width, size.height / extent.size.height);
	transform = CGAffineTransformTranslate(transform, -extent.origin.x, -extent.origin.y);
	output = [output imageByApplyingTransform:transform];

	image = [[[NSImage alloc] initWithSize:size] autorelease];
	rep = [NSCIImageRep imageRepWithCIImage:output];
	[rep setSize:size];
	[image addRepresentation:rep];
	
	return image;
}

- (NSImage *)coreImageCustomImageRep
{
	NoodleCustomImageRep	*rep;
	NSSize					size;
	NSImage					*image;
	__block id				label;
	
	label = timeLabel;
	
	size = [testImage size];
	
	rep = [NoodleCustomImageRep imageRepWithDrawBlock:
		   ^(NoodleCustomImageRep *blockRep)
		   {
			   CGImageRef		cgImage;
			   CIImage			*input, *output;
			   CIFilter			*filter;
			   NSRect			rect;

			   rect.origin = NSMakePoint(0.0, 0.0);
			   rect.size = [blockRep size];
			   
			   cgImage = [testImage CGImageForProposedRect:&rect
													 context:[NSGraphicsContext currentContext]
													   hints:nil];
			   input = [CIImage imageWithCGImage:cgImage];
               filter = [CIFilter filterWithName:@"CIPointillize" keysAndValues:
                         @"inputImage", input,
                         @"inputRadius", [NSNumber numberWithFloat:(float)(NSWidth(rect) / 10.0)],
                         @"inputCenter", [CIVector vectorWithX:NSWidth(rect) / 2.0 Y:NSHeight(rect) / 2.0],
                         nil];
			   output = [filter valueForKey:@"outputImage"];
			   
			   [output drawInRect:rect fromRect:NSRectFromCGRect([output extent]) operation:NSCompositeCopy fraction:1.0]; 
			   
			   [recacheIndicator setImage:[[[NSImage imageNamed:NSImageNameStatusAvailable] copy] autorelease]];
		   }];
	
	[rep setSize:size];
	image = [[[NSImage alloc] initWithSize:size] autorelease];
	[image addRepresentation:rep];
	
	return image;	
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	testImage = [[NSImage imageNamed:@"test"] copy];
	[recacheIndicator setImage:[[[NSImage imageNamed:NSImageNameStatusNone] copy] autorelease]];
}

- (IBAction)switchImage:(id)sender
{
	NSInteger	tag;
	NSImage		*image;
	
	tag = [sender selectedTag];
	
	switch (tag)
	{
		case 0:
			image = testImage;
			break;
		case 1:
			image = [self lockFocusImage];
			break;
		case 2:
			image = [self customRepImage];
			break;
		case 3:
			image = [self lockFocusDrawnImage];
			break;
		case 4:
			image = [self customRepDrawnImage];
			break;
		case 5:
			image = [self coreImageTIFFRep];
			break;
		case 6:
			image = [self coreImageCustomImageRep];
			break;
	}
	[imageView setObjectValue:image];
}

- (IBAction)redraw:sender
{
	[imageView display];
}

@end
