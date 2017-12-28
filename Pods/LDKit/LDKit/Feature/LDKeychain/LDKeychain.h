//
//  LDKeychain.h
//  LDKit
//
//  Derived from ChristmasKeeper(https://github.com/ChrisInTX/ChristmasKeeper)
//  Carried by Anchor on 17/2/28.
//  Created by Chris Lowe on 10/31/11.
//  Copyright © 2017年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 ChristmasKeeper -> KeychainWrapper
 https://github.com/ChrisInTX/ChristmasKeeper
 */
@interface LDKeychain : NSObject

// Generic exposed method to search the keychain for a given value.  Limit one result per search.
+ (NSData *)ld_searchKeychainCopyMatchingIdentifier:(NSString *)identifier;

// Calls searchKeychainCopyMatchingIdentifier: and converts to a string value.
+ (NSString *)ld_keychainStringFromMatchingIdentifier:(NSString *)identifier;

// Simple method to compare a passed in Hash value with what is stored in the keychain.
// Optionally, we could adjust this method to take in the keychain key to look up the value
+ (BOOL)ld_compareKeychainValueForMatchingPIN:(NSUInteger)pinHash;

// Default initializer to store a value in the keychain.
// Associated properties are handled for you (setting Data Protection Access, Company Identifer (to uniquely identify string, etc).
+ (BOOL)ld_createKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier;

// Updates a value in the keychain.  If you try to set the value with createKeychainValue: and it already exists
// this method is called instead to update the value in place.
+ (BOOL)ld_updateKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier;

// Delete a value in the keychain
+ (void)ld_deleteItemFromKeychainWithIdentifier:(NSString *)identifier;

// Generates an SHA256 (much more secure than MD5) Hash
+ (NSString *)ld_securedSHA256DigestHashForPIN:(NSUInteger)pinHash;
+ (NSString*)ld_computeSHA256DigestForString:(NSString*)input;

@end
