//
//  LDKWAPIEncrypt.h
//  LDKWNetworking
//
//  Created by lixingdong on 2017/10/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LDKWAPIEncrypt : NSObject

/**
 Encypt data with 3DES.
 
 @param data      The data will be encypted.
 @param timeStamp The timestamp used to encypt. Strings are limited to a maximum length of 20 characters, characters over this length will be truncated.
 @return The encypted data.
 */
+ (NSMutableData *)encyptPostData:(NSData *)data timeStamp:(nullable NSString *)timeStamp;


/**
 Encypt data with 3DES.
 
 @param data The data will be encypted.
 @return The encypted data.
 */
+ (NSMutableData *)encyptPostData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
