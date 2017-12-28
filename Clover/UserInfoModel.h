//
//  UserInfoModel.h
//  Clover
//
//  Created by shen chen on 2017/12/25.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *idnum;
@property (nonatomic, strong) NSString *desc;

- (instancetype)initWithname:(NSString *)name image:(NSString *)image sex:(NSString *)sex address:(NSString *)address idnum:(NSString *)idnum desc:(NSString *)desc age:(NSString *)age;
@end
