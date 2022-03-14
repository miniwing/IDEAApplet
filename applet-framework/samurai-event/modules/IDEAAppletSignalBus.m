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

//#if __has_feature(objc_arc)
//
//#error "Please add compile option '-fno-objc-arc' for this file in 'Build phases'."
//
//#else

// ----------------------------------
// Private Head Files
#import "AppletCore.h"
// ----------------------------------

#import "IDEAAppletSignalBus.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletSignalBus {
   
   NSMutableDictionary  * _handlers;
}

@def_singleton( IDEAAppletSignalBus )

- (id)init {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   self = [super init];
   
   if (self) {
      
      _handlers = [[NSMutableDictionary alloc] init];
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return self;
}

- (void)dealloc {
   
   [_handlers removeAllObjects];
   _handlers = nil;
   
   __SUPER_DEALLOC;
   
   return;
}

- (BOOL)send:(IDEAAppletSignal *)aSignal {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   if (aSignal.dead) {
      
      ERROR(@"signal '%@', already dead", aSignal.prettyName);
      
      return NO;
      
   } /* End if () */
   
#if __SAMURAI_DEBUG__
#  if __SIGNAL_CALLSTACK__
   PRINT(@"");
   PERF(@"signal '%@'", aSignal.prettyName);
#  endif
#endif
   
//// Check if foreign source
//
//   if (aSignal.name) {
//
//      aSignal.foreign = nil;
//
//      NSArray * nameComponents = [aSignal.name componentsSeparatedByString:@"."];
//      if (nameComponents.count > 2 && [[nameComponents objectAtIndex:0] isEqualToString:@"signal"]) {
//
//         NSString * sourceName = [[aSignal.source class] description];
//         NSString * namePrefix = [nameComponents objectAtIndex:1];
//
//         if (NO == [sourceName isEqualToString:namePrefix]) {
//
//            aSignal.prefix  = namePrefix;
//            aSignal.foreign = signal.source;
//         }
//      }
//   }

   // Routes signal
   if (aSignal.target) {
      
      aSignal.sending   = YES;
      
      [self routes:aSignal];
      
   } /* End if () */
   else {
      
      aSignal.arrived = YES;
      
   } /* End else */
   
#if __SAMURAI_DEBUG__
#  if __SAMURAI_LOGGING__
   NSString * newline = @"\n   > ";
#  endif // #if __SAMURAI_LOGGING__
#endif // #if __SAMURAI_DEBUG__
   
   if (aSignal.arrived) {
      
      if (aSignal.jumpPath) {
         
         PERF(@"Signal '%@'%@%@%@[Done]", aSignal.prettyName, newline, [aSignal.jumpPath join:newline], newline);
         
      } /* End if () */
      else {
         
         PERF(@"Signal '%@'%@[Done]", aSignal.prettyName, newline);
         
      } /* End else */
   }
   else if (aSignal.dead) {
      
      if (aSignal.jumpPath) {
         
         PERF(@"Signal '%@'%@%@%@[Dead]", aSignal.prettyName, newline, [aSignal.jumpPath join:newline], newline);
         
      } /* End if () */
      else {
         
         PERF(@"Signal '%@'%s[Dead]", aSignal.prettyName, newline);
         
      } /* End else */
      
   } /* End else if () */
   
   __CATCH(nErr);
   
   return aSignal.arrived;
}

- (BOOL)forward:(IDEAAppletSignal *)aSignal {
   
   return [self forward:aSignal to:nil];
}

- (BOOL)forward:(IDEAAppletSignal *)aSignal to:(id)aTarget {
   
   if (aSignal.dead) {
      
      ERROR(@"signal '%@', already dead", aSignal.prettyName);
      
      return NO;
   } /* End if () */
   
   if (nil == aSignal.target) {
      
      ERROR(@"signal '%@', no target", aSignal.prettyName);
      
      return NO;
      
   } /* End if () */
   
   //   if (nil == target)
   //   {
   //      if ([signal.target isKindOfClass:[UIView class]])
   //      {
   //         target = ((UIView *)signal.target).superview;
   //      }
   //   }
   
   [aSignal log:aSignal.target];
   
   if (nil == aTarget) {
      
      aSignal.arrived = YES;
      
      return YES;
      
   } /* End if () */
   
   //// Check if foreign source
   //
   //   if (signal.foreign && signal.source == signal.foreign)
   //   {
   //      NSString * targetName = [[target class] description];
   //
   //      if ([targetName isEqualToString:signal.prefix])
   //      {
   //         signal.source = target;
   //      }
   ////      else
   ////      {
   ////         Class targetClass = NSClassFromString(targetName);
   ////         Class sourceClass = NSClassFromString(signal.prefix);
   ////
   ////         if (sourceClass == targetClass || [targetClass isSubclassOfClass:sourceClass])
   ////         {
   ////            signal.source = target;
   ////         }
   ////      }
   //   }
   
   // Routes signal
   
   aSignal.target    = aTarget;
   aSignal.sending   = YES;
   
   [self routes:aSignal];
   
   return aSignal.arrived;
}

- (void)routes:(IDEAAppletSignal *)aSignal {
   
   int                            nErr                                     = EFAULT;
   
   NSMutableArray                *stClasses                                = [NSMutableArray nonRetainingArray];
   
   __TRY;
   
   for (Class stClass = [aSignal.target class]; nil != stClass; stClass = class_getSuperclass(stClass)) {
      
      [stClasses addObject:stClass];
      
   } /* End for () */
   
//   LogDebug((@"-[IDEAAppletSignalBus routes:] : Class : %@", stClasses));
   
   if (nil != [aSignal.target getAssociatedObjectForKey:@selector(routes:)]) {
      
      nErr  = noErr;
      
      break;
      
   } /* End if () */

   [self routes:aSignal to:aSignal.target forClasses:stClasses];
   
   [aSignal.target assignAssociatedObject:aSignal.target
                                   forKey:@selector(routes:)];

   if (NO == aSignal.arrived) {
      
      NSObject       *stObject      = [aSignal.target signalResponders];
      EncodingType    eObjectType   = [IDEAAppletEncoding typeOfObject:stObject];
      
//      LogDebug((@"-[IDEAAppletSignalBus routes:] : signalResponders : %@", stObject));

      if (nil == stObject) {
         
         aSignal.arrived = YES;
         
      } /* End if () */
      else {
         
         if (EncodingType_Array == eObjectType) {
            
//            NSArray  *stResponders = (NSArray *)stObject;
//
//            if (1 == stResponders.count) {
//
//               if (NO == aSignal.dead) {
//
//                  [aSignal log:aSignal.target];
//
//                  aSignal.target = [stResponders objectAtIndex:0];
//                  aSignal.sending = YES;
//
//                  [self routes:aSignal];
//
//               } /* End if () */
//
////               [self forward:signal to:[responders objectAtIndex:0]];
//
//            } /* End if () */
//            else {
//
//               for (NSObject *stResponder in stResponders) {
//
//                  IDEAAppletSignal  *stClonedSignal = [aSignal clone];
//
//                  if (stClonedSignal) {
//
//                     if (NO == stClonedSignal.dead) {
//
//                        [stClonedSignal log:stClonedSignal.target];
//
//                        stClonedSignal.target = stResponder;
//                        stClonedSignal.sending = YES;
//
//                        [self routes:stClonedSignal];
//
//                     } /* End if () */
//
////                  [self forward:clonedSignal to:responder];
//
//                  } /* End if () */
//
//               } /* End for () */
//
//            } /* End else */
            
//            if ([(NSArray *)stObject containsObject:aSignal.source]) {
//
////               LogDebug((@"-[IDEAAppletSignalBus routes:] : Signal.target : %@", aSignal.target));
//
//            } /* End if () */
//            else {
//
//               for (NSObject *stResponder in (NSArray *)stObject) {
//
//                  if (nil != getAssociatedObjectForKey(@selector(routes:))) {
//
//                     continue;
//
//                  } /* End if () */
//
//                  IDEAAppletSignal  *stClonedSignal = [aSignal clone];
//
//                  if (stClonedSignal) {
//
//                     if (NO == stClonedSignal.dead) {
//
//                        [stClonedSignal log:stClonedSignal.target];
//
//                        stClonedSignal.target = stResponder;
//                        stClonedSignal.sending = YES;
//
//                        [self routes:stClonedSignal];
//
//                     } /* End if () */
//
////                  [self forward:clonedSignal to:responder];
//
//                  } /* End if () */
//
//               } /* End for () */
//
//            } /* End else */

            for (NSObject *stResponder in (NSArray *)stObject) {
                              
               IDEAAppletSignal  *stClonedSignal = [aSignal clone];
               
               if (stClonedSignal) {
                  
                  if (NO == stClonedSignal.dead) {
                     
                     [stClonedSignal log:stClonedSignal.target];
                     
                     stClonedSignal.target = stResponder;
                     stClonedSignal.sending = YES;
                     
                     [self routes:stClonedSignal];
                                          
                  } /* End if () */
                  
//                  [self forward:clonedSignal to:responder];
                  
               } /* End if () */
               
            } /* End for () */

         } /* End if () */
         else {
            
            if (NO == aSignal.dead) {
               
               [aSignal log:aSignal.target];
               
               aSignal.target    = stObject;
               aSignal.sending   = YES;
               
               [self routes:aSignal];
               
            } /* End if () */
            
//          [self forward:signal to:object];
            
         } /* End else */
         
      } /* End else */
      
   } /* End if () */
   
   [aSignal.target removeAssociatedObjectForKey:@selector(routes:)];

   __CATCH(nErr);
   
   return;
}

- (void)routes:(IDEAAppletSignal *)aSignal to:(NSObject *)aTarget forClasses:(NSArray *)aClasses {
   
   if (0 == aClasses.count) {
      
      return;
      
   } /* End if () */
   
   if (nil == aSignal.source || nil == aSignal.target) {
      
      ERROR(@"No signal source/target");
      
      return;
      
   } /* End if () */
   
   NSObject    *szPrioAlias      = nil;
   NSString    *szPrioSelector   = nil;
   NSString    *szNameSpace      = nil;
   NSString    *szTagString      = nil;
   
   NSString    *szSignalPrefix   = nil;
   NSString    *szSignalClass    = nil;
   NSString    *szSignalMethod   = nil;
   NSString    *szSignalMethod2  = nil;
   
   if (aSignal.name && [aSignal.name hasPrefix:@"signal."]) {
      
      NSArray  *stArray = [aSignal.name componentsSeparatedByString:@"."];
      
      if (stArray && stArray.count > 1) {
         
         szSignalPrefix = (NSString *)[stArray safeObjectAtIndex:0];
         szSignalClass  = (NSString *)[stArray safeObjectAtIndex:1];
         szSignalMethod = (NSString *)[stArray safeObjectAtIndex:2];
         szSignalMethod2= (NSString *)[stArray safeObjectAtIndex:3];
         
         ASSERT([szSignalPrefix isEqualToString:@"signal"]);
         
      } /* End if () */
      
   } /* End if () */
   
   if (aSignal.source) {
      
      szNameSpace = [aSignal.source signalNamespace];
      if (szNameSpace && szNameSpace.length) {
         
         szNameSpace = [szNameSpace stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
         szNameSpace = [szNameSpace stringByReplacingOccurrencesOfString:@":" withString:@"_"];
         
      } /* End if () */
      
      szTagString = [aSignal.source signalTag];
      if (szTagString && szTagString.length) {
         
         szTagString = [szTagString stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
         szTagString = [szTagString stringByReplacingOccurrencesOfString:@":" withString:@"_"];
         
      } /* End if () */
      
//      if (szNameSpace || szTagString) {
//
      if (szNameSpace && szTagString) {
         
         szPrioSelector = [NSString stringWithFormat:@"%@_%@", szNameSpace, szTagString];
         
      } /* End if () */
//      else if (nameSpace) {
//
//         prioSelector = nameSpace;
//      }
//      else if (tagString) {
//
//         prioSelector = tagString;
//      }
//    }
      
      szPrioAlias = [aSignal.source signalAlias];
      
   } /* End if () */
   
   for (Class stTargetClass in aClasses) {
      
      NSString *szCacheName            = nil;
      NSString *szCachedSelectorName   = nil;
      SEL       stCachedSelector       = nil;
      
      if (szPrioSelector) {
         
         szCacheName = [NSString stringWithFormat:@"%@/%@/%@", aSignal.name, [stTargetClass description], szPrioSelector];
         
      } /* End if () */
      else {
         
         szCacheName = [NSString stringWithFormat:@"%@/%@", aSignal.name, [stTargetClass description]];
         
      } /* End if () */
      
      szCachedSelectorName = [_handlers objectForKey:szCacheName];
      
      if (szCachedSelectorName) {
         
         stCachedSelector = NSSelectorFromString(szCachedSelectorName);
         
         if (stCachedSelector) {
            
            BOOL bHit = [self signal:aSignal perform:stCachedSelector class:stTargetClass target:aTarget];
            if (bHit) {
               
//               continue;
               break;
               
            } /* End if () */
            
         } /* End if () */
         
      } /* End if () */
      
      //      do
      {
         NSString *szSelectorName   = nil;
         SEL       stSelector       = nil;
         BOOL      bPerformed       = NO;
         
         // native selector
         
         if ([aSignal.name hasPrefix:@"signal."]) {
            
            if (NO == bPerformed) {
               
               szSelectorName = [aSignal.name substringFromIndex:@"signal.".length];
               szSelectorName = [szSelectorName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
               szSelectorName = [szSelectorName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
               szSelectorName = [szSelectorName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
               
               stSelector = NSSelectorFromString(szSelectorName);
               
               bPerformed = [self signal:aSignal perform:stSelector class:stTargetClass target:aTarget];
               if (bPerformed) {
                  
                  [_handlers setObject:szSelectorName forKey:szCacheName];
                  
                  break;
                  
               } /* End if () */
               
            } /* End if () */
            
         } /* End if () */
         
         if ([aSignal.name hasPrefix:@"selector."]) {
            
            if (NO == bPerformed) {
               
               szSelectorName = [aSignal.name substringFromIndex:@"selector.".length];
//               szSelectorName = [szSelectorName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
//               szSelectorName = [szSelectorName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
//               szSelectorName = [szSelectorName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
               
               stSelector = NSSelectorFromString(szSelectorName);
               
               bPerformed = [self signal:aSignal perform:stSelector class:stTargetClass target:aTarget];
               if (bPerformed) {
                  
                  [_handlers setObject:szSelectorName forKey:szCacheName];
                  
                  break;
                  
               } /* End if () */
               
            } /* End if () */
            
         } /* End if () */
         
         if (NO == bPerformed) {
            
            if ([aSignal.name hasSuffix:@":"]) {
               
               szSelectorName = aSignal.name;
               
            } /* End if () */
            else {
               
               szSelectorName = [NSString stringWithFormat:@"%@:", aSignal.name];
               
            } /* End if () */
            
            szSelectorName = [szSelectorName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
            szSelectorName = [szSelectorName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
            szSelectorName = [szSelectorName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
            
            stSelector = NSSelectorFromString(szSelectorName);
            
            bPerformed = [self signal:aSignal perform:stSelector class:stTargetClass target:aTarget];
            if (bPerformed) {
               
               [_handlers setObject:szSelectorName forKey:szCacheName];
               
               break;
               
            } /* End if () */
            
         } /* End if () */
         
         // high priority selector
         
         if (szPrioAlias) {
            
            if ([szPrioAlias isKindOfClass:[NSArray class]]) {
               
               for (NSString *szAlias in (NSArray *)szPrioAlias) {
                  
                  szSelectorName = [NSString stringWithFormat:@"handleSignal____%@:", szAlias];
                  stSelector     = NSSelectorFromString(szSelectorName);
                  
                  bPerformed     = [self signal:aSignal perform:stSelector class:stTargetClass target:aTarget];
                  
                  if (bPerformed) {
                     
                     [_handlers setObject:szSelectorName forKey:szCacheName];
                     
                     break;
                     
                  } /* End if () */
                  
                  if (szSignalMethod && szSignalMethod2) {
                     
                     szSelectorName = [NSString stringWithFormat:@"handleSignal____%@____%@____%@:", szAlias, szSignalMethod, szSignalMethod2];
                     stSelector = NSSelectorFromString(szSelectorName);
                     
                     bPerformed = [self signal:aSignal perform:stSelector class:stTargetClass target:aTarget];
                     if (bPerformed) {
                        
                        [_handlers setObject:szSelectorName forKey:szCacheName];
                        
                        break;
                        
                     } /* End if () */
                     
                  } /* End if () */
                  
                  if (szSignalMethod) {
                     
                     szSelectorName = [NSString stringWithFormat:@"handleSignal____%@____%@:", szAlias, szSignalMethod];
                     stSelector = NSSelectorFromString(szSelectorName);
                     
                     bPerformed = [self signal:aSignal perform:stSelector class:stTargetClass target:aTarget];
                     if (bPerformed) {
                        
                        [_handlers setObject:szSelectorName forKey:szCacheName];
                        break;
                     }
                  }
               }
            }
            else {
               
               szSelectorName = [NSString stringWithFormat:@"handleSignal____%@:", szPrioAlias];
               stSelector = NSSelectorFromString(szSelectorName);
               
               bPerformed = [self signal:aSignal perform:stSelector class:stTargetClass target:aTarget];
               if (bPerformed) {
                  
                  [_handlers setObject:szSelectorName forKey:szCacheName];
                  break;
               }
               
               if (szSignalMethod && szSignalMethod2) {
                  
                  szSelectorName = [NSString stringWithFormat:@"handleSignal____%@____%@____%@:", szPrioAlias, szSignalMethod, szSignalMethod2];
                  stSelector = NSSelectorFromString(szSelectorName);
                  
                  bPerformed = [self signal:aSignal perform:stSelector class:stTargetClass target:aTarget];
                  if (bPerformed) {
                     
                     [_handlers setObject:szSelectorName forKey:szCacheName];
                     break;
                  }
               }
               
               if (szSignalMethod) {
                  
                  szSelectorName = [NSString stringWithFormat:@"handleSignal____%@____%@:", szPrioAlias, szSignalMethod];
                  stSelector = NSSelectorFromString(szSelectorName);
                  
                  bPerformed = [self signal:aSignal perform:stSelector class:stTargetClass target:aTarget];
                  if (bPerformed) {
                     
                     [_handlers setObject:szSelectorName forKey:szCacheName];
                     break;
                  }
               }
            }
         }
         
         if (bPerformed) {
            
            break;
            
         } /* End if () */
         
         // signal selector
         
         if (szPrioSelector) {
            
            // eg. handleSignal(Class, tag)
            
            szSelectorName = [NSString stringWithFormat:@"handleSignal____%@:", szPrioSelector];
            stSelector = NSSelectorFromString(szSelectorName);
            
            bPerformed = [self signal:aSignal perform:stSelector class:stTargetClass target:aTarget];
            if (bPerformed) {
               
               [_handlers setObject:szSelectorName forKey:szCacheName];
               
               break;
               
            } /* End if () */
         }
         
         // eg. handleSignal(Class, Signal, State)
         
         if (szSignalClass && szSignalMethod && szSignalMethod2) {
            
            szSelectorName = [NSString stringWithFormat:@"handleSignal____%@____%@____%@:", szSignalClass, szSignalMethod, szSignalMethod2];
            stSelector = NSSelectorFromString(szSelectorName);
            
            bPerformed = [self signal:aSignal perform:stSelector class:stTargetClass target:aTarget];
            if (bPerformed) {
               
               [_handlers setObject:szSelectorName forKey:szCacheName];
               
               break;
               
            } /* End if () */
            
         } /* End if () */
         
         // eg. handleSignal(Class, Signal)
         
         if (szSignalClass && szSignalMethod) {
            
            szSelectorName = [NSString stringWithFormat:@"handleSignal____%@____%@:", szSignalClass, szSignalMethod];
            stSelector = NSSelectorFromString(szSelectorName);
            
            bPerformed = [self signal:aSignal perform:stSelector class:stTargetClass target:aTarget];
            if (bPerformed) {
               
               [_handlers setObject:szSelectorName forKey:szCacheName];
               
               break;
               
            } /* End if () */
            
         } /* End if () */
         
         // eg. handleSignal(Class)
         
         if (szSignalClass) {
            
            szSelectorName = [NSString stringWithFormat:@"handleSignal____%@:", szSignalClass];
            stSelector = NSSelectorFromString(szSelectorName);
            
            bPerformed = [self signal:aSignal perform:stSelector class:stTargetClass target:aTarget];
            if (bPerformed) {
               
               [_handlers setObject:szSelectorName forKey:szCacheName];
               
               break;
               
            } /* End if () */
            
         } /* End if () */
         
         // eg. handleSignal(Class, Signal)
         
         if ([aSignal.name hasPrefix:@"signal____"]) {
            
            szSelectorName = [aSignal.name stringByReplacingOccurrencesOfString:@"signal____" withString:@"handleSignal____"];
            
         } /* End if () */
         else {
            
            szSelectorName = [NSString stringWithFormat:@"handleSignal____%@:", aSignal.name];
            
         } /* End else */
         
         szSelectorName = [szSelectorName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
         szSelectorName = [szSelectorName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
         szSelectorName = [szSelectorName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
         
         if (NO == [szSelectorName hasSuffix:@":"]) {
            
            szSelectorName = [szSelectorName stringByAppendingString:@":"];
            
         } /* End if () */
         
         stSelector = NSSelectorFromString(szSelectorName);
         
         bPerformed = [self signal:aSignal perform:stSelector class:stTargetClass target:aTarget];
         if (bPerformed) {
            
            [_handlers setObject:szSelectorName forKey:szCacheName];
            
            break;
            
         } /* End if () */
         
         for (Class rtti = [aSignal.source class]; nil != rtti && rtti != [NSObject class]; rtti = class_getSuperclass(rtti)) {
            
            // eg. handleSignal(Class, Signal, State)
            
            if ((szSignalMethod && szSignalMethod.length) && szSignalMethod2 && szSignalMethod2.length) {
               
               szSelectorName = [NSString stringWithFormat:@"handleSignal____%@____%@____%@:", [rtti description], szSignalMethod, szSignalMethod2];
               stSelector = NSSelectorFromString(szSelectorName);
               
               bPerformed = [self signal:aSignal perform:stSelector class:stTargetClass target:aTarget];
               if (bPerformed) {
                  
                  [_handlers setObject:szSelectorName forKey:szCacheName];
                  
                  break;
                  
               } /* End if () */
               
            } /* End if () */
            
            // eg. handleSignal(Class, Signal)
            
            if (szSignalMethod && szSignalMethod.length) {
               
               szSelectorName = [NSString stringWithFormat:@"handleSignal____%@____%@:", [rtti description], szSignalMethod];
               stSelector     = NSSelectorFromString(szSelectorName);
               
               bPerformed     = [self signal:aSignal perform:stSelector class:stTargetClass target:aTarget];
               if (bPerformed) {
                  
                  [_handlers setObject:szSelectorName forKey:szCacheName];
                  
                  break;
                  
               } /* End if () */
               
            } /* End if () */
            
            // eg. handleSignal(Class, tag)
            
            if (szTagString && szTagString.length) {
               
               szSelectorName = [NSString stringWithFormat:@"handleSignal____%@____%@:", [rtti description], szTagString];
               stSelector     = NSSelectorFromString(szSelectorName);
               
               bPerformed     = [self signal:aSignal perform:stSelector class:stTargetClass target:aTarget];
               if (bPerformed) {
                  
                  [_handlers setObject:szSelectorName forKey:szCacheName];
                  
                  break;
                  
               } /* End if () */
               
               szSelectorName = [NSString stringWithFormat:@"handleSignal____%@:", szTagString];
               stSelector     = NSSelectorFromString(szSelectorName);
               
               bPerformed     = [self signal:aSignal perform:stSelector class:stTargetClass target:aTarget];
               if (bPerformed) {
                  
                  [_handlers setObject:szSelectorName forKey:szCacheName];
                  
                  break;
                  
               } /* End if () */
               
            } /* End if () */
            
            // eg. handleSignal(Class)
            
            szSelectorName = [NSString stringWithFormat:@"handleSignal____%@:", [rtti description]];
            stSelector     = NSSelectorFromString(szSelectorName);
            
            bPerformed     = [self signal:aSignal perform:stSelector class:stTargetClass target:aTarget];
            if (bPerformed) {
               
               [_handlers setObject:szSelectorName forKey:szCacheName];
               
               break;
               
            } /* End if () */
            
         } /* End for () */
         
         if (NO == bPerformed) {
            
            szSelectorName = @"handleSignal____:";
            stSelector = NSSelectorFromString(szSelectorName);
            
            bPerformed = [self signal:aSignal perform:stSelector class:stTargetClass target:aTarget];
            if (bPerformed) {
               
               [_handlers setObject:szSelectorName forKey:szCacheName];
               
               break;
               
            } /* End if () */
            
         } /* End if () */
         
         if (NO == bPerformed) {
            
            szSelectorName = @"handleSignal:";
            stSelector = NSSelectorFromString(szSelectorName);
            
            bPerformed = [self signal:aSignal perform:stSelector class:stTargetClass target:aTarget];
            if (bPerformed) {
               
               [_handlers setObject:szSelectorName forKey:szCacheName];
               
               break;
               
            } /* End if () */
            
         } /* End if () */
      }
      //      while (0);
   }
   
   return;
}

- (BOOL)signal:(IDEAAppletSignal *)aSignal perform:(SEL)aSEL class:(Class)aClass target:(id)aTarget {
   
   ASSERT(nil != aSignal);
   ASSERT(nil != aTarget);
   ASSERT(nil != aSEL);
   ASSERT(nil != aClass);
   
   BOOL   bPerformed    = NO;
   
   // try block
   
   if (NO == bPerformed) {
      
      IDEAAppletHandler *stHandler  = [aTarget blockHandler];
      
      if (stHandler) {
         
         BOOL   bFound  = [stHandler trigger:[NSString stringWithUTF8String:sel_getName(aSEL)] withObject:aSignal];
         if (bFound) {
            
            aSignal.hit       = YES;
            aSignal.hitCount += 1;
            
            bPerformed        = YES;
            
         } /* End if () */
         
      } /* End if () */
      
   } /* End if () */
   
   // try selector
   if (NO == bPerformed) {
      
      Method    stMethod   = class_getInstanceMethod(aClass, aSEL);
      if (stMethod) {
         
         ImpFuncType stIMP = (ImpFuncType)method_getImplementation(stMethod);
         if (stIMP) {
            
            stIMP(aTarget, aSEL, (__bridge void *)aSignal);
            
            aSignal.hit = YES;
            aSignal.hitCount += 1;
            
            bPerformed = YES;
            
         } /* End if () */
         
      } /* End if () */
      
   } /* End if () */
   
#if __SAMURAI_DEBUG__
#  if __SIGNAL_CALLSTACK__
   NSString * selName = [NSString stringWithUTF8String:sel_getName(sel)];
   NSString * className = [clazz description];
   
   if (NSNotFound != [selName rangeOfString:@"____"].location) {
      
      selName = [selName stringByReplacingOccurrencesOfString:@"handleSignal____" withString:@"handleSignal("];
      selName = [selName stringByReplacingOccurrencesOfString:@"____" withString:@", "];
      selName = [selName stringByReplacingOccurrencesOfString:@":" withString:@""];
      selName = [selName stringByAppendingString:@")"];
   }
   
   PERF(@"  %@ [%d] %@::%@", performed ? @"✔" : @"✖", signal.jumpCount, className, selName);
#  endif
#endif
   
   return bPerformed;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE(Event, SignalBus)

DESCRIBE(before) {
   
}

DESCRIBE(after) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"

//#endif
