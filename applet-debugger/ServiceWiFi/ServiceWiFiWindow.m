//
//  ServiceWiFiWindow.m
//  IDEAAppletDebugger
//
//  Created by Harry on 2021/7/12.
//
//  Mail: miniwing.hz@gmail.com
//  TEL : +(852)53054612
//

#import "ServiceWiFiWindow.h"

#import "IDEAAppletServiceRootController.h"
#import "IDEAAppletRoute.h"
#import "IDEAAppletGCD.h"

static const CGFloat             kBarHeight              = 20.0f;

@interface ServiceWiFiWindow ()

@prop_strong( UILabel                        *, label );
@prop_strong( AFNetworkReachabilityManager   *, networkReachManager );

@end

@implementation ServiceWiFiWindow

- (id)init {
   
   int                            nErr                                     = EFAULT;

   CGRect                         stBarFrame                               = CGRectZero;

   __TRY;
   
   stBarFrame.origin.x    = 8.0f;
   stBarFrame.origin.y    = [UIApplication sharedApplication].statusBarFrame.size.height;
   stBarFrame.size.width  = [UIScreen mainScreen].bounds.size.width;
   stBarFrame.size.height = kBarHeight;
   
   self = [super initWithFrame:stBarFrame];
   
   if (self) {
      
      self.hidden             = YES;
      self.backgroundColor    = UIColor.clearColor; // [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:0.5f];
      self.windowLevel        = UIWindowLevelStatusBar + 5.0f;
      self.rootViewController = [[ServiceRootController alloc] init];
      
      _label = [[UILabel alloc] initWithFrame:self.bounds];
      _label.backgroundColor     = UIColor.clearColor;
      _label.textColor           = UIColor.blackColor;
      _label.backgroundColor     = UIColor.clearColor;
      
      if (@available(iOS 13, *)) {
         
         _label.font             = [UIFont monospacedSystemFontOfSize:12.0f weight:UIFontWeightSemibold];
         
      } /* End if () */
      else {
         
         _label.font             = [UIFont fontWithName:@"Menlo" size:12.0f];
         
      } /* End else */
      
      _label.baselineAdjustment  = UIBaselineAdjustmentAlignCenters;
      _label.textAlignment       = NSTextAlignmentLeft;
      _label.lineBreakMode       = NSLineBreakByClipping;
      
//      _label.layer.shadowColor   = [UIColor.whiteColor CGColor];
//      _label.layer.shadowOpacity = 1.0f;
//      _label.layer.shadowRadius  = 1.0f;
//      _label.layer.shadowOffset  = CGSizeMake(0.f, 0.0f);
      [_label setBackgroundColor:UIColor.clearColor];
//      [_label setTextColor:UIColor.darkGrayColor];
      
      [_label setTextColorPicker:DKColorPickerWithKey(@"label")];
      
      [self addSubview:_label];
      
      [_label setText:@"SSID"];
      
      [self monitorReachabilityStatus];
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return self;
}

- (void)dealloc {
   
   [_label removeFromSuperview];
   _label = nil;
   
   __SUPER_DEALLOC;
   
   return;
}

- (void)show {
   
   int                            nErr                                     = EFAULT;
   
   NSString                      *szWiFi                                   = nil;
   
   __TRY;
   
   szWiFi   = [NSString stringWithFormat:@"%@ : %@", [IDEAAppletRoute getSSID], [IDEAAppletRoute getIPAddress]];
   LogDebug((@"-[ServiceWiFiWindow show] : WiFi : %@", szWiFi));

   [self.label setText:szWiFi];
   [self setHidden:NO animated:YES];
   
   __CATCH(nErr);
   
   return;
}

- (void)hide {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   [self setHidden:YES animated:YES];

   __CATCH(nErr);
   
   return;
}

//监测网络状态的方法
- (void)monitorReachabilityStatus {
   
   int                            nErr                                     = EFAULT;

   __block NSString              *szWiFi                                   = nil;

   __TRY;
   
   // 网络状态改变的回调
   [self.networkReachManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus aStatus) {
      
      switch (aStatus) {
            
         case AFNetworkReachabilityStatusReachableViaWWAN: {
            
            LogDebug((@"-[ServiceWiFiWindow monitorReachabilityStatus] : networkStatus : %@", @"AFNetworkReachabilityStatusReachableViaWWAN"));
            
            break;
         }
         case AFNetworkReachabilityStatusReachableViaWiFi: {
            
            LogDebug((@"-[ServiceWiFiWindow monitorReachabilityStatus] : networkStatus : %@", @"AFNetworkReachabilityStatusReachableViaWiFi"));
            
            break;
         }
         case AFNetworkReachabilityStatusNotReachable: {
            
            LogDebug((@"-[ServiceWiFiWindow monitorReachabilityStatus] : networkStatus : %@", @"AFNetworkReachabilityStatusNotReachable"));
            
            break;
         }
         case AFNetworkReachabilityStatusUnknown:
         default: {
            
            LogDebug((@"-[ServiceWiFiWindow monitorReachabilityStatus] : networkStatus : %@", @"AFNetworkReachabilityStatusUnknown"));
            
            break;
         }
            
      } /* End switch () */
      
      @weakify(self);
      IDEA_APPLET_DISPATCH_ASYNC_ON_MAIN_QUEUE(^{

         @strongify(self);
         
         szWiFi   = [NSString stringWithFormat:@"%@ : %@", [IDEAAppletRoute getSSID], [IDEAAppletRoute getIPAddress]];
         LogDebug((@"-[ServiceWiFiWindow monitorReachabilityStatus] : WiFi : %@", szWiFi));

         [self.label setText:szWiFi];
      });
   }];
   
   // 开始监测
   [self.networkReachManager startMonitoring];
   
   __CATCH(nErr);

   return;
}

- (AFNetworkReachabilityManager *)networkReachManager {
   
   if (nil == _networkReachManager) {
      
      _networkReachManager = [AFNetworkReachabilityManager sharedManager];
      
   } /* End if () */
   
   return _networkReachManager;
}

@end
