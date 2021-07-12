//
//  IDEAAppletRoute.m
//  samurai-route
//
//  Created by Harry on 2020/1/14.
//  Copyright © 2020 Harry. All rights reserved.
//

#import <arpa/inet.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

#import <SystemConfiguration/CaptiveNetwork.h>

#import "IDEAAppletRoute.h"
#import "IDEAAppletIPHelper.h"

@implementation IDEAAppletRoute

+ (NSString *)getGatewayIP {
   
   NSString       *szIP          = nil;
   struct in_addr  stGatewayAddr = {0};
   
   int r = ideaapplet_getdefaultgateway(&(stGatewayAddr.s_addr));
   
   if (r >= 0) {
      
      szIP = [NSString stringWithFormat: @"%s", inet_ntoa(stGatewayAddr)];
       
   } /* End if () */
   else {
       
      LogDebug((@"Wifi is not connected or you are using simulator Gateway ip address will be nil"));
   }
   
   return szIP;
}

+ (NSString *)getSSID {
   
   NSDictionary   *stInfo  = [self getInterfaces];
   
   if (stInfo[@"SSID"] == nil) {
      
      LogDebug((@"Wifi is not connected or you are using simulator SSID will be nil"));
   
   } /* End if () */
   
   return stInfo[@"SSID"];
}

+ (NSString *)getBSSID {
   
   NSDictionary   *stInfo  = [self getInterfaces];
   
   if (stInfo[@"BSSID"] == nil) {
      
      LogDebug((@"Wifi is not connected or you are using simulator BSSID will be nil"));
   
   } /* End if () */
   
   return stInfo[@"BSSID"];
}

+ (NSString *)getSSIDDATA {
   
   NSDictionary *stInfo = [self getInterfaces];
   
   if (stInfo[@"SSIDDATA"] == nil) {
      
      LogDebug((@"Wifi is not connected or you are using simulator SSIDDATA will be nil"));
   
   } /* End if () */
   
   return stInfo[@"SSIDDATA"];
}

+ (NSDictionary *)getInterfaces {
   
   NSArray     *stInterfaceNames = (__bridge_transfer id)CNCopySupportedInterfaces();
   
   for (NSString *szName in stInterfaceNames) {
      
      //      NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)name);
      //
      //      return info;
      
      return (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)szName);
   
   } /* End for () */
   
   return Nil;
}

+ (NSString *)getIPAddress {
   
   NSString       *szAddress     = @"error";
   struct ifaddrs *stInterfaces  = NULL;
   struct ifaddrs *stTempAddr    = NULL;
   
   int            success        = 0;
   
   // retrieve the current interfaces - returns 0 on success
   success = getifaddrs(&stInterfaces);
   
   if (success == 0) {
      
      // Loop through linked list of interfaces
      stTempAddr = stInterfaces;
      
      while (stTempAddr != NULL) {
         
         if (stTempAddr->ifa_addr->sa_family == AF_INET) {
            
            // Check if interface is en0 which is the wifi connection on the iPhone
            if ([[NSString stringWithUTF8String:stTempAddr->ifa_name] isEqualToString:@"en0"]) {
               
               // Get NSString from C String
               szAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)stTempAddr->ifa_addr)->sin_addr)];
               
            } /* End if () */
            
         } /* End if () */
          
         stTempAddr = stTempAddr->ifa_next;
      
      } /* End while () */
   
   } /* End if () */
   
   // Free memory
   freeifaddrs(stInterfaces);
   
   if ([szAddress isEqual: @"error"]) {
      
      LogDebug((@"Wifi is not connected or you are using simulator ip address will be nil"));
   
   } /* End if () */
   
   return szAddress;
}

+ (NSString *)getNetmask {
   
   NSString       *szAddress     = @"error";
   struct ifaddrs *stInterfaces  = NULL;
   struct ifaddrs *stTempAddr    = NULL;
   
   int             success       = 0;
   
   // retrieve the current interfaces - returns 0 on success
   success = getifaddrs(&stInterfaces);
   
   if (success == 0) {
      
      // Loop through linked list of interfaces
      stTempAddr = stInterfaces;
      while (stTempAddr != NULL) {
         
         if (stTempAddr->ifa_addr->sa_family == AF_INET) {
            
            // Check if interface is en0 which is the wifi connection on the iPhone
            if ([[NSString stringWithUTF8String:stTempAddr->ifa_name] isEqualToString:@"en0"]) {
               
               // Get NSString from C String //ifa_addr
               szAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)stTempAddr->ifa_netmask)->sin_addr)];
            
            } /* End if () */
         
         } /* End if () */
         
         stTempAddr = stTempAddr->ifa_next;
      
      } /* End while () */
   
   } /* End if () */
   
   // Free memory
   freeifaddrs(stInterfaces);
   
   return szAddress;
}

+ (NSString *)getDestination {
   
   NSString       *szAddress     = @"error";
   struct ifaddrs *stInterfaces  = NULL;
   struct ifaddrs *stTempAddr    = NULL;
   
   int             success       = 0;
   
   // retrieve the current interfaces - returns 0 on success
   success = getifaddrs(&stInterfaces);
   
   if (success == 0) {
      
      // Loop through linked list of interfaces
      stTempAddr = stInterfaces;
      while (stTempAddr != NULL) {
         
         if (stTempAddr->ifa_addr->sa_family == AF_INET) {
            
            // Check if interface is en0 which is the wifi connection on the iPhone
            if ([[NSString stringWithUTF8String:stTempAddr->ifa_name] isEqualToString:@"en0"]) {
               
               // Get NSString from C String //ifa_addr
               szAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)stTempAddr->ifa_dstaddr)->sin_addr)];
            
            } /* End if () */
         
         } /* End if () */
         
         stTempAddr = stTempAddr->ifa_next;
      
      } /* End while () */
   
   } /* End if () */
   
   // Free memory
   freeifaddrs(stInterfaces);
   
   return szAddress;
}

+ (BOOL)isWifiConnected {
   
   NSString *szInfo = [self getGatewayIP];
   
   if (szInfo) {
      
      return YES;
   
   } /* End if () */
   
   return NO;
}


@end
