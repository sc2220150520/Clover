//
//  UCAuthManager.m
//  Pods
//
//  Created by lixingdong on 17/9/13.
//
//

#import "UCAuthManager.h"
#import "UCHTTPSessionManager.h"
#import "UCInterface.h"
#import "UCLoginError.h"
#import "UIDevice+LDIdentifier.h"
#import "UIDevice+UC.h"
#import "NSDictionary+LDAccessors.h"
#import "NSString+LDEncode.h"
#import "NSData+LDCrypto.h"

// userDefaultCenter
#define UCUserCurrentAESId          @"UserCurrentAESId"
#define UCUserCurrentAESKey         @"UserCurrentAESKey"
#define UCUserCurrentSessionId      @"UserCurrentSessionId"
#define UCUserCurrentAccountId      @"UserCurrentAccountId"
#define UCUserCurrentMobile         @"UserCurrentMobile"

// user Info
#define UCUserMobile        @"mobile"
#define UCUserPassword      @"password"
#define UCUserNewPassword   @"newPassword"
#define UCUserVerifyCode    @"verifyCode"

@interface UCAuthManager()

// UC初始化接口返回
@property (nonatomic, strong, readwrite) NSString *aesId;        // AESKey对应的Id
@property (nonatomic, strong, readwrite) NSString *aesKey;       // AES KEY

// 用户登录信息
@property (nonatomic, strong, readwrite) NSString *phoneNumber;  // 电话号码
@property (nonatomic, assign) PhoneLoginType mobileLoginType;

// UC登录接口返回
@property (nonatomic, assign, readwrite) BOOL isLogin;           // 标示是否登录成功
@property (nonatomic, strong, readwrite) NSString *accountId;    // 帐号Id
@property (nonatomic, strong, readwrite) NSString *sessionId;    // session Id

// private
@property (nonatomic, strong) NSString *product;
@property (nonatomic, strong) NSString *productVersion;

@end

@implementation UCAuthManager

+ (UCAuthManager *)sharedInstance {
    static UCAuthManager *instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[UCAuthManager alloc] init];
    });
    
    return instance;
}

- (void)configWithHeader:(NSString *)header {
    [[UCHTTPSessionManager sharedInstance] configWithHeader:header];
}

- (void)initProduct:(NSString *)product productVersion:(NSString *)version {
    assert(product != nil && version != nil);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults objectForKey:UCUserCurrentAESId];
    self.isLogin = NO;
    self.product = product;
    self.productVersion = version;
    self.aesId = [userDefaults objectForKey:UCUserCurrentAESId];
    self.aesKey = [userDefaults objectForKey:UCUserCurrentAESKey];
    self.sessionId = [userDefaults objectForKey:UCUserCurrentSessionId];
    self.accountId = [userDefaults objectForKey:UCUserCurrentAccountId];
    self.phoneNumber = [userDefaults objectForKey:UCUserCurrentMobile];
    
    if (self.aesId.length > 0 && self.sessionId.length > 0 && self.accountId.length > 0 && self.phoneNumber.length > 0) {
        self.isLogin = YES;
    } else {
        [self clearLocalSessionInfo];
    }
    
    if (self.aesId.length == 0) {
        [self fetchAESInfoWithSuccess:nil failure:nil actionType:initAction actionParams:nil];
    }
}

#pragma mark - UC 初始化


/**
 获取AES信息，成功后根据当前action（初始化、注册、登录、重置 or 获取验证码）执行对应的操作。

 @param success 成功block
 @param failure 失败block
 @param type 当前action类型（初始化、注册、登录、重置 or 获取验证码）
 @param actionParams 获取AES成功后，执行对应action需要的参数
 */
