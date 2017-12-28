//
//  LDJSONKit.h
//  NeteaseLottery
//
//  Created by yangning2014 on 14-9-12.
//  Copyright (c) 2014年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

////////////
#pragma mark Deserializing methods
////////////

@interface NSString (ld_JSONKitDeserializing)

- (id)ld_objectFromJSONString;

- (id)ld_objectFromJSONStringWithError:(NSError **)error;

@end

@interface NSData (ld_JSONKitDeserializing)
// The NSData MUST be UTF8 encoded JSON.
- (id)ld_objectFromJSONData;

- (id)ld_objectFromJSONDataWithError:(NSError **)error;

@end

////////////
#pragma mark Serializing methods
////////////

@interface NSArray (ld_JSONKitSerializing)

- (NSData *)ld_JSONData;

- (NSData *)ld_JSONDataWithError:(NSError **)error;

- (NSString *)ld_JSONString;

- (NSString *)ld_JSONStringWithError:(NSError **)error;

@end

@interface NSDictionary (ld_JSONKitSerializing)

- (NSData *)ld_JSONData;

- (NSData *)ld_JSONDataWithError:(NSError **)error;

- (NSString *)ld_JSONString;

- (NSString *)ld_JSONStringWithError:(NSError **)error;

@end


