//
//  LDJSONKit.m
//  NeteaseLottery
//
//  Created by yangning2014 on 14-9-12.
//  Copyright (c) 2014年 netease. All rights reserved.
//

#import "LDJSONKit.h"

////////////
#pragma mark Deserializing methods
////////////

@implementation NSString (ld_JSONKitDeserializing)

- (id)ld_objectFromJSONString
{
    return [self ld_objectFromJSONStringWithError:nil];
}

- (id)ld_objectFromJSONStringWithError:(NSError **)error
{
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData) {
        return nil;
    }
    id object = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:error];
    return object;
}

@end

@implementation NSData (ld_JSONKitDeserializing)
// The NSData MUST be UTF8 encoded JSON.
- (id)ld_objectFromJSONData
{
    return [self ld_objectFromJSONDataWithError:nil];
}

- (id)ld_objectFromJSONDataWithError:(NSError **)error
{
    id object = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:error];
    return object;
}

@end


////////////
#pragma mark Serializing methods
////////////

@implementation NSArray (ld_JSONKitSerializing)

- (NSData *)ld_JSONData
{
    return [self ld_JSONDataWithError:nil];
}

- (NSData *)ld_JSONDataWithError:(NSError **)error
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:error];
    return data;
}

- (NSString *)ld_JSONString
{
    return [self ld_JSONStringWithError:nil];
}

- (NSString *)ld_JSONStringWithError:(NSError **)error
{
    NSData *jsonData = [self ld_JSONDataWithError:error];
    if (!jsonData) {
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end

@implementation NSDictionary (ld_JSONKitSerializing)

- (NSData *)ld_JSONData
{
    return [self ld_JSONDataWithError:nil];
}

- (NSData *)ld_JSONDataWithError:(NSError **)error
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:error];
    return data;
}

- (NSString *)ld_JSONString
{
    return [self ld_JSONStringWithError:nil];
}

- (NSString *)ld_JSONStringWithError:(NSError **)error
{
    NSData *jsonData = [self ld_JSONDataWithError:error];
    if (!jsonData) {
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end


