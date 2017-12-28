//
//  UIScrollView+LDContentExtension.m
//  LDKitDemo
//
//  Created by lixingdong on 16/8/8.
//  Copyright © 2016年 david. All rights reserved.
//

#import "UIScrollView+LDContentExtension.h"

@implementation UIScrollView (LDContentExtension)

- (CGFloat) ld_contentInsertBottom {
    
    return self.contentInset.bottom;
}

- (void) setLd_contentInsertBottom:(CGFloat)ld_contentInsertBottom {
    
    UIEdgeInsets inserts = self.contentInset;
    inserts.bottom = ld_contentInsertBottom;
    self.contentInset = inserts;
}

- (CGFloat) ld_contentInsertTop {
    
    return self.contentInset.top;
}

- (void) setLd_contentInsertTop:(CGFloat)ld_contentInsertTop {
    
    UIEdgeInsets inserts = self.contentInset;
    inserts.top = ld_contentInsertTop;
    self.contentInset = inserts;
}

- (CGFloat) ld_contentOffsetTop {
    
    return self.contentOffset.y;
}

- (void) setLd_contentOffsetTop:(CGFloat)ld_contentOffsetTop {
    
    CGPoint contentOffset = self.contentOffset;
    contentOffset.y = ld_contentOffsetTop;
    self.contentOffset = contentOffset;
}

- (void)ld_setContentOffsetSilence:(CGPoint)contentOffset
{
    CGRect scrollBounds = self.bounds;
    scrollBounds.origin = contentOffset;
    self.bounds = scrollBounds;
}

@end
