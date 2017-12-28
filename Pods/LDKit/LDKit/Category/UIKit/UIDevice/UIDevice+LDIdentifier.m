//
//  UIDevice+LDIdentifier.m
//  LDKit
//
//  Created by Anchor on 17/2/28.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "UIDevice+LDIdentifier.h"
#import "NSString+LDEncode.h"
#import "UIDevice+LDHardware.h"
#import "LDKeychain.h"
#import <AdSupport/AdSupport.h>

@implementation UIDevice (LDIdentifier)

// IDFV [UIDevice identifierForVendor];
- (NSString *)ld_deviceId
{
    static NSString *deviceId;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceId = [LDKeychain ld_keychainStringFromMatchingIdentifier:@"DeviceId"];
        if (!deviceId) {
            deviceId = [[self identifierForVendor] UUIDString];
            if (deviceId) {
                [LDKeychain ld_createKeychainValue:deviceId forIdentifier:@"DeviceId"];
            } else {
                NSAssert(0, @"Device ID not found");
                deviceId = [self ld_randomDeviceId];
            }
        }
    });
    return deviceId;
}

- (void)ld_removeKeychainDeviceId
{
    [LDKeychain ld_deleteItemFromKeychainWithIdentifier:@"DeviceId"];
}

- (NSString *)ld_IDFA
{
    // isAdvertisingTrackingEnabled关掉时 IDFA好像是0000...
    /**
     Important
     In iOS 10.0 and later, the value of advertisingIdentifier is all zeroes when the user has limited ad tracking.
     If the value is nil, wait and get the value again later. This happens, for example, after the device has been restarted but before the user has unlocked the device.
     */
    NSString *IDFAString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return IDFAString;
}

- (NSString *)ld_MACStr
{
    NSString *macaddress = [[self class] ld_macaddress];
    // 从iOS7及更高版本往后，如果你向ios设备请求获取mac地址，系统将返回一个固定值“02:00:00:00:00:00”
    if (macaddress && ![macaddress isEqualToString:@"02:00:00:00:00:00"]) {
        return [macaddress stringByReplacingOccurrencesOfString:@":" withString:@""];
    } else {
        return nil;
    }
}

- (NSString *)ld_randomDeviceId
{
    srandom([[NSDate date] timeIntervalSince1970]);
    NSString *uniqueId = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", (Byte) random(), (Byte) random(), (Byte) random(), (Byte) random(), (Byte) random(), (Byte) random()];
    return uniqueId;
}

/*
- (NSString *)macOrAdvertisingId
{
    if ([[self systemVersion] floatValue] >= 7.0) {
        return [self ld_IDFA];
    } else {
        return [self getMACString];
    }
}*/

/*
 - (NSString *)ld_macDeviceIdentifier
 {
 NSString *macaddress = [UIDevice ld_macaddress];
 NSString *uniqueIdentifier = [macaddress ld_md5String];
 return uniqueIdentifier ? uniqueIdentifier : @""; // 部分黑苹果没有en0 此时返回 @""
 }*/

@end
