//
//     ____    _                        __     _      _____
//    / ___\  /_\     /\/\    /\ /\    /__\   /_\     \_   \
//    \ \    //_\\   /    \  / / \ \  / \//  //_\\     / /\/
//  /\_\ \  /  _  \ / /\/\ \ \ \_/ / / _  \ /  _  \ /\/ /_
//  \____/  \_/ \_/ \/    \/  \___/  \/ \_/ \_/ \_/ \____/
//
//   Copyright Samurai development team and other contributors
//
//   http://www.samurai-framework.com
//
//   Permission is hereby granted, free of charge, to any person obtaining a copy
//   of this software and associated documentation files (the "Software"), to deal
//   in the Software without restriction, including without limitation the rights
//   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//   copies of the Software, and to permit persons to whom the Software is
//   furnished to do so, subject to the following conditions:
//
//   The above copyright notice and this permission notice shall be included in
//   all copies or substantial portions of the Software.
//
//   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//   THE SOFTWARE.
//

#import "IDEAAppletCore.h"
#import "IDEAAppletEvent.h"

//#import "IDEAAppletViewConfig.h"

#import "IDEAAppletViewCore.h"
#import "IDEAAppletViewEvent.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "UIView+IDEAApplet.h"
#import "UIScrollView+IDEAApplet.h"
#import "UITableViewCell+IDEAApplet.h"

#pragma mark -

@interface IDEAAppletUITableViewSection : NSObject

- (NSUInteger)getRowCount;                                    // override point
- (CGFloat)getHeightForRowAtIndexPath:(NSIndexPath *)indexPath;         // override point
- (NSObject *)getDataForRowAtIndexPath:(NSIndexPath *)indexPath;      // override point
- (UITableViewCell *)getCellForRowAtIndexPath:(NSIndexPath *)indexPath;   // override point

@end

#pragma mark -

@interface IDEAAppletUITableViewAgent : IDEAAppletUIScrollViewAgent<UITableViewDelegate, UITableViewDataSource>

@prop_unsafe( UITableView *,      tableView );
@prop_strong( NSMutableArray *,      sections );

- (void)appendSection:(IDEAAppletUITableViewSection *)section;
- (void)insertSection:(IDEAAppletUITableViewSection *)section atIndex:(NSUInteger)index;
- (void)removeAllSections;

@end

#pragma mark -

@interface UITableView(IDEAApplet)

@signal( eventWillSelectRow );
@signal( eventWillDeselectRow );

@signal( eventDidSelectRow );
@signal( eventDidDeselectRow );

- (IDEAAppletUITableViewAgent *)tableViewAgent;

@end

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
