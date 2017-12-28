//
//  UINib+LDSimple.m
//  LDKitDemo
//
//  Created by lixingdong on 16/8/5.
//  Copyright © 2016年 david. All rights reserved.
//

#import "UINib+LDAddition.h"

@implementation UINib (LDSimple)

+ (id)ld_objectWithNibName:(NSString *)name
{
    UINib *aNib = [UINib nibWithNibName:name bundle:nil];
    if (aNib) {
        NSArray *topLevelObjs = [aNib instantiateWithOwner:nil options:nil];
        if (topLevelObjs.count > 0) {
            return [topLevelObjs objectAtIndex:0];
        }
    }
    return nil;
}

@end
