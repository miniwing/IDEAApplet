//
//  ServiceFileSyncManager.m
//  IDEAAppletDebugger
//
//  Created by Harry on 2021/7/2.
//
//  Mail: miniwing.hz@gmail.com
//  TEL : +(852)53054612
//

#import <GCDWebServer/GCDWebServerRequest.h>
#import <GCDWebServer/GCDWebServerDataRequest.h>
#import <GCDWebServer/GCDWebServerDataResponse.h>
#import <GCDWebServer/GCDWebServerMultiPartFormRequest.h>
#import <GCDWebServer/GCDWebServerFileResponse.h>

#import <FMDB/FMDB.h>

#import <IDEAApplet/IDEAApplet.h>

#import "ServiceFileSyncManager.h"


#define DK_SERVER_PORT  9002
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@interface ServiceFileSyncManager ()

@property (nonatomic, strong)                NSFileManager                       * fileManager;
@property (nonatomic, assign)                BOOL                                  start;       // 服务时候开启

@property (nonatomic, assign)                NSInteger                             serverPort;  // 服务时候开启

@end

@implementation ServiceFileSyncManager

- (void)dealloc {
   
   __LOG_FUNCTION;
   
   // Custom dealloc
   
   __SUPER_DEALLOC;
   
   return;
}

+ (instancetype)sharedInstance {
   
   static  ServiceFileSyncManager   *g_INSTANCE;
   static  dispatch_once_t           onceToken;
   dispatch_once(&onceToken, ^{
      g_INSTANCE = [[ServiceFileSyncManager alloc] init];
   });
   return g_INSTANCE;
}

- (instancetype)init {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   self  = [super init];
   
   if (self) {
      
      _serverPort = 9090;
      _start      = NO;
      _fileManager   = [NSFileManager defaultManager];
      
      [self setRouter];
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return self;
}

- (void)setRouter {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   @weakify(self);
#pragma mark - file
   [self addDefaultHandlerForMethod:@"GET"
                       requestClass:[GCDWebServerRequest class]
                       processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
      NSString *html = @"<html><body>请访问 <b><a href=\"https://www.dokit.cn\">www.dokit.cn</a></b> 使用该功能</body></html>";
      return [GCDWebServerDataResponse responseWithHTML:html];
   }];
   
   [self addHandlerForMethod:@"GET"
                        path:@"/getDeviceInfo"
                requestClass:[GCDWebServerRequest class]
                processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
      @strongify(self);
      return  [self getDeviceInfo];
   }];
   
   [self addHandlerForMethod:@"GET"
                        path:@"/getFileList"
                requestClass:[GCDWebServerRequest class]
                processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
      @strongify(self);
      return [self getFileList:request];
   }];
   
   [self addHandlerForMethod:@"POST"
                        path:@"/uploadFile"
                requestClass:[GCDWebServerMultiPartFormRequest class]
                processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
      @strongify(self);
      return [self uploadFile:(GCDWebServerMultiPartFormRequest *)request];
   }];
   
   [self addHandlerForMethod:@"GET"
                        path:@"/downloadFile"
                requestClass:[GCDWebServerRequest class]
                processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
      @strongify(self);
      return [self downloadFile:request];
   }];
   
   [self addHandlerForMethod:@"POST"
                        path:@"/createFolder"
                requestClass:[GCDWebServerDataRequest class]
                processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
      @strongify(self);
      return [self createFolder:(GCDWebServerDataRequest *)request];
   }];
   
   [self addHandlerForMethod:@"GET"
                        path:@"/getFileDetail"
                requestClass:[GCDWebServerRequest class]
                processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
      @strongify(self);
      return [self getFileDetail:request];
   }];
   
   [self addHandlerForMethod:@"POST"
                        path:@"/deleteFile"
                requestClass:[GCDWebServerDataRequest class]
                processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
      @strongify(self);
      return [self deleteFile:(GCDWebServerDataRequest *)request];
   }];
   
   [self addHandlerForMethod:@"POST"
                        path:@"/rename"
                requestClass:[GCDWebServerDataRequest class]
                processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
      @strongify(self);
      return [self rename:(GCDWebServerDataRequest *)request];
   }];
   
   [self addHandlerForMethod:@"POST"
                        path:@"/saveFile"
                requestClass:[GCDWebServerDataRequest class]
                processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
      @strongify(self);
      return [self saveFile:(GCDWebServerDataRequest *)request];
   }];
   
