//
//  LDHTTPRequestSerializer.m
//  LDCPNetworking
//
//  Created by 庞辉 on 3/9/16.
//  Copyright © 2016 xuguoxing. All rights reserved.
//

#import "LDAFHTTPRequestSerializer.h"

@implementation LDAFHTTPRequestSerializer

+(instancetype) serializer{
    LDAFHTTPRequestSerializer *serializer = (LDAFHTTPRequestSerializer *)[super serializer];
    if(serializer){
        serializer.apiEncyptPostRequestBlock = nil;
        serializer.timeStamp = nil;
    }

    return serializer;
}

/**
 * 重载了AFHTTPRequestSerialize中的此方法
 */
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                                     error:(NSError *__autoreleasing *)error
{
    NSMutableURLRequest *mutRequest = [super requestWithMethod:method URLString:URLString parameters:parameters error:error];
    if(self.apiEncyptPostRequestBlock && mutRequest && mutRequest.HTTPBody){
        NSData *encrytData = self.apiEncyptPostRequestBlock(mutRequest.HTTPBody, self.timeStamp);
        mutRequest.HTTPBody = encrytData;
    }
    
    return mutRequest;
}

@end
