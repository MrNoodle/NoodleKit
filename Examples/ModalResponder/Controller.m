//
//  Controller.m
//  ModalResponderTest
//
//  Created by Paul Kim on 3/6/08.
//  Copyright 2008-2009 Noodlesoft, LLC. All rights reserved.
//

#import "Controller.h"


@implementation Controller

- (IBAction)doModal:sender
{
	NSInteger		returnCode;
	
	[field setStringValue:@""];
	
	returnCode = [NSApp runModalForWindow:alert];
	
	if (returnCode == NSOKButton)
	{
		[field setStringValue:@"OK!"];
	}
	else
	{
		[field setStringValue:@"Cancel"];
	}
}


- (IBAction)doSheet:sender
{
	[field setStringValue:@""];
	
	[NSApp beginSheet:alert modalForWindow:window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
	//PENDING
/*
	NSLog(@"ALERT: %@", alert);
	NSLog(@"PARENT: %@", [alert parentWindow]);
	NSLog(@"SHEET: %@", [[alert parentWindow] attachedSheet]);
	NSLog(@"WINDOW: %@", window);
	NSLog(@"CHILD: %@", [window childWindows]);
	NSLog(@"ALERT CHILD: %@", [alert childWindows]);
	NSLog(@"ATTACHED: %@", [window attachedSheet]); 
*/
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	if (returnCode == NSOKButton)
	{
		[field setStringValue:@"OK!"];
	}
	else
	{
		[field setStringValue:@"Cancel"];		
	}
}

@end