#pragma mark - database
   [self addHandlerForMethod:@"GET"
                        path:@"/getAllTable"
                requestClass:[GCDWebServerRequest class]
                processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
      @strongify(self);
      return [self getAllTable:request];
   }];
   
   [self addHandlerForMethod:@"GET"
                        path:@"/getTableData"
                requestClass:[GCDWebServerRequest class]
                processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
      @strongify(self);
      return [self getTableData:request];
   }];
   
   [self addHandlerForMethod:@"POST"
                        path:@"/insertRow"
                requestClass:[GCDWebServerDataRequest class]
                processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
      @strongify(self);
      return [self insertRow:(GCDWebServerDataRequest *)request];
   }];
   
   [self addHandlerForMethod:@"POST"
                        path:@"/updateRow"
                requestClass:[GCDWebServerDataRequest class]
                processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
      @strongify(self);
      return [self updateRow:(GCDWebServerDataRequest *)request];
   }];
   
   [self addHandlerForMethod:@"POST"
                        path:@"/deleteRow"
                requestClass:[GCDWebServerDataRequest class]
                processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
      @strongify(self);
      return [self deleteRow:(GCDWebServerDataRequest *)request];
   }];
   
   [self addDefaultHandlerForMethod:@"OPTIONS"
                       requestClass:[GCDWebServerDataRequest class]
                       processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
      GCDWebServerResponse *response = [GCDWebServerDataResponse responseWithJSONObject:@{}];
      [response setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Methods"];
      [response setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Origin"];
      [response setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Headers"];
      @strongify(self);
      return response;
   }];
   
   __CATCH(nErr);
   
   return;
}

- (NSString *)getRelativeFilePath:(NSString *)aFullPath {
   NSString *szRootPath = NSHomeDirectory();
   return [aFullPath stringByReplacingOccurrencesOfString:szRootPath withString:@""];
}

- (NSDictionary *)getCode:(NSInteger)aCode data:(NSDictionary *)aData {
   
   NSMutableDictionary  *stInfo  = [NSMutableDictionary dictionary];
   [stInfo setValue:@(aCode) forKey:@"code"];
   [stInfo setValue:aData forKey:@"data"];
   
   return stInfo;
}

- (void)startServer {
   
   [self startWithPort:DK_SERVER_PORT bonjourName:@"Hello MINIWING"];
}

#pragma mark -- 服务具体处理

- (GCDWebServerResponse *)responseWhenFailed {
   
   int                            nErr                                     = EFAULT;
   
   GCDWebServerResponse          *stWebServerResponse                      = nil;
   
   __TRY;
   
   stWebServerResponse = [GCDWebServerDataResponse responseWithJSONObject:[self getCode:0 data:nil]];
   
   [stWebServerResponse setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Origin"];
   
   __CATCH(nErr);
   
   return stWebServerResponse;
}

- (GCDWebServerResponse *)deleteRow:(GCDWebServerDataRequest *)aRequest {
   
   int                            nErr                                     = EFAULT;
   
   GCDWebServerResponse          *stWebServerResponse                      = nil;
   
   NSDictionary                  *stData                                   = nil;
   NSString                      *szDirPath                                = nil;
   
   NSString                      *szFileName                               = nil;
   NSString                      *szTableName                              = nil;
   NSArray                       *stRowDatas                               = nil;
   NSString                      *szRootPath                               = nil;
   NSString                      *szTargetPath                             = nil;
   
   FMDatabase                    *stDatabase                               = nil;
   NSMutableString               *szSQL                                    = nil;
   
   __block NSString              *szPK                                     = nil;
   __block id                     stPKValue                                = nil;
   
   __TRY;
   
   stData      = [NSJSONSerialization JSONObjectWithData:aRequest.data options:0 error:nil];
   LogDebug((@"-[ServiceFileSyncManager deleteRow:] : Data : %@", stData));
   
   szDirPath   = stData[@"dirPath"];
   LogDebug((@"-[ServiceFileSyncManager deleteRow:] : DirPath : %@", szDirPath));
   
   if ([szDirPath hasPrefix:@"/root"]) {
      
      szDirPath = [szDirPath substringFromIndex:5];
      
   } /* End if () */
   
   szFileName     = stData[@"fileName"];
   LogDebug((@"-[ServiceFileSyncManager deleteRow:] : FileName : %@", szFileName));
   
   szTableName    = stData[@"tableName"];
   LogDebug((@"-[ServiceFileSyncManager deleteRow:] : TableName : %@", szTableName));
   
   stRowDatas     = stData[@"rowDatas"];
   LogDebug((@"-[ServiceFileSyncManager deleteRow:] : RowDatas : %@", stRowDatas));
   
   szRootPath     = NSHomeDirectory();
   LogDebug((@"-[ServiceFileSyncManager deleteRow:] : RootPath : %@", szRootPath));
   
   szTargetPath   = [NSString stringWithFormat:@"%@%@%@", szRootPath, szDirPath, szFileName];
   LogDebug((@"-[ServiceFileSyncManager deleteRow:] : TargetPath : %@", szTargetPath));
   
   if (![self.fileManager fileExistsAtPath:szTargetPath]) {
      
      LogDebug((@"-[ServiceFileSyncManager deleteRow:] : %@", @"(![self.fileManager fileExistsAtPath:szTargetPath])"));
      
      stWebServerResponse  = [self responseWhenFailed];
      
      nErr  = EFAULT;
      
      break;
      
   } /* End if () */
   
   stDatabase     = [FMDatabase databaseWithPath:szTargetPath];
   LogDebug((@"-[ServiceFileSyncManager deleteRow:] : Database : %@", stDatabase));
   
   if (![stDatabase open]) {
      
      LogDebug((@"-[ServiceFileSyncManager deleteRow:] : %@", @"(![stDatabase open])"));
      
      stWebServerResponse  = [self responseWhenFailed];
      
      nErr  = EFAULT;
      
      break;
      
   } /* End if () */
   
   /**
    构造sql
    DELETE FROM tableName
    WHERE pk=pkValue;
    */
   szSQL = [NSMutableString stringWithFormat:@"DELETE FROM %@ WHERE ", szTableName];
   LogDebug((@"-[ServiceFileSyncManager deleteRow:] : SQL : %@", szSQL));
   
   [stRowDatas enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull aObject, NSUInteger aIndex, BOOL * _Nonnull aStop) {
      
      if ([aObject[@"isPrimary"] boolValue]) {
         
         szPK        = aObject[@"title"];
         stPKValue   = aObject[@"value"];
         *aStop      = YES;
         
      } /* End if () */
   }];
   
   [szSQL appendString:[NSString stringWithFormat:@"%@=%@;", szPK, stPKValue]];
   LogDebug((@"-[ServiceFileSyncManager deleteRow:] : SQL : %@", szSQL));
   
   nErr  = [stDatabase executeUpdate:szSQL] ? noErr : EFAULT;
   LogDebug((@"-[ServiceFileSyncManager deleteRow:] : [stDatabase executeUpdate:szSQL] : %ld", nErr));
   
   [stDatabase close];
   
   if (noErr == nErr) {
      
      stWebServerResponse = [GCDWebServerDataResponse responseWithJSONObject:[self getCode:200 data:nil]];
      
      [stWebServerResponse setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Origin"];
      
      break;
   }
   else {
      
      stWebServerResponse  = [self responseWhenFailed];
      
      nErr  = EFAULT;
      
   } /* End else */
   
   __CATCH(nErr);
   
   return stWebServerResponse;
}

- (GCDWebServerResponse *)updateRow:(GCDWebServerDataRequest *)aRequest {
   
   int                            nErr                                     = EFAULT;
   
   GCDWebServerResponse          *stWebServerResponse                      = nil;
   
   NSDictionary                  *stData                                   = nil;
   NSString                      *szDirPath                                = nil;
   NSString                      *szFileName                               = nil;
   NSString                      *szTableName                              = nil;
   NSArray                       *stRowDatas                               = nil;
   NSString                      *szRootPath                               = nil;
   NSString                      *szTargetPath                             = nil;
   
   FMDatabase                    *stDatabase                               = nil;
   
   NSMutableString               *szSQL                                    = nil;
   NSMutableArray                *stNewValues                              = nil;
   __block NSString              *szPK                                     = nil;
   __block id                     stPKValue                                = nil;
   
   NSString                      *szNewValues                              = nil;
   NSString                      *szCondition                              = nil;
   
   __TRY;
   
   stData      = [NSJSONSerialization JSONObjectWithData:aRequest.data options:0 error:nil];
   LogDebug((@"-[ServiceFileSyncManager updateRow:] : Data : %@", stData));
   
   szDirPath   = stData[@"dirPath"];
   LogDebug((@"-[ServiceFileSyncManager updateRow:] : DirPath : %@", szDirPath));
   
   if ([szDirPath hasPrefix:@"/root"]) {
      
      szDirPath = [szDirPath substringFromIndex:5];
      
   } /* End if () */
   LogDebug((@"-[ServiceFileSyncManager updateRow:] : DirPath : %@", szDirPath));
   
   szFileName     = stData[@"fileName"];
   LogDebug((@"-[ServiceFileSyncManager updateRow:] : FileName : %@", szFileName));
   
   szTableName    = stData[@"tableName"];
   LogDebug((@"-[ServiceFileSyncManager updateRow:] : TableName : %@", szTableName));
   
   stRowDatas     = stData[@"rowDatas"];
   LogDebug((@"-[ServiceFileSyncManager updateRow:] : RowDatas : %@", stRowDatas));
   
   szRootPath     = NSHomeDirectory();
   LogDebug((@"-[ServiceFileSyncManager updateRow:] : RootPath : %@", szRootPath));
   
   szTargetPath   = [NSString stringWithFormat:@"%@%@%@", szRootPath, szDirPath, szFileName];
   LogDebug((@"-[ServiceFileSyncManager updateRow:] : TargetPath : %@", szTargetPath));
   
   if (![self.fileManager fileExistsAtPath:szTargetPath]) {
      
      stWebServerResponse  = [self responseWhenFailed];
      
      nErr  = EFAULT;
      
      break;
      
   } /* End if () */
   
   stDatabase     = [FMDatabase databaseWithPath:szTargetPath];
   if (![stDatabase open]) {
      
      stWebServerResponse  = [self responseWhenFailed];
      
      nErr  = EFAULT;
      
      break;
      
   } /* End if () */
   
   /**
    构造sql
    UPDATE tableName
    SET title=value, title_2=value_2
    WHERE pk=pkValue;
    */
   szSQL       = [NSMutableString stringWithFormat:@"UPDATE %@ SET ", szTableName];
   LogDebug((@"-[ServiceFileSyncManager updateRow:] : SQL : %@", szSQL));
   
   stNewValues = [NSMutableArray array];
   LogDebug((@"-[ServiceFileSyncManager updateRow:] : NewValues : %@", stNewValues));
   
   @autoreleasepool {
      
      [stRowDatas enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull aObject, NSUInteger aIndex, BOOL * _Nonnull aStop) {
         
         if ([aObject[@"isPrimary"] boolValue]) {
            
            szPK        = aObject[@"title"];
            stPKValue   = aObject[@"value"];
            
         } /* End if () */
         else {
            
            NSString *szTitle = aObject[@"title"];
            id        stValue = aObject[@"value"] != nil ? aObject[@"value"] : @"NULL";
            
            if ([stValue isKindOfClass:[NSString class]] && ![stValue isEqualToString:@"NULL"]) {
               
               stValue = [NSString stringWithFormat:@"'%@'", stValue];
               
            } /* End if () */
            
            NSString *szNewValue = [NSString stringWithFormat:@"%@=%@", szTitle, stValue];
            [stNewValues addObject:szNewValue];
            
         } /* End else */
      }];
   } /* @autoreleasepool */
   
   szNewValues = [stNewValues componentsJoinedByString:@","];
   LogDebug((@"-[ServiceFileSyncManager updateRow:] : NewValues : %@", szNewValues));
   
   [szSQL appendString:szNewValues];
   LogDebug((@"-[ServiceFileSyncManager updateRow:] : SQL : %@", szSQL));
   
   szCondition = [NSString stringWithFormat:@" WHERE %@=%@;", szPK, stPKValue];
   LogDebug((@"-[ServiceFileSyncManager updateRow:] : Condition : %@", szCondition));
   
   [szSQL appendString:szCondition];
   LogDebug((@"-[ServiceFileSyncManager updateRow:] : SQL : %@", szSQL));
   
   nErr  = [stDatabase executeUpdate:szSQL] ? noErr : EFAULT;
   
   [stDatabase close];
   
   if (NO == nErr) {
      
      stWebServerResponse = [GCDWebServerDataResponse responseWithJSONObject:[self getCode:200 data:nil]];
      [stWebServerResponse setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Origin"];
      
      break;
      
   } /* End if () */
   else {
      
      stWebServerResponse  = [self responseWhenFailed];
      
      break;
      
   } /* End else */
   
   __CATCH(nErr);
   
   return stWebServerResponse;
}

- (GCDWebServerResponse *)getTableData:(GCDWebServerRequest *)aRequest {
   
   int                            nErr                                     = EFAULT;
   
   GCDWebServerResponse          *stWebServerResponse                      = nil;
   
   NSDictionary                  *stQuery                                  = nil;
   NSString                      *szDirPath                                = nil;
   NSString                      *szFileName                               = nil;
   NSString                      *szTableName                              = nil;
   NSString                      *szRootPath                               = nil;
   NSString                      *szTargetPath                             = nil;
   
   FMDatabase                    *stDatabase                               = nil;
   
   NSMutableArray                *stFieldInfo                              = nil;
   NSMutableArray                *stRows                                   = nil;
   FMResultSet                   *stTableInfo                              = nil;
   
   FMResultSet                   *stResultSet                              = nil;
   
   NSDictionary                  *stRes                                    = nil;
   
   __TRY;
   
   stQuery     = aRequest.query;
   LogDebug((@"-[ServiceFileSyncManager getTableData:] : Query : %@", stQuery));
   
   szDirPath   = stQuery[@"dirPath"];
   LogDebug((@"-[ServiceFileSyncManager getTableData:] : DirPath : %@", szDirPath));
   
   if ([szDirPath hasPrefix:@"/root"]) {
      
      szDirPath   = [szDirPath substringFromIndex:5];
      
   } /* End if () */
   LogDebug((@"-[ServiceFileSyncManager getTableData:] : DirPath : %@", szDirPath));
   
   szFileName  = stQuery[@"fileName"];
   LogDebug((@"-[ServiceFileSyncManager getTableData:] : FileName : %@", szFileName));
   
   szTableName = stQuery[@"tableName"];
   LogDebug((@"-[ServiceFileSyncManager getTableData:] : TableName : %@", szTableName));
   
   szRootPath  = NSHomeDirectory();
   LogDebug((@"-[ServiceFileSyncManager getTableData:] : RootPath : %@", szRootPath));
   
   szTargetPath   = [NSString stringWithFormat:@"%@%@%@", szRootPath, szDirPath, szFileName];
   LogDebug((@"-[ServiceFileSyncManager getTableData:] : TargetPath : %@", szTargetPath));
   
   if (![self.fileManager fileExistsAtPath:szTargetPath]) {
      
      stWebServerResponse  = [self responseWhenFailed];
      
      break;
      
   } /* End if () */
   
   stDatabase  = [FMDatabase databaseWithPath:szTargetPath];
   if (![stDatabase open]) {
      
      stWebServerResponse  = [self responseWhenFailed];
      
      break;
      
   } /* End if () */
   
   stFieldInfo = [NSMutableArray array];
   stRows      = [NSMutableArray array];
   
   stTableInfo = [stDatabase executeQuery:[NSString stringWithFormat:@"PRAGMA table_info(%@)", szTableName]];
   LogDebug((@"-[ServiceFileSyncManager getTableData:] : TableInfo : %@", stTableInfo));
   
   while ([stTableInfo next]) {
      
      NSString *szTitle = [stTableInfo stringForColumn:@"name"];
      BOOL      bIsPrimary = [stTableInfo boolForColumn:@"pk"];
      
      if (szTitle) {
         
         [stFieldInfo addObject:@{@"title"      : szTitle,
                                  @"isPrimary"  : @(bIsPrimary)}];
         
      } /* End if () */
      
   } /* End while () */
   
   stResultSet = [stDatabase executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@;", szTableName]];
   LogDebug((@"-[ServiceFileSyncManager getTableData:] : ResultSet : %@", stResultSet));
   
   while ([stResultSet next]) {
      
      NSDictionary *stRow = [NSDictionary dictionaryWithDictionary:stResultSet.resultDictionary];
      
      [stRows addObject:stRow];
      
   } /* End while () */
   
   [stDatabase close];
   
   stRes = [self getCode:200
                    data:@{ @"fieldInfo"  : stFieldInfo,
                            @"rows"       : stRows}];
   
   stWebServerResponse = [GCDWebServerDataResponse responseWithJSONObject:stRes];
   [stWebServerResponse setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Origin"];
   
   __CATCH(nErr);
   
   return stWebServerResponse;
}

- (GCDWebServerResponse *)insertRow:(GCDWebServerDataRequest *)aRequest {
   
   int                            nErr                                     = EFAULT;
   
   GCDWebServerResponse          *stWebServerResponse                      = nil;
   
   NSDictionary                  *stData                                   = nil;
   NSString                      *szDirPath                                = nil;
   NSString                      *szFileName                               = nil;
   NSString                      *szTableName                              = nil;
   NSArray                       *stRowDatas                               = nil;
   NSString                      *szRootPath                               = nil;
   NSString                      *szTargetPath                             = nil;
   
   FMDatabase                    *stDatabase                               = nil;
   NSMutableArray                *stColumnArrs                             = nil;
   FMResultSet                   *stTableInfo                              = nil;
   
   NSString                      *szColumns                                = nil;
   
   NSString                      *szAllValues                              = nil;
   
   __TRY;
   
   stData      = [NSJSONSerialization JSONObjectWithData:aRequest.data options:0 error:nil];
   LogDebug((@"-[ServiceFileSyncManager insertRow:] : Data : %@", stData));
   
   szDirPath   = stData[@"dirPath"];
   LogDebug((@"-[ServiceFileSyncManager insertRow:] : DirPath : %@", szDirPath));
   
   if ([szDirPath hasPrefix:@"/root"]) {
      szDirPath   = [szDirPath substringFromIndex:5];
   }
   LogDebug((@"-[ServiceFileSyncManager insertRow:] : DirPath : %@", szDirPath));
   
   szFileName  = stData[@"fileName"];
   LogDebug((@"-[ServiceFileSyncManager insertRow:] : FileName : %@", szFileName));
   
   szTableName    = stData[@"tableName"];
   LogDebug((@"-[ServiceFileSyncManager insertRow:] : TableName : %@", szTableName));
   
   stRowDatas     = stData[@"rowDatas"];
   LogDebug((@"-[ServiceFileSyncManager insertRow:] : RowDatas : %@", stRowDatas));
   
   szRootPath     = NSHomeDirectory();
   LogDebug((@"-[ServiceFileSyncManager insertRow:] : RootPath : %@", szRootPath));
   
   szTargetPath   = [NSString stringWithFormat:@"%@%@%@", szRootPath, szDirPath, szFileName];
   LogDebug((@"-[ServiceFileSyncManager insertRow:] : TargetPath : %@", szTargetPath));
   
   if (![self.fileManager fileExistsAtPath:szTargetPath]) {
      
      stWebServerResponse  = [self responseWhenFailed];
      
      break;
      
   } /* End if () */
   
   stDatabase  = [FMDatabase databaseWithPath:szTargetPath];
   
   if (![stDatabase open]) {
      stWebServerResponse  = [self responseWhenFailed];
      
      break;
      
   } /* End if () */
   
   //获取列名
   stColumnArrs   = [NSMutableArray array];
   stTableInfo    = [stDatabase executeQuery:[NSString stringWithFormat:@"PRAGMA table_info(%@)", szTableName]];
   while ([stTableInfo next]) {
      
      NSString *szColumnName = [stTableInfo stringForColumn:@"name"];
      
      if (szColumnName) {
         [stColumnArrs addObject:szColumnName];
         
      } /* End if () */
      
   } /* End while () */
   
   szColumns = [stColumnArrs componentsJoinedByString:@","];
   LogDebug((@"-[ServiceFileSyncManager insertRow:] : Columns : %@", szColumns));
   
   if (0 < stRowDatas.count) {
      
      NSMutableString   *szSQL         = [NSMutableString stringWithFormat:@"INSERT INTO %@(%@) VALUES ", szTableName, szColumns];
      LogDebug((@"-[ServiceFileSyncManager insertRow:] : SQL : %@", szSQL));
      
      NSMutableArray    *stAllValues   = [NSMutableArray array];
      
      @autoreleasepool {
         /**
          构造sql
          INSERT INTO
          tableName(key_1,key_2,key_3)
          VALUES
          (value_1,value_2,value_3),
          */
         [stRowDatas enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull aData, NSUInteger aIndex, BOOL * _Nonnull aStop) {
            
            id  stValue = aData[@"value"] ? : @"NULL";
            
            if ([stValue isKindOfClass:[NSString class]] && ![stValue isEqualToString:@"NULL"]) {
               
               stValue = [NSString stringWithFormat:@"'%@'", stValue];
               
            } /* End if () */
            
            [stAllValues addObject:stValue];
         }];
      } /* @autoreleasepool */
      
      szAllValues = [NSString stringWithFormat:@"(%@)", [stAllValues componentsJoinedByString:@","]];
      LogDebug((@"-[ServiceFileSyncManager insertRow:] : AllValues : %@", szAllValues));
      
      [szSQL appendString:szAllValues];
      [szSQL appendString:@";"];
      LogDebug((@"-[ServiceFileSyncManager insertRow:] : SQL : %@", szSQL));
      
      nErr  = [stDatabase executeUpdate:szSQL] ? noErr : EFAULT;
      
   } /* End if () */
   
   [stDatabase close];
   
   if (noErr == nErr) {
      
      stWebServerResponse = [GCDWebServerDataResponse responseWithJSONObject:[self getCode:200 data:nil]];
      [stWebServerResponse setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Origin"];
      
      break;
      
   } /* End if () */
   else {
      
      stWebServerResponse  = [self responseWhenFailed];
      
      break;
      
   } /* End else */
   
   __CATCH(nErr);
   
   return stWebServerResponse;
}

- (GCDWebServerResponse *)getAllTable:(GCDWebServerRequest *)aRequest {
   
   int                            nErr                                     = EFAULT;
   
   GCDWebServerResponse          *stWebServerResponse                      = nil;

   NSDictionary                  *stQuery                                  = nil;
   
   NSString                      *szRootPath                               = nil;
   NSString                      *szDirPath                                = nil;
   NSString                      *szFileName                               = nil;
   NSString                      *szTargetPath                             = nil;

   FMDatabase                    *stDatabase                               = nil;
   
   NSString                      *szSQL                                    = nil;
   FMResultSet                   *stResultSet                              = nil;
   
   NSMutableArray                *stDatas                                  = nil;
   NSMutableDictionary           *stResponse                               = nil;
   
   __TRY;

   stQuery = aRequest.query;
   szDirPath = stQuery[@"dirPath"];
   if ([szDirPath hasPrefix:@"/root"]) {
      szDirPath = [szDirPath substringFromIndex:5];
   }
   szFileName  = stQuery[@"fileName"];
   szRootPath  = NSHomeDirectory();
   szTargetPath= [NSString stringWithFormat:@"%@%@%@", szRootPath, szDirPath, szFileName];
   
   if (![self.fileManager fileExistsAtPath:szTargetPath]) {
      
      stWebServerResponse  = [self responseWhenFailed];
      
      break;
   }
   
   stDatabase  = [FMDatabase databaseWithPath:szTargetPath];
   if (![stDatabase open]) {
      
      stWebServerResponse  = [self responseWhenFailed];
      
      break;
   }
   
   szSQL       = @"SELECT * FROM sqlite_master WHERE type='table' ORDER BY name;";
   stResultSet = [stDatabase executeQuery:szSQL];
   stDatas     = [NSMutableArray array];
   while ([stResultSet next]) {
      NSString *name = [stResultSet stringForColumnIndex:1];
      [stDatas addObject:name];
   }
   
   [stDatabase close];
   
   stResponse  = [NSMutableDictionary dictionary];
   [stResponse setValue:@(200) forKey:@"code"];
   [stResponse setValue:stDatas forKey:@"data"];
   
   stWebServerResponse = [GCDWebServerDataResponse responseWithJSONObject:stResponse];
   [stWebServerResponse setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Origin"];
   
   __CATCH(nErr);
   
   return stWebServerResponse;
}

- (GCDWebServerResponse *)saveFile:(GCDWebServerDataRequest *)aRequest {
   
   int                            nErr                                     = EFAULT;
   
   GCDWebServerResponse          *stWebServerResponse                      = nil;
      
   NSDictionary                  *stResponse                               = nil;

   NSDictionary                  *stData                                   = nil;
   NSString                      *szDirPath                                = nil;
   NSString                      *szFileName                               = nil;
   NSString                      *szContent                                = nil;
   NSString                      *szRootPath                               = nil;
   NSString                      *szTargetPath                             = nil;

   __TRY;

   NSDictionary *stData = [NSJSONSerialization JSONObjectWithData:aRequest.data options:0 error:nil];
   NSString *szDirPath = stData[@"dirPath"];
   if ([szDirPath hasPrefix:@"/root"]) {
      szDirPath = [szDirPath substringFromIndex:5];
   }
   szFileName     = stData[@"fileName"];
   szContent      = stData[@"content"];
   szRootPath     = NSHomeDirectory();
   szTargetPath   = [NSString stringWithFormat:@"%@%@%@", szRootPath, szDirPath, szFileName];
   
   if (![self.fileManager createFileAtPath:szTargetPath contents:[szContent dataUsingEncoding:NSUTF8StringEncoding] attributes:nil]) {
      LogDebug((@"Failed save file at \"%@\"", szTargetPath));
      stResponse = [self getCode:0 data:nil];
   }
   else{
      stResponse = [self getCode:200 data:nil];
   }
   
   stWebServerResponse = [GCDWebServerDataResponse responseWithJSONObject:stResponse];
   [stWebServerResponse setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Origin"];
   
   __CATCH(nErr);
   
   return stWebServerResponse;
}

- (GCDWebServerResponse *)deleteFile:(GCDWebServerDataRequest *)aRequest {
   
   int                            nErr                                     = EFAULT;
   
   GCDWebServerResponse          *stWebServerResponse                      = nil;
      
   NSDictionary                  *stResponse                               = nil;

   NSDictionary                  *stData                                   = nil;
   NSString                      *szDirPath                                = nil;
   NSString                      *szFileName                               = nil;
   NSString                      *szRootPath                               = nil;
   NSString                      *szTargetPath                             = nil;
   NSError                       *stError                                  = nil;

   __TRY;
   
   stData      = [NSJSONSerialization JSONObjectWithData:aRequest.data options:0 error:nil];
   szDirPath   = stData[@"dirPath"];
   
   if ([szDirPath hasPrefix:@"/root"]) {
      szDirPath = [szDirPath substringFromIndex:5];
   }
   
   szFileName     = stData[@"fileName"];
   szRootPath     = NSHomeDirectory();
   szTargetPath   = [NSString stringWithFormat:@"%@%@%@", szRootPath, szDirPath, szFileName];
   
   if (![self.fileManager removeItemAtPath:szTargetPath error:&stError]) {
      
      LogDebug((@"Failed deleting file at \"%@\"", szTargetPath));
      stResponse = [self getCode:0 data:nil];
   }
   else {
      
      stResponse = [self getCode:200 data:nil];
   }
   
   stWebServerResponse = [GCDWebServerDataResponse responseWithJSONObject:stResponse];
   [stWebServerResponse setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Origin"];
   
   __CATCH(nErr);
   
   return stWebServerResponse;
}

- (GCDWebServerResponse *)rename:(GCDWebServerDataRequest *)aRequest {
   
   int                            nErr                                     = EFAULT;
   
   GCDWebServerResponse          *stWebServerResponse                      = nil;
   
   NSDictionary                  *stResponse                               = nil;

   
   NSDictionary                  *stData                                   = nil;
   NSString                      *szDirPath                                = nil;
   NSString                      *szOldName                                = nil;
   NSString                      *szNewName                                = nil;
   NSString                      *szRootPath                               = nil;
   NSString                      *szTargetPath                             = nil;
   NSString                      *szDestinationPath                        = nil;
   NSError                       *stError                                  = nil;

   __TRY;
   
   stData = [NSJSONSerialization JSONObjectWithData:aRequest.data options:0 error:nil];
   szDirPath = stData[@"dirPath"];
   if ([szDirPath hasPrefix:@"/root"]) {
      szDirPath = [szDirPath substringFromIndex:5];
   }
   szOldName         = stData[@"oldName"];
   szNewName         = stData[@"newName"];
   szRootPath        = NSHomeDirectory();
   szTargetPath      = [NSString stringWithFormat:@"%@%@%@", szRootPath, szDirPath, szOldName];
   szDestinationPath = [NSString stringWithFormat:@"%@%@%@", szRootPath, szDirPath, szNewName];
   
   if (![self.fileManager moveItemAtPath:szTargetPath toPath:szDestinationPath error:&stError]) {
      LogDebug((@"Failed rename file at \"%@\"", szTargetPath));
      stResponse = [self getCode:0 data:nil];
   }
   else {
      stResponse = [self getCode:200 data:nil];
   }
   
   stWebServerResponse = [GCDWebServerDataResponse responseWithJSONObject:stResponse];
   [stWebServerResponse setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Origin"];
   
   __CATCH(nErr);
   
   return stWebServerResponse;
}


- (GCDWebServerResponse *)getDeviceInfo {
   
   int                            nErr                                     = EFAULT;
   
   GCDWebServerResponse          *stWebServerResponse                      = nil;
   
   NSDictionary                  *stResponse                               = nil;
   
   NSMutableDictionary           *stDic                                    = nil;
   
   __TRY;
   
   stDic = [NSMutableDictionary dictionary];
   [stDic setValue:[UIDevice currentDevice].name forKey:@"deviceName"];
   [stDic setValue:[ServiceFileSyncManager uuid] forKey:@"deviceId"];
   [stDic setValue:[NSString stringWithFormat:@"%@:%@", [ServiceFileSyncManager getIPAddress:YES], @(DK_SERVER_PORT)] forKey:@"deviceIp"];
   
   stResponse = [self getCode:200 data:stDic];
   stWebServerResponse = [GCDWebServerDataResponse responseWithJSONObject:stResponse];
   [stWebServerResponse setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Origin"];
   
   __CATCH(nErr);
   
   return stWebServerResponse;
}

- (GCDWebServerResponse *)getFileList:(GCDWebServerRequest *)aRequest{
   
   int                            nErr                                     = EFAULT;
   
   GCDWebServerResponse          *stWebServerResponse                      = nil;
   
   NSDictionary                  *stQuery                                  = nil;
   
   NSString                      *szRootPath                               = nil;
   NSString                      *szDirPath                                = nil;
   NSString                      *szRealDirPath                            = nil;
   NSString                      *szTargetPath                             = nil;
   
   NSMutableArray                *stFiles                                  = nil;
   NSError                       *stError                                  = nil;
   NSArray                       *stPaths                                  = nil;
   
   NSDictionary                  *stResponse                               = nil;
   
   __TRY;
   
   stQuery        = aRequest.query;
   szDirPath      = stQuery[@"dirPath"];
   szRealDirPath  = szDirPath;
   
   if ([szRealDirPath hasPrefix:@"/root"]) {
      
      szRealDirPath = [szRealDirPath substringFromIndex:5];
      
   } /* End if () */
   
   szRootPath     = NSHomeDirectory();
   szTargetPath   = [NSString stringWithFormat:@"%@%@",szRootPath,szRealDirPath];
   
   stFiles  = [NSMutableArray array];
   stError  = nil;
   stPaths  = [self.fileManager contentsOfDirectoryAtPath:szTargetPath error:&stError];
   
   for (NSString *szPath in stPaths) {
      
      BOOL      isDir = false;
      NSString *szFullPath = [szTargetPath stringByAppendingPathComponent:szPath];
      
      [self.fileManager fileExistsAtPath:szFullPath isDirectory:&isDir];
      
      NSMutableDictionary *stDic = [NSMutableDictionary dictionary];
      stDic[@"dirPath"]    = szDirPath;
      stDic[@"isRootPath"] = [szPath isEqualToString:szRootPath] ? @YES : @NO;
      stDic[@"fileName"]   = szPath;
      //        dic[@"fileUrl"] = [self getRelativeFilePath:fullPath];
      if (isDir) {
         stDic[@"fileType"] = @"folder";
      }
      else {
         stDic[@"fileType"] = [szPath pathExtension];
      }
      
      NSDictionary   *stFileAttributes = [self.fileManager attributesOfItemAtPath:szFullPath error:nil];
      NSDate         *stModifyDate     = [stFileAttributes objectForKey:NSFileModificationDate];
      stDic[@"modifyTime"] = @([stModifyDate timeIntervalSince1970]*1000);
      [stFiles addObject:stDic];
   }
   
   NSMutableDictionary *stData = [NSMutableDictionary dictionary];
   [stData setValue:szDirPath forKey:@"dirPath"];
   [stData setValue:[ServiceFileSyncManager uuid] forKey:@"deviceId"];
   [stData setValue:stFiles forKey:@"fileList"];
   
   stResponse = [self getCode:200 data:stData];
   
   stWebServerResponse = [GCDWebServerDataResponse responseWithJSONObject:stResponse];
   [stWebServerResponse setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Origin"];
   
   __CATCH(nErr);
   
   return stWebServerResponse;
}

- (GCDWebServerResponse*)uploadFile:(GCDWebServerMultiPartFormRequest*)aRequest {
   
   int                            nErr                                     = EFAULT;
   
   GCDWebServerResponse          *stWebServerResponse                      = nil;
   
   GCDWebServerMultiPartFile     *stFile                                   = nil;
   
   NSString                      *szRootPath                               = nil;
   NSString                      *szDirPath                                = nil;
   NSString                      *szTargetPath                             = nil;
   
   NSError                       *stError                                  = nil;
   
   NSDictionary                  *stResponse                               = nil;
   
   __TRY;
   
   stFile = [aRequest firstFileForControlName:@"file"];
   szDirPath = [[aRequest firstArgumentForControlName:@"dirPath"] string];
   if ([szDirPath hasPrefix:@"/root"]) {
      szDirPath = [szDirPath substringFromIndex:5];
   }
   szRootPath = NSHomeDirectory();
   szTargetPath = [NSString stringWithFormat:@"%@%@%@", szRootPath, szDirPath, stFile.fileName];
   
   if (![self.fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@%@", szRootPath, szDirPath]]) {
      [self.fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@%@", szRootPath, szDirPath]
                  withIntermediateDirectories:YES
                                   attributes:nil error:nil];
   }
   
   if (![self.fileManager moveItemAtPath:stFile.temporaryPath toPath:szTargetPath error:&stError]) {
      
      LogDebug((@"Failed moving uploaded file to \"%@\"", szTargetPath));
      stResponse = [self getCode:0 data:nil];
   }
   else {
      stResponse = [self getCode:200 data:nil];
   }
   
   stWebServerResponse = [GCDWebServerDataResponse responseWithJSONObject:stResponse];
   [stWebServerResponse setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Origin"];
   
   __CATCH(nErr);
   
   return stWebServerResponse;
}

- (GCDWebServerResponse *)downloadFile:(GCDWebServerRequest *)aRequest {
   
   int                            nErr                                     = EFAULT;
   
   GCDWebServerResponse          *stWebServerResponse                      = nil;
   
   NSString                      *szRootPath                               = nil;
   NSString                      *szDirPath                                = nil;
   NSString                      *szFileName                               = nil;
   NSString                      *szTargetPath                             = nil;
   
   NSDictionary                  *stResponse                               = nil;
   BOOL                           bIsDirectory                             = NO;
   
   __TRY;
   
   szRootPath  = NSHomeDirectory();
   szDirPath   = [[aRequest query] objectForKey:@"dirPath"];
   if ([szDirPath hasPrefix:@"/root"]) {
      szDirPath   = [szDirPath substringFromIndex:5];
   }
   szFileName     = [[aRequest query] objectForKey:@"fileName"];
   szTargetPath   = [NSString stringWithFormat:@"%@%@%@",szRootPath,szDirPath,szFileName];
   
   if (![self.fileManager fileExistsAtPath:szTargetPath isDirectory:&bIsDirectory]) {
      
      LogDebug((@"\"%@\" does not exist", szTargetPath));
      stResponse = [self getCode:0 data:nil];
      stWebServerResponse = [GCDWebServerDataResponse responseWithJSONObject:stResponse];
      [stWebServerResponse setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Origin"];
      
   } /* End if () */
   else {
      
      stWebServerResponse = [GCDWebServerFileResponse responseWithFile:szTargetPath isAttachment:YES];
      [stWebServerResponse setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Origin"];
      
   } /* End else */
   
   __CATCH(nErr);
   
   return stWebServerResponse;
}

- (GCDWebServerResponse *)createFolder:(GCDWebServerDataRequest *)aRequest {
   
   int                            nErr                                     = EFAULT;
   
   GCDWebServerResponse          *stWebServerResponse                      = nil;
   
   NSDictionary                  *stData                                   = nil;
   NSString                      *szDirPath                                = nil;
   NSString                      *szFileName                               = nil;
   NSString                      *szRootPath                               = nil;
   NSString                      *szTargetPath                             = nil;
   NSError                       *stError                                  = nil;
   
   NSDictionary                  *stResponse                               = nil;
   
   __TRY;
   
   stData      = [NSJSONSerialization JSONObjectWithData:aRequest.data options:0 error:nil];
   LogDebug((@"-[ServiceFileSyncManager createFolder:] : Data : %@", stData));
   
   szDirPath   = stData[@"dirPath"];
   LogDebug((@"-[ServiceFileSyncManager createFolder:] : DirPath : %@", szDirPath));
   
   if ([szDirPath hasPrefix:@"/root"]) {
      
      szDirPath = [szDirPath substringFromIndex:5];
      
   } /* End if () */
   LogDebug((@"-[ServiceFileSyncManager createFolder:] : DirPath : %@", szDirPath));
   
   szFileName     = stData[@"fileName"];
   LogDebug((@"-[ServiceFileSyncManager createFolder:] : FileName : %@", szFileName));
   
   szRootPath     = NSHomeDirectory();
   LogDebug((@"-[ServiceFileSyncManager createFolder:] : RootPath : %@", szRootPath));
   
   szTargetPath   = [NSString stringWithFormat:@"%@%@%@",szRootPath,szDirPath,szFileName];
   LogDebug((@"-[ServiceFileSyncManager createFolder:] : TargetPath : %@", szTargetPath));
   
   if (![[NSFileManager defaultManager] createDirectoryAtPath:szTargetPath withIntermediateDirectories:YES attributes:nil error:&stError]) {
      
      LogDebug((@"-[ServiceFileSyncManager createFolder:] : Failed creating directory \"%@\"", szTargetPath));
      stResponse = [self getCode:0 data:nil];
      
   } /* End if () */
   else {
      
      stResponse = [self getCode:200 data:nil];
      
   } /* End else */
   
   stWebServerResponse = [GCDWebServerDataResponse responseWithJSONObject:stResponse];
   [stWebServerResponse setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Origin"];
   
   __CATCH(nErr);
   
   return stWebServerResponse;
}

- (GCDWebServerResponse *)getFileDetail:(GCDWebServerRequest *)aRequest {
   
   int                            nErr                                     = EFAULT;
   
   GCDWebServerResponse          *stWebServerResponse                      = nil;
   
   NSString                      *szRootPath                               = nil;
   NSString                      *szDirPath                                = nil;
   
   NSString                      *szFileName                               = nil;
   NSString                      *szTargetPath                             = nil;
   
   NSDictionary                  *stResponse                               = nil;
   
   __TRY;
   
   szRootPath = NSHomeDirectory();
   LogDebug((@"-[ServiceFileSyncManager getFileDetail:] : RootPath : %@", szRootPath));
   
   szDirPath = [[aRequest query] objectForKey:@"dirPath"];
   LogDebug((@"-[ServiceFileSyncManager getFileDetail:] : DirPath : %@", szDirPath));
   
   if ([szDirPath hasPrefix:@"/root"]) {
      
      szDirPath = [szDirPath substringFromIndex:5];
      
   } /* End if () */
   
   szFileName     = [[aRequest query] objectForKey:@"fileName"];
   szTargetPath   = [NSString stringWithFormat:@"%@%@%@",szRootPath,szDirPath,szFileName];
   
   if ([self.fileManager fileExistsAtPath:szTargetPath]) {
      
      NSMutableDictionary  *stDic         = [NSMutableDictionary dictionary];
      NSString             *szFileContent = [[NSString alloc] initWithData:[self.fileManager contentsAtPath:szTargetPath] encoding:NSUTF8StringEncoding];
      
      [stDic setValue:szTargetPath.pathExtension forKey:@"fileType"];
      [stDic setValue:szFileContent forKey:@"fileContent"];
      
      stResponse = [self getCode:200 data:stDic];
      
   } /* End if () */
   else {
      LogDebug((@"File not founded at \"%@\"", szTargetPath));
      
      stResponse = [self getCode:0 data:nil];
      
   } /* End else */
   
   stWebServerResponse = [GCDWebServerDataResponse responseWithJSONObject:stResponse];
   [stWebServerResponse setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Origin"];
   
   __CATCH(nErr);
   
   return stWebServerResponse;
}

+ (NSString *)uuid {
   NSUserDefaults   *stUserDefaults   = [NSUserDefaults standardUserDefaults];
   NSString         *szUUID           = [stUserDefaults objectForKey:@"UUID"];
   if (!szUUID) {
      szUUID = [[NSUUID UUID] UUIDString];
      [stUserDefaults setObject:szUUID forKey:@"UUID"];
      [stUserDefaults synchronize];
   }
   return szUUID;
}

+ (NSString *)getIPAddress:(BOOL)preferIPv4 {
   
   NSArray *searchArray = preferIPv4 ?
   @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
   @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
   
   NSDictionary *addresses = [[self class] getIPAddresses];
   __block NSString *address;
   [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
    {
      address = addresses[key];
      if(address) *stop = YES;
   } ];
   return address ? address : @"0.0.0.0";
}

//获取所有相关IP信息
+ (NSDictionary *)getIPAddresses {
   NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
   
   // retrieve the current interfaces - returns 0 on success
   struct ifaddrs *interfaces;
   if(!getifaddrs(&interfaces)) {
      // Loop through linked list of interfaces
      struct ifaddrs *interface;
      for(interface=interfaces; interface; interface=interface->ifa_next) {
         if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
            continue; // deeply nested code harder to read
         }
         const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
         char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
         if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
            NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
            NSString *type;
            if(addr->sin_family == AF_INET) {
               if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                  type = IP_ADDR_IPv4;
               }
            } else {
               const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
               if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                  type = IP_ADDR_IPv6;
               }
            }
            if(type) {
               NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
               addresses[key] = [NSString stringWithUTF8String:addrBuf];
            }
         }
      }
      // Free memory
      freeifaddrs(interfaces);
   }
   return [addresses count] ? addresses : nil;
}

@end
