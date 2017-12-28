//
//  UCUtilsHeader.h
//  Pods
//
//  Created by lixingdong on 2017/9/28.
//

#ifndef UCUtilsHeader_h
#define UCUtilsHeader_h

typedef NS_ENUM(NSInteger, LoginType) {
    LoginByWX = 0,          // 微信登录
    LoginByQQ = 1,          // QQ登录
    LoginByEmail = 2,       // 网易邮箱登录
    LoginByPhone = 3        // 手机号登录
};

typedef NS_ENUM(NSInteger, PhoneLoginType) {
    PhoneLoginByPassword = 0,               // 手机号＋密码登录
    PhoneLoginByVerifyCode                  // 手机号＋验证码登录
};

typedef NS_ENUM(NSInteger, VerifyCodeType) {
    RegisterVerifyCode = 0,         // 注册
    LoginVerifyCode = 1,            // 登录
    ResetVerifyCode = 2             // 重置
};

typedef NS_ENUM(NSInteger, ActionType) {
    initAction = 0,         // 初始化
    verifyAction = 1,       // 获取验证码
    loginAction = 2,        // 登录
    registerAction = 3,     // 注册
    resetAction = 4,        // 重置密码
};

#endif /* UCUtilsHeader_h */
