//
//  UCLoginError.m
//  Pods
//
//  Created by lixingdong on 17/9/18.
//
//

#import "UCLoginError.h"

@implementation UCLoginError

+ (NSError *)authError:(NSInteger)code actionType:(ActionType)type {
    
    NSString *description = [UCLoginError ErrorMessageWithCode:code actionType:type];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    
    return [NSError errorWithDomain:@"uc登录失败" code:code userInfo:dict];
}

+ (NSString *)ErrorMessageWithCode:(NSInteger)code actionType:(ActionType)type {
    NSString *errorMsg = @"网络不给力，请检查后重试";
    
    if (type == loginAction || type == resetAction) {
        switch (code) {
            case -114:
                errorMsg = @"密码错误";
                break;
                
            case -115:
                errorMsg = @"该手机号尚未注册";
                break;
                
            case -118:
                errorMsg = @"验证码有误";
                break;
    
            case -119:
                errorMsg = @"密码至少包含6-20位字母数字组合";
                break;
    
            case -120:
                errorMsg = @"验证码有误";
                break;
            
            case -122:
                errorMsg = @"验证码有误";
                break;
                
            default:
                if (type == loginAction) {
                    errorMsg = [NSString stringWithFormat:@"登录失败，请稍后重试(%ld)", (long)code];
                } else {
                    errorMsg = [NSString stringWithFormat:@"重置密码失败，请稍后重试(%ld)", (long)code];
                }
                
                break;
        }
    }
    
    if (type == registerAction) {
        switch (code) {
            case -114:
                errorMsg = @"密码错误";
                break;
                
            case -116:
                errorMsg = @"该手机号已注册";
                break;
            
            case -118:
                errorMsg = @"验证码有误";
                break;
                
            case -119:
                errorMsg = @"密码至少包含6-20位字母数字组合";
                break;
                
            case -120:
                errorMsg = @"验证码有误";
                break;
                
            case -122:
                errorMsg = @"验证码有误";
                break;
                
            default:
                errorMsg = [NSString stringWithFormat:@"注册失败，请稍后重试(%ld)", (long)code];
                break;
        }
    }
    
    if (type == verifyAction) {
        switch (code) {
            case -121:
                errorMsg = @"发送次数过多，请稍后再试";
                break;
                
            default:
                errorMsg = @"验证码发送失败，请重新发送";
                break;
        }
    }
    
    return errorMsg;
}


@end
