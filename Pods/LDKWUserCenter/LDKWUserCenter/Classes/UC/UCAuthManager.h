//
//  UCAuthManager.h
//  Pods
//
//  Created by lixingdong on 17/9/13.
//
//

#import <Foundation/Foundation.h>
#import "UCUtilsHeader.h"

@interface UCAuthManager : NSObject

// UC初始化接口返回
@property (nonatomic, strong, readonly) NSString *aesId;        // AESKey对应的Id
@property (nonatomic, strong, readonly) NSString *aesKey;       // AES KEY

// UC登录接口返回
@property (nonatomic, assign, readonly) BOOL isLogin;           // 标示是否登录成功
@property (nonatomic, strong, readonly) NSString *accountId;    // 帐号Id
@property (nonatomic, strong, readonly) NSString *sessionId;    // session Id
@property (nonatomic, strong, readonly) NSString *phoneNumber;  // 电话号码

+ (UCAuthManager *)sharedInstance;

/**
 配置UC中心请求公共头部

 @param header The common query components for the request.
 */
- (void)configWithHeader:(NSString *)header;

/**
 UCAuthManager 初始化产品代号及产品版本
 注意⚠️：在程序启动的时候初始化product和product version；即在didFinishLaunchingWithOptions调用该函数
 @param product 产品代号
 @param version 产品版本号
 */
- (void)initProduct:(NSString *)product productVersion:(NSString *)version;

/**
 获取验证码

 @param phoneNumber 手机号
 @param type 验证码类型：注册RegisterVerifyCode、登录LoginVerifyCode、重置ResetVerifyCode
 @param success 成功block
 @param failure 失败block
 */
- (void)getVerificationCode:(NSString *)phoneNumber
                   codeType:(VerifyCodeType)type
                    success:(void (^)(NSDictionary *jsonDict))success
                    failure:(void (^)(NSDictionary *jsonDict, NSError *error))failure;


/**
 电话号码注册

 @param number 电话号码
 @param verifyCode 验证码
 @param password 密码
 @param success 注册成功block
 @param failure 注册失败block
 */
- (void)registerUCWithPhoneNumber:(NSString *)number
                       verifyCode:(NSString *)verifyCode
                         password:(NSString *)password
                          success:(void (^)(NSDictionary *jsonDict))success
                          failure:(void (^)(NSDictionary *jsonDict, NSError *error))failure;

/**
 电话号码登录UC

 @param number 电话号码
 @param verifyCode 验证码 （可选，type为PhoneLoginByCaptcha时，必填）
 @param password 密码（可选，type为PhoneLoginByPassword时，必填）
 @param type 登录类型： 密码登录 or 验证码登录
 @param success 登录成功block
 @param failure 登录失败block
 */
- (void)loginUCWithPhoneNumber:(NSString *)number
                    verifyCode:(NSString *)verifyCode
                      password:(NSString *)password
                     loginType:(PhoneLoginType)type
                       success:(void (^)(NSDictionary *jsonDict))success
                       failure:(void (^)(NSDictionary *jsonDict, NSError *error))failure;


/**
 重置密码

 @param number 手机号
 @param verifyCode 验证码
 @param newPassword 新密码
 @param success 修改成功block
 @param failure 修改失败block
 */
- (void)resetPasswordWithPhoneNumber:(NSString *)number
                          verifyCode:(NSString *)verifyCode
                         newPassword:(NSString *)newPassword
                             success:(void (^)(NSDictionary *jsonDict))success
                             failure:(void (^)(NSDictionary *jsonDict, NSError *error))failure;

/**
 退出登录
 */
- (void)logoutUC;


@end
