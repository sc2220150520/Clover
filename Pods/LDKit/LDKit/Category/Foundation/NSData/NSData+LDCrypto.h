//
//  NSData+LDCrypto.h
//  LDKit
//
//  Created by lixingdong on 16/8/12.
//  Copyright © 2016年 netease. All rights reserved.
//
//  支持对NSData不同类型的加解密、对密钥进行编解码

#import <Foundation/Foundation.h>

@interface NSData (LDCrypto)

- (NSData *)ld_MD5;

- (NSData *)ld_AES256EncryptWithKey:(NSString *)key;
- (NSData *)ld_AES256DecryptWithKey:(NSString *)key;

- (NSData *)ld_Encode3DESWithKey:(NSString *)key;
- (NSData *)ld_Decode3DESWithKey:(NSString *)key;


- (NSData *)ld_EncodeRsa:(SecKeyRef)publicKey;
- (NSData *)ld_DecodeRsa:(SecKeyRef)privateKey;


- (NSData *)ld_getSignatureBytes:(SecKeyRef)prikey;
- (BOOL)ld_verifySignature:(SecKeyRef)publicKey signature:(NSData *)sign ;

- (NSString *)ld_base64Encoding;

- (NSString*)ld_base16String;

@end

/*
SecKeyRef getPublicKeyWithCert(NSData *certdata);
SecKeyRef getPublicKeywithRawKey(NSString *peerNode,NSData *derpckskey);
SecKeyRef getPrivateKeywithRawKey(NSData *pfxkeydata);
*/
