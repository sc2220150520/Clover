//
//  LDKeyChainConstants.h
//  LDKit
//
//  Created by Anchor on 17/2/28.
//  Copyright © 2017年 netease. All rights reserved.
//

#ifndef LDKeyChainConstants_h
#define LDKeyChainConstants_h

// Used for saving to NSUserDefaults that a PIN has been set and as the unique identifier for the Keychain
#ifndef PIN_SAVED
#define PIN_SAVED @"hasSavedPIN"
#endif

// Used for saving the users name to NSUserDefaults
#ifndef USERNAME
#define USERNAME @"username"
#endif

// Used to specify the Application used in Keychain accessing
#ifndef APP_NAME
#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#endif

// Used to help secure the PIN
// Ideally, this is randomly generated, but to avoid unneccessary complexity and overhead of storing the Salt seperately we will standardize on this key.
// !!KEEP IT A SECRET!!
#ifndef SALT_HASH
#define SALT_HASH @"FvTivqTqZXsgLLx1v3P8TGRyVHaSOB1pvfm02wvGadj7RLHV8GrfxaZ84oGA8RsKdNRpxdAojXYg9iAj"
#endif

#endif /* LDKeyChainConstants_h */
