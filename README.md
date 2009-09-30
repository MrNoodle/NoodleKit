NoodleKit
=========

This is a random collection of classes and categories that I am making public. Most of this code has been posted on my blog: <http://www.noodlesoft.com/blog>

The project is primarily structured to build a framework. There are targets for various examples showing how the different classes are used. Some of the examples also contain a Read Me file so check those out for more details on the specific classes.

This framework is meant to be built/used on 10.5 and later and should support 64-bit.

This code is maintained at <http://github.com/MrNoodle/NoodleKit>

What nifty stuff is in here?
----------------------------

#### NSObject-NoodlePerformWhenIdle
NSObject category for calling a method when the user has been idle for the specified amount of time. Useful for putting up non-critical alerts and purging memory caches, among other things.

<http://www.noodlesoft.com/blog/2008/01/08/idle-hands/>

#### NSResponder-NoodleModalExtensions
NSResponder category providing methods that will dismiss a dialog and return the proper code for whatever button (OK/Cancel) was clicked. Just hook your dialog buttons up to these methods in IB and you're set. Alleviates having to write that glue code every time.

<http://www.noodlesoft.com/blog/2008/03/10/modal-glue/>

#### NSImage-NoodleExtensions
NSImage category providing methods to draw NSImages with correct orientation and scaling regardless of the flipped status of the image or the context being drawn into.

<http://www.noodlesoft.com/blog/2009/02/02/understanding-flipped-coordinate-systems/>

#### NSWindow-NoodleEffects
Provides a basic zoom effect for NSWindow.

<http://www.noodlesoft.com/blog/2007/06/30/animation-in-the-time-of-tiger-part-1/>
<http://www.noodlesoft.com/blog/2007/09/20/animation-in-the-time-of-tiger-part-3/>

#### NoodleLineNumberView, NoodleLineNumberMarker:
Adds line numbers (and markers) to NSTextView.

<http://www.noodlesoft.com/blog/2008/10/05/displaying-line-numbers-with-nstextview/>

#### NoodleStickyRowTableView, NoodleIPhoneTableView:
An NSTableView category that does sticky row headers, like with UITableView on the iPhone. NoodleStickyRowTableView is a basic subclass while NoodleIPhoneTableView simulates the look and feel of UITableView.

<http://www.noodlesoft.com/blog/2009/09/25/sticky-section-headers-in-nstableview/>


License
-------

Copyright (c) 2007-2009 Noodlesoft, LLC. All Rights Reserved.

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
