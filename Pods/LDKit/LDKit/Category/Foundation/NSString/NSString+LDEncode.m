//
//  NSString+LDEncode.m
//  LDKitDemo
//
//  Created by lixingdong on 16/8/5.
//  Copyright © 2016年 david. All rights reserved.
//

#import "NSString+LDEncode.h"
#import <CommonCrypto/CommonDigest.h>

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSString (LDEncode)

//  url字符串编解码、url的参数字典、md5加密等

- (BOOL)ld_isEmptyOrWhitespace
{
    return !self.length ||
    ![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}

- (unichar)ld_stringToASCIIChar:(NSString *)str
{
    if ([str length] < 2) {
        return 0;
    }
    unichar one = [str characterAtIndex:0];
    unichar two = [str characterAtIndex:1];
    if(('0'<=one) && (one<='9')) {
        one=one-'0';
    }
    if(('a'<=one) && (one<='z')) {
        one=one-'a'+10;
    }
    if(('A'<=one) && (one<='Z')) {
        one=one-'A'+10;
    }
    if(('0'<=two) && (two<='9')) {
        two=two-'0';
    }
    if(('a'<=two) && (two<='z')) {
        two=two-'a'+10;
    }
    if(('A'<=two) && (two<='Z')) {
        two=two-'A'+10;
    }
    return one*16+two;
}

- (NSData *)ld_base16Data
{
    if ([self length]%2 != 0) {
        return nil;
    }
    unsigned char key[[self length]/2+1];
    bzero(key, [self length]/2+1);
    for (int i=0; i<[self length]/2; i++) {
        NSString *str = [self substringWithRange:NSMakeRange(2*i, 2)];
        key[i] = [self ld_stringToASCIIChar:str];
    }
    return [NSData dataWithBytes:key length:[self length]/2];
}

- (NSString *)ld_md5String
{
    if ([self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++) {
        [outputString appendFormat:@"%02x", outputBuffer[count]];
    }
    
    return outputString;
}

- (NSString *)ld_urlEncodedString
{
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (__bridge CFStringRef)self,
                                                                                             NULL,
                                                                                             CFSTR("!*'()^;:@&=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8);
    return result;
}

- (NSString*)ld_urlDecodedString
{
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                             (__bridge CFStringRef)self,
                                                                                                             CFSTR(""),
                                                                                                             kCFStringEncodingUTF8);
    return result;
}

- (NSDictionary *)ld_urlParamsDecodeDictionary
{
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if (kv.count == 2) {
            NSString *key = [kv objectAtIndex:0];
            NSString *value = [[kv objectAtIndex:1] ld_urlDecodedString];
            [params setObject:value forKey:key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:params];
}

+ (NSString *)ld_base64Encode:(NSString*)str
{
    if ([str length] == 0)
        return @"";
    
    const char *source = [str UTF8String];
    size_t strlength  = strlen(source);
    
    char *characters = malloc(((strlength + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    
    NSUInteger length = 0;
    NSUInteger i = 0;
    
    while (i < strlength) {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < strlength)
            buffer[bufferLength++] = source[i++];
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

+ (nullable NSString *)ld_RandomUUIDString
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return uuidString;
}


@end
