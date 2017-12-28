//
//  COSetupModel.h
//  Clover
//
//  Created by shen chen on 2017/12/25.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface COSetupModel : NSObject
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *num;

- (instancetype)initWithimageUrl:(NSString *)imageurl text:(NSString *)text num:(NSString *)num;
@end
