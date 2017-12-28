//
//  COSetupModel.m
//  Clover
//
//  Created by shen chen on 2017/12/25.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import "COSetupModel.h"

@implementation COSetupModel
- (instancetype)initWithimageUrl:(NSString *)imageurl text:(NSString *)text num:(NSString *)num {
    self = [super init];
    if (self) {
        self.imageUrl = imageurl;
        self.text = text;
        self.num = num;
    }
    return self;
}
@end
