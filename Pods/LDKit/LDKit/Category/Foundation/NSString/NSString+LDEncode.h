//
//  NSString+LDEncode.h
//  LDKitDemo
//
//  Created by lixingdong on 16/8/5.
//  written by xuguoxing on 14-1-21.
//  written by LiuLiming on 14/11/19.
//  written by SongLi on 6/2/16.
//  Copyright © 2016年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LDEncode)

- (BOOL)ld_isEmptyOrWhitespace;

- (NSData *)ld_base16Data;

- (NSString *)ld_md5String;

- (NSString *)ld_urlEncodedString;

- (NSString *)ld_urlDecodedString;

- (NSDictionary *)ld_urlParamsDecodeDictionary;

+ (NSString *)ld_base64Encode:(NSString*)str;

+ (NSString *)ld_RandomUUIDString;

@end
