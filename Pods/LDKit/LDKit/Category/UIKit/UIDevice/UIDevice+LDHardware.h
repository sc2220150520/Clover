//
//  UIDevice+LDHardware.h
//  LDKitDemo
//
//  Created by lixingdong on 16/8/8.
//  written by xuguoxing on 14-4-21.
//  written by ITxiansheng on 16/8/2.
//  Copyright © 2016年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

//机器具体型号
typedef NS_ENUM(NSInteger, UIDevicePlatform) {
    
    UIDeviceUnknown,
    
    UIDeviceSimulator,
    UIDeviceSimulatoriPhone,
    UIDeviceSimulatoriPad,
    UIDeviceSimulatorAppleTV,
    
    UIDevice1GiPhone,
    UIDevice3GiPhone,
    UIDevice3GSiPhone,
    UIDevice4iPhone,
    UIDevice4SiPhone,
    UIDevice5iPhone,
    UIDevice5CiPhone,
    UIDevice5SiPhone,
    UIDevice6iPhone,
    UIDevice6PlusiPhone,
    UIDevice6SiPhone,
    UIDevice6SPlusiPhone,
    UIDevice5SEiPhone,
    
    //ipod
    UIDevice1GiPod,
    UIDevice2GiPod,
    UIDevice3GiPod,
    UIDevice4GiPod,
    UIDevice5GiPod,
    UIDevice6GiPod,
    
    //ipad
    UIDevice1GiPad,
    UIDevice1MiniGiPad,
    UIDevice2MiniGiPad,
    UIDevice3MiniGiPad,
    UIDevice4MiniGiPad,
    
    UIDevice2GiPad,
    UIDevice3GiPad,
    UIDeviceiPadAir,
    UIDeviceiPadAir2,
    UIDevice4GiPad,
    UIDeviceiPadPro9_7,
    UIDeviceiPadPro12_9,
    
    //tv
    UIDeviceAppleTV2,
    UIDeviceAppleTV3,
    UIDeviceAppleTV4,
    //未知设备
    UIDeviceUnknowniPhone,
    UIDeviceUnknowniPod,
    UIDeviceUnknowniPad,
    UIDeviceUnknownAppleTV,
    UIDeviceIFPGA,
    
};

//机器家族型号
typedef NS_ENUM(NSInteger, UIDeviceFamily){
    UIDeviceFamilyiPhone,
    UIDeviceFamilyiPod,
    UIDeviceFamilyiPad,
    UIDeviceFamilyAppleTV,
    UIDeviceFamilyUnknown,
};

@interface UIDevice (LDHardware)

//- (NSString *)platform;

+ (NSString *)ld_humanReadablePlatform;

/**
 *  @author ITxiansheng, 16-08-02 16:08:21
 *
 *  @brief 返回描述设备的字符串
 *
 *  @return 设备字符串
 */
+ (NSString *) ld_platform;
/**
 *  @author ITxiansheng, 16-08-02 16:08:46
 *
 *  @brief 返回机器的具体型号
 *
 *  @return 机器型号
 */
+ (NSUInteger) ld_platformType;

/**
 *  @author ITxiansheng, 16-08-02 16:08:10
 *
 *  @brief 返回CPU 频率
 *
 *  @return 频率值
 */
+ (NSUInteger) ld_cpuFrequency;
/**
 *  @author ITxiansheng, 16-08-02 16:08:01
 *
 *  @brief 返回总线频率
 *
 *  @return 总线频率
 */
+ (NSUInteger) ld_busFrequency;

/**
 *  @author ITxiansheng, 16-08-02 16:08:20
 *
 *  @brief 返回cpu个数
 *
 *  @return CPU个数
 */
+ (NSUInteger) ld_cpuCount;

/**
 *  @author ITxiansheng, 16-08-02 16:08:40
 *
 *  @brief 返回总内存大小
 *
 *  @return 内存大小
 */
+ (NSUInteger) ld_totalMemory;

/**
 *  @author ITxiansheng, 16-08-02 16:08:16
 *
 *  @brief 返回用户内存大小
 *
 *  @return 用户内存大小
 */
+ (NSUInteger) ld_userMemory;

/**
 *  @author ITxiansheng, 16-08-02 16:08:02
 *
 *  @brief 返回总的闪存大小
 *
 *  @return 闪存大小
 */
+ (NSNumber *) ld_totalDiskSpace;

/**
 *  @author ITxiansheng, 16-08-02 16:08:27
 *
 *  @brief 返回空闲闪存大小
 *
 *  @return 空闲闪存大小
 */
+ (NSNumber *) ld_freeDiskSpace;

/**
 *  @author ITxiansheng, 16-08-02 16:08:02
 *
 *  @brief 返回机器mac地址
 *
 *  @return mac地址
 */
+ (NSString *) ld_macaddress;

/**
 *  @author ITxiansheng, 16-08-02 16:08:19
 *
 *  @brief 是否是retina屏幕
 *
 *  @return 布尔值
 */
+ (BOOL) ld_hasRetinaDisplay;

/**
 *  @author ITxiansheng, 16-08-02 16:08:38
 *
 *  @brief 返回是 ipad ipod iPhone appleTV
 *
 *  @return 机器类型，可能为unknown
 */
+ (UIDeviceFamily) ld_deviceFamily;

@end
