//
//  UIDevice+LDIdentifier.h
//  LDKit
//
//  Created by Anchor on 17/2/28.
//  Copyright © 2017年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (LDIdentifier)

- (NSString *)ld_deviceId;

- (void)ld_removeKeychainDeviceId;

- (NSString *)ld_IDFA;

// 从iOS7及更高版本往后 系统将返回固定值“02:00:00:00:00:00”
- (NSString *)ld_MACStr;

@end

NS_ASSUME_NONNULL_END
