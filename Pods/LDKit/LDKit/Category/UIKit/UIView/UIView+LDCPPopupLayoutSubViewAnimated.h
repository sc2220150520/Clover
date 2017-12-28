//
//  UIView+LDCPPopupLayoutSubViewAnimated.h
//  LDKitDemo
//
//  Created by xuejiao fan on 11/10/16.
//  Copyright © 2016 LDKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+LDCPPopupViewAnimated.h"

@interface UIView (LDCPPopupLayoutSubViewAnimated)

- (void)animateCenterYConstraintFromPosition:(LDCPAnimationVerticalPositionType)benginPosition
                                  toPosition:(LDCPAnimationVerticalPositionType)endPosition
                                    duration:(CFTimeInterval)duration
                                  completion:(void (^ __nullable)(BOOL finished, NSLayoutConstraint * _Nullable constraint))completion;
- (void)animateCenterYConstraint:(nonnull NSLayoutConstraint *)constraint
                      toPosition:(LDCPAnimationVerticalPositionType)endPosition
                        duration:(CFTimeInterval)duration
                      completion:(void (^ __nullable)(BOOL finished, NSLayoutConstraint * _Nullable constraint))completion;

@end