- (void)fetchAESInfoWithSuccess:(void (^)(NSDictionary *jsonDic))success
                        failure:(void (^)(NSDictionary *jsonDic, NSError *error))failure
                     actionType:(ActionType)type
                   actionParams:(NSDictionary *)actionParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.product forKey:@"platform"];
    [params setValue:self.productVersion forKey:@"pdtVersion"];
    
    UIDevice *device = [UIDevice currentDevice];
    [params setValue:[device uc_macaddress] forKey:@"mac"];
    [params setValue:[device uc_uniqueID] forKey:@"uniqueID"];
    [params setValue:[device name] forKey:@"deviceType"];
    [params setValue:[device systemName] forKey:@"systemName"];
    [params setValue:[device systemVersion] forKey:@"systemVersion"];
    [params setValue:[[device identifierForVendor] UUIDString] forKey:@"deviceId"];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    NSInteger w = rect.size.width * [UIScreen mainScreen].scale;
    NSInteger h = rect.size.height * [UIScreen mainScreen].scale;
    NSString *screenSize = [NSString stringWithFormat:@"%ld*%ld", (long)w, (long)h];
    [params setValue:screenSize forKey:@"resolution"];
    
    __weak typeof(self) weakSelf = self;
    [[UCHTTPSessionManager sharedInstance] POST:[UCInterface UCInitUrl] parameters:params success:^(NSDictionary *responseDict) {
        __strong typeof(self) strongSelf = weakSelf;
        NSDictionary *dataDict = [responseDict ld_dictionaryForKey:@"data"];
        
        if ([dataDict ld_stringForKey:@"id"]) {
            strongSelf.aesId = [dataDict ld_stringForKey:@"id"];
            strongSelf.aesKey = [dataDict ld_stringForKey:@"key"];
            [[NSUserDefaults standardUserDefaults] setObject:strongSelf.aesId forKey:UCUserCurrentAESId];
            [[NSUserDefaults standardUserDefaults] setObject:strongSelf.aesKey forKey:UCUserCurrentAESKey];
            
            switch (type) {
                case initAction:
                    break;
                    
                case verifyAction:
                    [strongSelf getVerifyCodeWithParams:actionParams success:success failure:failure];
                    break;
                    
                case loginAction:
                    [strongSelf fetchSesssionInfoWithSuccess:success failure:failure actionType:loginAction actionParams:actionParams];
                    break;
                    
                case registerAction:
                    [strongSelf fetchSesssionInfoWithSuccess:success failure:failure actionType:registerAction actionParams:actionParams];
                    break;

                case resetAction:
                    [strongSelf fetchSesssionInfoWithSuccess:success failure:failure actionType:resetAction actionParams:actionParams];
                    break;
                    
                default:
                    break;
            }
        } else {
            NSError *localError = [UCLoginError authError:0 actionType:initAction];
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(responseDict, localError);
                });
            }
        }
        
    } failure:^(NSDictionary *responseDict, NSError *error) {
        NSInteger errorCode = [responseDict ld_integerForKey:@"result"];
        NSError *localError = [UCLoginError authError:errorCode actionType:initAction];
        if (failure) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(responseDict, localError);
            });
        }
    }];
}

/**
 获取Session信息。
 
 @param success 成功block
 @param failure 失败block
 @param type 当前action类型（注册、登录、重置）
 @param actionParams 获取Session对应action需要的参数
 */
- (void)fetchSesssionInfoWithSuccess:(void (^)(NSDictionary *jsonDic))success
                             failure:(void (^)(NSDictionary *jsonDic, NSError *error))failure
                          actionType:(ActionType)type
                        actionParams:(NSDictionary *)actionParams
{
    NSString *mobile = [actionParams objectForKey:UCUserMobile];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *result = [self paramatersWithDictionary:actionParams];
    NSData *aesdata = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encryptString = [[aesdata ld_AES256EncryptWithKey:self.aesKey] ld_base16String];
    [params setValue:self.aesId forKey:@"id"];
    [params setValue:encryptString forKey:@"params"];
    [params setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"deviceId"];
    
    NSString *url = nil;
    switch (type) {
        case loginAction:
            url = [UCInterface UCLoginUrl];
            break;
        
        case registerAction:
            url = [UCInterface UCRegisterUrl];
            break;
            
        case resetAction:
            url = [UCInterface UCResetPasswordUrl];
            break;
            
        default:
            // 出错
            return;
    }
    
    __weak typeof(self) weakSelf = self;
    [[UCHTTPSessionManager sharedInstance] POST:url parameters:params success:^(NSDictionary *responseDict) {
        __strong typeof(self) strongSelf = weakSelf;
        
        if (type == resetAction) {
            strongSelf.phoneNumber = mobile;
            [[NSUserDefaults standardUserDefaults] setObject:strongSelf.phoneNumber forKey:UCUserCurrentMobile];
            [self clearCacheSessionInfo];
        } else {
            NSString *data = responseDict[@"data"];
            NSMutableDictionary *resultDict = [self parseAESResult:data];
            strongSelf.isLogin = YES;
            strongSelf.phoneNumber = mobile;
            strongSelf.sessionId = [resultDict objectForKey:@"sessionId"];
            strongSelf.accountId = [resultDict objectForKey:@"accountId"];
            
            [[NSUserDefaults standardUserDefaults] setObject:strongSelf.sessionId forKey:UCUserCurrentSessionId];
            [[NSUserDefaults standardUserDefaults] setObject:strongSelf.accountId forKey:UCUserCurrentAccountId];
            [[NSUserDefaults standardUserDefaults] setObject:strongSelf.phoneNumber forKey:UCUserCurrentMobile];
        }
        
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseDict);
            });
        }
    } failure:^(NSDictionary *responseDict, NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf clearCacheSessionInfo];
        
        NSInteger errorCode = [responseDict ld_integerForKey:@"result"];
        NSError *localError = [UCLoginError authError:errorCode actionType:type];
        if (failure) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(responseDict, localError);
            });
        }
    }];
}

