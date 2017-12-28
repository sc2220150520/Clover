//
//  LDKWAPIEncrypt.m
//  LDKWNetworking
//
//  Created by lixingdong on 2017/10/16.
//

#include <CommonCrypto/CommonCryptor.h>
#import "LDKWAPIEncrypt.h"
#import "LDKWBase64Transcoder.h"

const char basekey[] = "\xef\x2e\xcc\xdc\x9b\x3b\xf7\x2a\x68\xad\xeb\x72\xe3\x78\x2f\x5f\x07\x77\xd5\xc1\x1d\x40\x36\xb4";
const char dataParam[] = "data=";
const char stampParam[] = "&stamp=";

#define StampLengthMax (20)

void generateStamp(char *outBuf, size_t length) {
    for (int i = 0; i < length; i++) {
        int scope = 'z' - 'a' + 1;
        int c = 'a' + rand() % scope;
        outBuf[i] = c;
    }
}

void generateLotteryKey(const char *baseKey, size_t keyLength, const char *stamp, size_t stampLength, char *finalKey) {
    int basePos = 0;
    int stampPos = 0;
    while (basePos < keyLength) {
        finalKey[basePos] = baseKey[basePos] & stamp[stampPos];
        basePos++;
        stampPos++;
        if (basePos >= keyLength) {
            break;
        }
        if (stampPos >= stampLength) {
            stampPos = 0;
        }
        finalKey[basePos] = baseKey[basePos] | stamp[stampPos];
        basePos++;
        stampPos++;
        if (basePos >= keyLength) {
            break;
        }
        if (stampPos >= stampLength) {
            stampPos = 0;
        }
        finalKey[basePos] = baseKey[basePos] ^ stamp[stampPos];
        basePos++;
        stampPos++;
        if (basePos >= keyLength) {
            break;
        }
        if (stampPos >= stampLength) {
            stampPos = 0;
        }
    }
}

@implementation LDKWAPIEncrypt

+ (NSMutableData *)encyptPostData:(NSData *)data
{
    return [self encyptPostData:data timeStamp:nil];
}

+ (NSMutableData *)encyptPostData:(NSData *)data timeStamp:(NSString *)timeStamp
{
    NSMutableData *cryptdata = [NSMutableData dataWithCapacity:128];
    NSMutableData *mData = [NSMutableData dataWithData:data];
    [mData appendData:[[NSString stringWithFormat:@"&timeStamp=%d", (int) [[NSDate date] timeIntervalSince1970]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //PKCS5 padding
    const char *rawbyters = [mData bytes];
    size_t rawlength = [data length];
    size_t padlength = rawlength % 8;
    padlength = 8 - padlength;
    size_t lengthAfterPad = rawlength + padlength;
    void *paddeddata = malloc(lengthAfterPad);
    memcpy(paddeddata, rawbyters, rawlength);
    memset(paddeddata + rawlength, (int)padlength, padlength);
    
    char *encyptData = malloc(lengthAfterPad);
    size_t numBytesEncrypted;
    
    char stamp[StampLengthMax];
    
    size_t stampLength = 8 + rand() % 13;
    generateStamp(stamp, stampLength);
    
    const char *pStamp = stamp;
    if (timeStamp.length > 0) {
        if (timeStamp.length > StampLengthMax) {
            timeStamp = [timeStamp substringToIndex:StampLengthMax];
        }
        
        stampLength = timeStamp.length;
        pStamp = [timeStamp UTF8String];
    }
    
    char key[24];
    generateLotteryKey(basekey, 24, pStamp, stampLength, key);
    
    CCCryptorStatus status = CCCrypt(kCCEncrypt, kCCAlgorithm3DES, kCCOptionECBMode, key, kCCKeySize3DES, NULL, paddeddata, lengthAfterPad, encyptData, lengthAfterPad, &numBytesEncrypted);
    
    if (status == kCCSuccess) {
        size_t base64length = LDKWEstimateBas64EncodedDataSize(numBytesEncrypted);
        char *base64Buffer = malloc(base64length);
        LDKWBase64EncodeData(encyptData, numBytesEncrypted, base64Buffer, &base64length);
        
        NSString *base64String = [[NSString alloc] initWithBytes:base64Buffer length:base64length encoding:NSUTF8StringEncoding];
        NSString *urlEncodedString= (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                          (__bridge CFStringRef)base64String,
                                                                                                          NULL,
                                                                                                          CFSTR("!*'()^;:@&=+$,/?%#[]"),
                                                                                                          kCFStringEncodingUTF8);
        
        [cryptdata appendBytes:dataParam length:strlen(dataParam)];
        [cryptdata appendData:[urlEncodedString dataUsingEncoding:NSUTF8StringEncoding]];
        [cryptdata appendBytes:stampParam length:strlen(stampParam)];
        [cryptdata appendBytes:pStamp length:stampLength];
        free(base64Buffer);
    }
    free(paddeddata);
    free(encyptData);
    return cryptdata;
}

@end
