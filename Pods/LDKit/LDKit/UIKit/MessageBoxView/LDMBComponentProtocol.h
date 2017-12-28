//
//  LDMBComponentProtocol.h
//  LDKitDemo
//
//  Created by Yang Ning on 9/9/16.
//  Copyright © 2016 LDKit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef CGFloat LDMBComponentMarginPriority;

static const LDMBComponentMarginPriority LDMBComponentMarginPriorityRequired = 1000;
static const LDMBComponentMarginPriority LDMBComponentMarginPriorityDefaultHigh = 750;
static const LDMBComponentMarginPriority LDMBComponentMarginPriorityDefaultLow = 250;

@protocol LDMBComponentProtocol <NSObject>

- (CGFloat)verticalMargin;
- (LDMBComponentMarginPriority)marginPriority;

@end

@protocol LDMBContainerProtocal <LDMBComponentProtocol, NSObject>

- (CGFloat)horizontalMargin;
- (CGFloat)verticalMargin;
- (LDMBComponentMarginPriority)marginPriority;

@end
