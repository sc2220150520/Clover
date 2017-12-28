//
//  LDHorizontalLayout.m
//  LDKitDemo
//
//  Created by lixingdong on 17/3/17.
//  Copyright © 2017年 LDKit. All rights reserved.
//

#import "LDHorizontalLayout.h"

@implementation LDLayoutItem

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[LDLayoutItem class]]) {
        return (self.view ==((LDLayoutItem*)object).view);
    }
    return NO;
}

@end

@implementation LDLayoutBase

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.maximumSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
        self.minimumSize = CGSizeMake(0, 0);
    }
    return self;
}

- (UIImage*)backgroundImage {
    if ([_backgroundView isKindOfClass:[UIImageView class]]) {
        return [(UIImageView*)_backgroundView image];
    }
    return nil;
}

- (UIImage*)shadowImage {
    return _shadowView.image;
}

- (NSArray *)layoutViews
{
    NSMutableArray *views = [NSMutableArray array];
    for (LDLayoutItem *item in _layoutItems) {
        [views addObject:item.view];
    }
    return views;
}

+ (instancetype)layoutWithSubviews:(NSArray *)subviews
{
    LDLayoutBase *layout = [[self alloc] initWithFrame:CGRectZero];
    for (UIView *view in subviews) {
        [layout addSubview:view];
    }
    return layout;
}

- (void)resizeToContent {
    CGRect frame = self.frame;
    frame.size = [self neededSizeForContent];
    self.frame = frame;
}


- (CGSize)neededSizeForContent {
    CGSize size= [self computeContentSizeForContent];
    size.width = MAX(self.minimumSize.width, size.width);
    size.width = MIN(self.maximumSize.width, size.width);
    size.height = MAX(self.minimumSize.height, size.height);
    size.height = MIN(self.maximumSize.height, size.height);
    return size;
}

- (CGSize)computeContentSizeForContent {
    return self.frame.size;
}

- (void)layoutSubviews {
    CGRect frame = self.bounds;
    if (_backgroundView) {
        UIEdgeInsets edge = self.backgroundShadow;
        _backgroundView.frame = CGRectMake(frame.origin.x-edge.left,
                                           frame.origin.y-edge.top,
                                           frame.size.width+(edge.left+edge.right),
                                           frame.size.height+(edge.top+edge.bottom));
        [self sendSubviewToBack:_backgroundView];
    }
    if (_shadowView) {
        _shadowView.frame = CGRectMake(0, frame.size.height,frame.size.width,CGRectGetHeight(_shadowView.frame));
    }
}

@end

@implementation LDHorizontalLayout

- (CGSize)computeContentSizeForContent {
    CGSize needSize = CGSizeZero;
    for (NSInteger index=0;index<_layoutItems.count;index++) {
        LDLayoutItem *layoutItem = _layoutItems[index];
        if (layoutItem.view.hidden
            ||layoutItem.layoutOptionMask&LDLayoutOptionDontLayout) {
            continue;
        }
        
        CGSize itemSize = CGSizeZero;
        if ([layoutItem.view isKindOfClass:[LDLayoutBase class]]) {
            itemSize = [(LDLayoutBase*)layoutItem.view neededSizeForContent];
        } else {
            itemSize = layoutItem.view.frame.size;
        }
        needSize.width += itemSize.width;
        needSize.height = MAX(needSize.height, itemSize.height);
        
        if (index!=0) {
            needSize.width += layoutItem.spacing;
        }
    }
    needSize.width += self.contentInsets.left;
    needSize.width += self.contentInsets.right;
    needSize.height += self.contentInsets.top;
    needSize.height += self.contentInsets.bottom;
    return needSize;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat x = self.contentInsets.left;
    CGFloat withBalance = self.bounds.size.width-[self computeContentSizeForContent].width;
    for (NSInteger index=0;index<_layoutItems.count;index++) {
        LDLayoutItem *layoutItem  = _layoutItems[index];
        if (layoutItem.view.hidden
            ||layoutItem.layoutOptionMask&LDLayoutOptionDontLayout) {
            continue;
        }
        if (index>0) {
            x += layoutItem.spacing;
        }
        CGRect frame = layoutItem.view.frame;
        frame.origin.x = x;
        if (layoutItem.layoutOptionMask&LDLayoutOptionAutoResize) {
            frame.size.width += withBalance;
            withBalance = 0;
        } else if (layoutItem.layoutOptionMask&LDLayoutOptionAutoResizeShrink&&withBalance<.0) {
            frame.size.width += withBalance;
            withBalance = 0;
        } else if (layoutItem.layoutOptionMask&LDLayoutOptionAutoResizeExpand&&withBalance>.0) {
            frame.size.width += withBalance;
            withBalance = 0;
        }
        
        if (layoutItem.layoutOptionMask&LDLayoutOptionAlignmentCenter) {
            frame.origin.y = (self.bounds.size.height-frame.size.height)/2;
        } else if (layoutItem.layoutOptionMask&LDLayoutOptionAlignmentBottom) {
            frame.origin.y = self.bounds.size.height-frame.size.height-self.contentInsets.bottom;
        } else {
            frame.origin.y = self.contentInsets.top;
        }
        layoutItem.view.frame = frame;
        x += frame.size.width;
    }
    
    if (withBalance>0) {
        for (NSInteger index=0;index<_layoutItems.count;index++) {
            LDLayoutItem *layoutItem  = _layoutItems[index];
            if (layoutItem.view.hidden
                ||layoutItem.layoutOptionMask&LDLayoutOptionDontLayout) {
                continue;
            }
            if (self.contentLayoutOption&LDLayoutOptionAlignmentCenter) {
                CGRect frame = layoutItem.view.frame;
                frame.origin.x = CGRectGetMinX(frame) + withBalance/2;
                layoutItem.view.frame = frame;
            } else if (self.contentLayoutOption&LDLayoutOptionAlignmentRight) {
                CGRect frame = layoutItem.view.frame;
                frame.origin.x = CGRectGetMinX(frame) + withBalance;
                layoutItem.view.frame = frame;
            }
        }
    }
}




@end
