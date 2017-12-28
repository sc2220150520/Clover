//
//  UserInfoModel.m
//  Clover
//
//  Created by shen chen on 2017/12/25.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
- (instancetype)initWithname:(NSString *)name image:(NSString *)image sex:(NSString *)sex address:(NSString *)address idnum:(NSString *)idnum desc:(NSString *)desc age:(NSString *)age
{
    self = [super init];
    if (self) {
        self.name = name;
        self.imageUrl = image;
        self.sex = sex;
        self.address = address;
        self.idnum = idnum;
        self.desc = desc;
        self.age = age;
    }
    return self;
}
@end
