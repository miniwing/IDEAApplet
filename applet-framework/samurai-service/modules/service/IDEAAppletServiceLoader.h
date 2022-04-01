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
#import "IDEAAppletServiceConfig.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark -

typedef struct __ServicStartUp {
   
   char * _Nonnull key;
//   char * (* _Nonnull function)(void);
   void (* _Nonnull function)(void);

} St_ServicStartUp;

#define __SERVICE_STARTUP_SECTION_NAME    "__S_STARTUP"
#define __SERVICE_STARTUP_KEY             "__service_main"

#define __S_STARTUP(key)                  \
                                          static void __startup_##key(void); \
                                          __attribute__((used, section("__S_STARTUP," ""#key""))) \
                                          static const St_ServicStartUp __fn_##key = (St_ServicStartUp){(char *)(&#key), (void *)(&__startup_##key)}; \
                                          static void __startup_##key() \

#define SERVICE_MAIN()                    __S_STARTUP(__service_main)

#pragma mark -

@class IDEAAppletService;

@interface IDEAAppletServiceLoader : NSObject

@singleton( IDEAAppletServiceLoader )

@prop_readonly( NSArray<IDEAAppletService *> *, services );

- (id)service:(Class)aClassType;

- (void)installServices;
- (void)uninstallServices;

@end

NS_ASSUME_NONNULL_END