#pragma mark - public methods 获取验证码

- (void)getVerificationCode:(NSString *)phoneNumber
                   codeType:(VerifyCodeType)type
                    success:(void (^)(NSDictionary *jsonDict))success
                    failure:(void (^)(NSDictionary *jsonDict, NSError *error))failure
{
    if (phoneNumber.length == 0) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:phoneNumber forKey:@"mobile"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)type] forKey:@"type"];
    
    if (self.aesId && self.aesId.length > 0) {
        [self getVerifyCodeWithParams:params success:success failure:failure];
    } else {
        [self fetchAESInfoWithSuccess:success failure:failure actionType:verifyAction actionParams:params];
    }
}

- (void)getVerifyCodeWithParams:(NSDictionary *)parameters
                        success:(void (^)(NSDictionary *))success
                        failure:(void (^)(NSDictionary *, NSError *))failure
{
    NSString *result = [self paramatersWithDictionary:parameters];
    NSData *aesdata = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encryptString = [[aesdata ld_AES256EncryptWithKey:self.aesKey] ld_base16String];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.aesId forKey:@"id"];
    [params setValue:encryptString forKey:@"params"];
    [params setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"deviceId"];
    
    [[UCHTTPSessionManager sharedInstance] POST:[UCInterface mobileVerifyCodeUrl] parameters:params success:^(NSDictionary *responseDict) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseDict);
            });
        }
    } failure:^(NSDictionary *responseDict, NSError *error) {
        NSInteger errorCode = [responseDict ld_integerForKey:@"result"];
        NSError *localError = [UCLoginError authError:errorCode actionType:verifyAction];
        
        if (failure) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(responseDict, localError);
            });
        }
    }];
}

#pragma mark - public methods 注册

- (void)registerUCWithPhoneNumber:(NSString *)number
                       verifyCode:(NSString *)verifyCode
                         password:(NSString *)password
                          success:(void (^)(NSDictionary *jsonDict))success
                          failure:(void (^)(NSDictionary *jsonDict, NSError *error))failure
{
    if (number.length == 0 || verifyCode.length == 0 || password.length == 0) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:number forKey:UCUserMobile];
    [params setValue:password forKey:UCUserPassword];
    [params setValue:verifyCode forKey:UCUserVerifyCode];
    
    if (self.aesId && self.aesId.length > 0) {
        [self registerUCWithParams:params success:success failure:failure];
    } else {
        [self fetchAESInfoWithSuccess:success failure:failure actionType:registerAction actionParams:params];
    }
}

- (void)registerUCWithParams:(NSDictionary *)params
                     success:(void (^)(NSDictionary *jsonDict))success
                     failure:(void (^)(NSDictionary *jsonDict, NSError *error))failure
{
    [self fetchSesssionInfoWithSuccess:success failure:failure actionType:registerAction actionParams:params];
}

#pragma mark - public methods 登录

- (void)loginUCWithPhoneNumber:(NSString *)number
                    verifyCode:(NSString *)verifyCode
                      password:(NSString *)password
                     loginType:(PhoneLoginType)type
                       success:(void (^)(NSDictionary *jsonDict))success
                       failure:(void (^)(NSDictionary *jsonDict, NSError *error))failure
{
    if (type == PhoneLoginByPassword && (number.length == 0 || password.length == 0)) {
        return;
    }
    
    if (type == PhoneLoginByVerifyCode && (number.length == 0 || verifyCode.length == 0)) {
        return;
    }
    
    self.mobileLoginType = type;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)LoginByPhone] forKey:@"source"];
    [params setValue:number forKey:UCUserMobile];
    if (type == PhoneLoginByPassword) {
        [params setValue:[self md5:password] forKey:UCUserPassword];
    } else {
        [params setValue:verifyCode forKey:UCUserVerifyCode];
    }
    [params setValue:[[UIDevice currentDevice] uc_uniqueID] forKey:@"uniqueID"];
    
    if (self.aesId && self.aesId.length > 0) {
        [self loginUCWithParams:params success:success failure:failure];
    } else {
        [self fetchAESInfoWithSuccess:success failure:failure actionType:loginAction actionParams:params];
    }
}

