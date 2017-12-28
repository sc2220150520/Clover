//
//  UCLoginError.h
//  Pods
//
//  Created by lixingdong on 17/9/18.
//
//

#import <Foundation/Foundation.h>
#import "UCUtilsHeader.h"

@interface UCLoginError : NSObject

/*
 * UC错误
 */
+ (NSError *)authError:(NSInteger)code actionType:(ActionType)type;

@end
