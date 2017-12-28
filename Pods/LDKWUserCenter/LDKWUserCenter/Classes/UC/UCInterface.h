//
//  UCInterface.h
//  Pods
//
//  Created by lixingdong on 17/9/18.
//
//

#import <Foundation/Foundation.h>

@interface UCInterface : NSObject

+ (NSString *)UCInitUrl;

+ (NSString *)UCLoginUrl;

+ (NSString *)UCRegisterUrl;

+ (NSString *)UCResetPasswordUrl;

+ (NSString *)mobileVerifyCodeUrl;

@end
