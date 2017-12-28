//
//  ServiceManager.h
//  yixin_iphone
//
//  Created by Xuhui on 13-11-18.
//  Copyright (c) 2013年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BridgeService;

@interface ExportDetail : NSObject

@property (strong, nonatomic) NSString *showName;
@property (strong, nonatomic) NSString *realName;
@property (assign, nonatomic) NSInteger level;

@end

@interface ServiceInfo : NSObject

@property (strong, nonatomic) NSString *domain;
@property (assign, nonatomic) BOOL isLocal;
@property (strong, nonatomic) NSMutableDictionary *exports;
@property (strong, nonatomic) BridgeService *instance;

- (ExportDetail *)getDetailByShowName:(NSString *)name;

@end

@interface ServiceManager : NSObject

- (id)initWithConfig:(NSArray *)configuration;
- (ServiceInfo *)getServiceInfo:(NSString *)name;
- (id)getServiceByDomain:(NSString *)domain;
- (void)resetWithServiceConfig:(NSArray *)configuration;

- (SEL)showNameToSelector:(NSString *)name;

- (NSSet *)getExports;

@end
