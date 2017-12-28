//
//  LDAPIConfig.m
//  LDCPNetworking
//
//  Created by philon on 16/7/20.
//  Copyright © 2016年 xuguoxing. All rights reserved.
//

#import "LDAPIConfig.h"
#import "LDAPIDefines.h"

@implementation LDAPIConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.apiEncyptPostRequestBlock  = nil;
        self.maxHttpConnectionPerHost   = MAX_HTTP_CONNECTION_PER_HOST;
        self.sslHosts                   = [NSMutableSet set];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    LDAPIConfig *config                 = [[LDAPIConfig allocWithZone:zone] init];
    config.userAgent                    = self.userAgent;
    config.interfaceHeader              = self.interfaceHeader;
    config.apiEncyptPostRequestBlock    = self.apiEncyptPostRequestBlock;
    config.maxHttpConnectionPerHost     = self.maxHttpConnectionPerHost;
    config.sslHosts                     = self.sslHosts;
    return config;
}

@end