- (void)loginUCWithParams:(NSDictionary *)params
                  success:(void (^)(NSDictionary *jsonDict))success
                  failure:(void (^)(NSDictionary *jsonDict, NSError *error))failure
{
    [self fetchSesssionInfoWithSuccess:success failure:failure actionType:loginAction actionParams:params];
}

#pragma mark - public methods 重置

- (void)resetPasswordWithPhoneNumber:(NSString *)number
                          verifyCode:(NSString *)verifyCode
                         newPassword:(NSString *)newPassword
                             success:(void (^)(NSDictionary *jsonDict))success
                             failure:(void (^)(NSDictionary *jsonDict, NSError *error))failure
{
    if (number.length == 0 || verifyCode.length == 0 || newPassword.length == 0) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:number forKey:UCUserMobile];
    [params setValue:newPassword forKey:UCUserNewPassword];
    [params setValue:verifyCode forKey:UCUserVerifyCode];
    
    if (self.aesId && self.aesId.length > 0) {
        [self resetUCWithParams:params success:success failure:failure];
    } else {
        [self fetchAESInfoWithSuccess:success failure:failure actionType:resetAction actionParams:params];
    }
}

- (void)resetUCWithParams:(NSDictionary *)params
                  success:(void (^)(NSDictionary *jsonDict))success
                  failure:(void (^)(NSDictionary *jsonDict, NSError *error))failure
{
    [self fetchSesssionInfoWithSuccess:success failure:failure actionType:resetAction actionParams:params];
}

#pragma mark - public methods 退出登录

- (void)logoutUC {
    [self clearLocalSessionInfo];
}

#pragma mark - utils

- (NSString *)paramatersWithDictionary:(NSDictionary *)params
{
    NSMutableString *paramStringBuffer = [NSMutableString string];
    NSEnumerator *keys = [params keyEnumerator];
    for (NSString *key in keys) {
        NSString *value = [params objectForKey:key];
        [paramStringBuffer appendString:[key ld_urlEncodedString]];
        [paramStringBuffer appendString:@"="];
        [paramStringBuffer appendString:[value ld_urlEncodedString]];
        [paramStringBuffer appendString:@"&"];
    }
    
    NSString *paramString = paramStringBuffer;
    if ([paramString length] > 0) {
        paramString = [paramString substringToIndex:paramString.length - 1];
    }
    return [paramStringBuffer copy];
}

- (NSMutableDictionary *)parseAESResult:(NSString *)result
{
    NSString *str = [[NSString alloc] initWithData:[[result ld_base16Data] ld_AES256DecryptWithKey:self.aesKey] encoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *filedPairs = [str componentsSeparatedByString:@"&"];
    for (NSString *pairString in filedPairs) {
        NSArray *pair = [pairString componentsSeparatedByString:@"="];
        if (pair.count == 2) {
            [dict setObject:[pair objectAtIndex:1]
                     forKey:[pair objectAtIndex:0]];
        }
    }
    return dict;
}

- (NSString *)md5:(NSString *)password
{
    NSData *stringBytes = [password dataUsingEncoding:NSUTF8StringEncoding];
    return [[stringBytes ld_MD5] ld_base16String].lowercaseString;
}

#pragma mark - save/clear function

/**
 帐号退出时调用
 */
- (void)clearLocalSessionInfo {
    self.isLogin = NO;
    self.aesId = @"";
    self.aesKey = @"";
    self.sessionId = @"";
    self.accountId = @"";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:UCUserCurrentAESId];
    [defaults removeObjectForKey:UCUserCurrentAESKey];
    [defaults removeObjectForKey:UCUserCurrentSessionId];
    [defaults removeObjectForKey:UCUserCurrentAccountId];
}

/**
 注册、登录、重置失败时调用
 */
- (void)clearCacheSessionInfo {
    self.isLogin = NO;
    self.sessionId = @"";
    self.accountId = @"";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:UCUserCurrentAESId];
    [defaults removeObjectForKey:UCUserCurrentAESKey];
}


@end
