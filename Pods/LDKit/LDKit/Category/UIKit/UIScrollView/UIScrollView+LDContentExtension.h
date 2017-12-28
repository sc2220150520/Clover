//
//  UIScrollView+LDContentExtension.h
//  LDKitDemo
//
//  Created by lixingdong on 16/8/8.
//  written by ITxiansheng on 16/6/21.
//  Copyright © 2016年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (LDContentExtension)

//========== getter与setter ===========
@property (nonatomic,assign) CGFloat ld_contentInsertBottom;//scrollView的contentInset.bottom
@property (nonatomic,assign) CGFloat ld_contentInsertTop;//scrollView的contentInset.top
@property (nonatomic,assign) CGFloat ld_contentOffsetTop;//scrollView的contentOffset.y

//设置contentOffset但不触发delegate的scrollViewDidScroll:回调
- (void)ld_setContentOffsetSilence:(CGPoint)contentOffset;

@end
