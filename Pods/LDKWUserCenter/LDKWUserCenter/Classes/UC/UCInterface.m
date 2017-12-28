//
//  UCInterface.m
//  Pods
//
//  Created by lixingdong on 17/9/18.
//
//

#import "UCInterface.h"

const NSString *baseUrl = @"https://uc.beikexiaodai.com/";

@implementation UCInterface

+ (NSString *)UCInitUrl {
    return [baseUrl stringByAppendingString:@"api/initMobApp"];
}

+ (NSString *)UCLoginUrl {
    return [baseUrl stringByAppendingString:@"api/login"];
}

+ (NSString *)UCRegisterUrl {
    return [baseUrl stringByAppendingString:@"api/mobileReg"];
}

+ (NSString *)UCResetPasswordUrl {
    return [baseUrl stringByAppendingString:@"api/resetPassword"];
}

+ (NSString *)mobileVerifyCodeUrl {
    return [baseUrl stringByAppendingString:@"api/mobileSmsCode"];
}

@end
