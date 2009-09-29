//
//  Controller.h
//  ModalResponderTest
//
//  Created by Paul Kim on 3/6/08.
//  Copyright 2008-2009 Noodlesoft, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Controller : NSObject
{
	IBOutlet id		window;
	IBOutlet id		alert;
	IBOutlet id		field;
}

- (IBAction)doModal:sender;
- (IBAction)doSheet:sender;

@end
