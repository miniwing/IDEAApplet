//
//  ServiceFileSyncManager.h
//  IDEAAppletDebugger
//
//  Created by Harry on 2021/7/2.
//
//  Mail: miniwing.hz@gmail.com
//

#import <Foundation/Foundation.h>
#import <GCDWebServer/GCDWebServer.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServiceFileSyncManager : GCDWebServer

@singleton  ( ServiceFileSyncManager );

@end

@interface ServiceFileSyncManager ()

- (void)startServer;
- (void)stopServer;

@end

NS_ASSUME_NONNULL_END
