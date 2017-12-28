//
//  UCHTTPSessionManager.m
//  Pods
//
//  Created by lixingdong on 17/9/13.
//
//

#import "UCHTTPSessionManager.h"
#import "NSString+LDEncode.h"
#import "NSDictionary+LDAccessors.h"

@interface UCHTTPSessionManager()

@property (nonatomic, strong) NSURLSessionTask *currentTask;
@property (nonatomic, strong) NSString *commonHeader;

@end

@implementation UCHTTPSessionManager

+ (UCHTTPSessionManager *)sharedInstance {
    static UCHTTPSessionManager *instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[UCHTTPSessionManager alloc] init];
    });
    
    return instance;
}

- (void)configWithHeader:(NSString *)header {
    if (header && header.length > 0) {
        self.commonHeader = header;
    }
}

- (void)POST:(NSString *)urlString
  parameters:(NSDictionary *)parameters
     success:(void (^)(NSDictionary *responseDict))success
     failure:(void (^)(NSDictionary *responseDict, NSError *error))failure
{
    [self resetTask];
    
    if (self.commonHeader && self.commonHeader.length > 0) {
        urlString = [NSString stringWithFormat:@"%@?%@", urlString, self.commonHeader];
    }
    
    NSURL *url=[NSURL URLWithString:urlString];
    NSData *requstData = [self postRequestData:parameters];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requstData];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requstData length]] forHTTPHeaderField:@"Content-Length"];
    [request setTimeoutInterval:30];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dict = nil;
        if (data && data.length > 0) {
            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        }
        
        if ([dict ld_intForKey:@"result"] == 100) {
            success(dict);
        } else {
            failure(dict, error);
        }
        
    }];
    
    [dataTask resume];
    self.currentTask = dataTask;
}

#pragma mark - private method

- (NSData *)postRequestData:(NSDictionary *)parameters
{
    NSMutableString *paramString = [NSMutableString string];
    NSEnumerator *keys = [parameters keyEnumerator];
    
    for (NSString *key in keys) {
        NSString *value = [parameters objectForKey:key];
        [paramString appendString:[key ld_urlEncodedString]];
        [paramString appendString:@"="];
        [paramString appendString:[value ld_urlEncodedString]];
        [paramString appendString:@"&"];
    }
    
    if ([paramString length] > 0) {
        paramString = [[paramString substringToIndex:paramString.length - 1] mutableCopy];
    }
    
    NSData *data = [paramString dataUsingEncoding:NSUTF8StringEncoding];
    
    return data;
}

- (void)resetTask {
    if (self.currentTask) {
        [self.currentTask cancel];
        self.currentTask = nil;
    }
}

@end
