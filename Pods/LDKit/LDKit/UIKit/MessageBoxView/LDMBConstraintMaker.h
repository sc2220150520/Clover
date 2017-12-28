//
//  LDMBConstraintMaker.h
//  LDKitDemo
//
//  Created by Yang Ning on 9/9/16.
//  Copyright © 2016 LDKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LDMBComponentProtocol.h"

@interface LDMBConstraintMaker : NSObject

+ (void)setupConstrainsWithContainer:(nonnull UIView<LDMBContainerProtocal> *)container components:(nonnull NSArray<id<LDMBComponentProtocol>> *)components;

@end
