//
//  LDMBConstraintMaker.m
//  LDKitDemo
//
//  Created by Yang Ning on 9/9/16.
//  Copyright © 2016 LDKit. All rights reserved.
//

#import "LDMBConstraintMaker.h"

@implementation LDMBConstraintMaker

+ (void)setupConstrainsWithContainer:(UIView<LDMBContainerProtocal> *)container components:(NSArray<id<LDMBComponentProtocol>> *)components
{
    id<LDMBComponentProtocol> preItem = nil;
    for (NSInteger i = 0; i <= [components count]; ++i) {
        id<LDMBComponentProtocol> curItem = nil;
        
        BOOL isFirst = (i == 0);
        BOOL isLast = (i == [components count]);
        
        if (isFirst) {
            preItem = container;
        }
        
        if (isLast) {
            curItem = container;
        } else {
            curItem = components[i];
        }
        
        if (preItem == curItem) {
            break;
        }
        
        NSLayoutAttribute vLayoutAttribute1 = isLast ? NSLayoutAttributeBottom : NSLayoutAttributeTop;
        NSLayoutAttribute vLayoutAttribute2 = isFirst ? NSLayoutAttributeTop : NSLayoutAttributeBottom;
        
        CGFloat topMargin = 0.0;
        
        if ([preItem marginPriority] > [curItem marginPriority]) {
            topMargin = [preItem verticalMargin];
        } else if ([preItem marginPriority] == [curItem marginPriority]) {
            topMargin = MAX([preItem verticalMargin], [curItem verticalMargin]);
        } else {
            topMargin = [curItem verticalMargin];
        }
        
        [container addConstraint:[NSLayoutConstraint constraintWithItem:curItem
                                                         attribute:vLayoutAttribute1
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:preItem
                                                         attribute:vLayoutAttribute2
                                                        multiplier:1.0 constant:topMargin]];
        
        if (curItem != container) {
            [container addConstraint:[NSLayoutConstraint constraintWithItem:curItem
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:container
                                                                  attribute:NSLayoutAttributeLeading
                                                                 multiplier:1.0 constant:[container horizontalMargin]]];
            
            
            [container addConstraint:[NSLayoutConstraint constraintWithItem:curItem
                                                                  attribute:NSLayoutAttributeTrailing
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:container
                                                                  attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0 constant:[container horizontalMargin] * -1.0]];
        }
        
        preItem = curItem;
    }
}

@end
