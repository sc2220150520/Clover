//
//  UCHTTPSessionManager.h
//  Pods
//
//  Created by lixingdong on 17/9/13.
//
//

#import <Foundation/Foundation.h>
#import "UCUtilsHeader.h"

@interface UCHTTPSessionManager : NSObject

+ (UCHTTPSessionManager *)sharedInstance;

- (void)configWithHeader:(NSString *)header;

- (void)POST:(NSString *)urlString
  parameters:(NSDictionary *)parameters
     success:(void (^)(NSDictionary *responseDict))success
     failure:(void (^)(NSDictionary *responseDict, NSError *error))failure;

@end
