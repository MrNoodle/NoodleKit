//
//  NSResponder-ModalExtensions.h
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

#import <Cocoa/Cocoa.h>

/*
 These categories provide simple methods to handle alert dialogs (window or sheet form). Hook your "OK" and "Cancel"
 buttons to these methods to the first responder in IB and you're done. The modal session will return NSOKButton or
 NSCancelButton. I'll leave it to you to figure out which one does what.
 
 For more details, check out the related blog post at http://www.noodlesoft.com/blog/2008/03/10/modal-glue/
 */


@interface NSResponder (NoodleModalExtensions)

- (void)confirmModal:(id)sender;
- (void)cancelModal:(id)sender;

@end

@interface NSWindow (NoodleModalExtensions)

- (void)confirmModal:(id)sender;
- (void)cancelModal:(id)sender;

@end
