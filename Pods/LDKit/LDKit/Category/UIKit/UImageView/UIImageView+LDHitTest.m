//
//  UIImageView+LDHitTest.m
//  Pods
//
//  Created by bjliulei3 on 2017/7/5.
//
//

#import "UIImageView+LDHitTest.h"
#import <objc/runtime.h>

static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"LDHitTestEdgeInsets";

@implementation UIImageView (LDHitTest)

@dynamic ld_hitTestEdgeInsets;

- (void)setLd_hitTestEdgeInsets:(UIEdgeInsets)ld_hitTestEdgeInsets
{
    NSValue *value = [NSValue value:&ld_hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)ld_hitTestEdgeInsets
{
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if(value) {
        UIEdgeInsets edgeInsets;
        [value getValue:&edgeInsets];
        
        return edgeInsets;
    } else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if(UIEdgeInsetsEqualToEdgeInsets(self.ld_hitTestEdgeInsets, UIEdgeInsetsZero) || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.ld_hitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}

@end
