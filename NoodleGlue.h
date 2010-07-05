//
//  NoodleBlockAction.h
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

#import <Cocoa/Cocoa.h>

#if defined(NS_BLOCKS_AVAILABLE) && (NS_BLOCKS_AVAILABLE == 1)

@class NoodleGlue;

typedef void		(^NoodleGlueBlock)(NoodleGlue *glue, id object);
typedef void		(^NoodleGlueCleanupBlock)(NoodleGlue *glue);

/*
 In those cases where you need to pass some target object that will get some method called on it, instead of defining a
 new method or class to handle it, just use a block and stuff it into one of these objects and pass this object along
 instead.
 
 Common cases are for notifications (though blocks can be used there directly, you can provide a cleanup block here
 such that the object automatically unregisters itself from notifications when it is dealloc'ed/finalized). Can
 also be used with timers or other places that take a target/action.
 
 Things to be aware of:
 - Most of the time, you probably don't want this object retaining any objects it references (think about how much
   of the glue code you write operates). Use "__block" on any objects you don't want to be retained.
 - You still need to memory manage this object yourself. There's no magic about it. If you set it as a notification
   observer, you need to retain it somewhere because the notification center won't (or if using GC, keep a strong
   reference somewhere).
 
 For more details, check out the related blog post at http://www.noodlesoft.com/blog/2010/07/01/playing-with-nstimer/
 */
@interface NoodleGlue : NSObject
{
	NoodleGlueBlock			_glueBlock;
	NoodleGlueCleanupBlock	_cleanupBlock;
}

@property (readwrite, copy) NoodleGlueBlock glueBlock;
@property (readwrite, copy) NoodleGlueCleanupBlock cleanupBlock;

+ (NoodleGlue *)glueWithBlock:(NoodleGlueBlock)glueBlock;
+ (NoodleGlue *)glueWithBlock:(NoodleGlueBlock)glueBlock cleanupBlock:(NoodleGlueCleanupBlock)cleanupBlock;

// Initializes a glue object. glueBlock will be invoked when this object's -invoke: method is called with the argument
// to -invoke: passed on as a parameter. cleanupBlock is invoked when this object is dealloc'ed/finalized with the 
// glue object being dealloc'ed sent in as a parameter.
- (id)initWithBlock:(NoodleGlueBlock)glueBlock cleanupBlock:(NoodleGlueCleanupBlock)cleanupBlock;

// Invokes the main block. When using this in a target/selector situation, use this as the selector.
- (void)invoke:(id)object;

@end

/*
 NSObject category which, through the use of NoodleGlue and associative references, allows you to assign a block
 to be invoked when the object is deallocated.
 
 This code is more proof of concept than anything you'd want to use in production. For one, it's not threadsafe.
 
 For more details, check out the related blog post at http://www.noodlesoft.com/blog/2010/07/05/fun-with-glue/ 
 */
@interface NSObject (NoodleCleanupGlue)

// Sets a block to be invoked when the object is deallocated/collected. Will return an identifier that you can
// use to remove the block later. Note that you need to retain this identifier if you intend to use it later.
// Also, treat the identifier as an opaque object. Its actual type/formatting/structure may change in future
// versions.
- (id)addCleanupBlock:(void (^)(id object))block;

// Removes the cleanup block using the identifier returned from a previous call to -addCleanupBlock:
- (void)removeCleanupBlock:(id)identifier;

@end


#endif