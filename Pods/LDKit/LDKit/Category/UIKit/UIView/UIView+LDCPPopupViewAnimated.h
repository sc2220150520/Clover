//
//  UIView+LDCPPopupViewAnimated.h
//  Pods
//
//  Created by xuejiao fan on 6/30/16.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef  NS_ENUM(NSUInteger, LDCPAnimationVerticalPositionType) {
    LDCPAnimationVerticalPositionTypeTopUpperPlace = 1, //位置在屏幕上方，看不见
    LDCPAnimationVerticalPositionTypeTop,               //位置挨着屏幕上方，显示
    LDCPAnimationVerticalPositionTypeMiddleUpperPlace,  //位置在屏幕居中偏上100个点处，显示
    LDCPAnimationVerticalPositionTypeMiddle,            //位置在屏幕居中，显示
    LDCPAnimationVerticalPositionTypeMiddleLowerPlace,  //位置在屏幕居中偏下100个点处，显示
    LDCPAnimationVerticalPositionTypeBottom,            //位置挨着屏幕底部，显示
    LDCPAnimationVerticalPositionTypeBottomLowerPlace,  //位置在屏幕下方，看不见
};

static const CGFloat LDCPPopupViewAnimateBufferSpace = 50.0f;
static const CGFloat LDCPPopupViewAnimateShowDuration = 0.225f;
static const CGFloat LDCPPopupViewAnimateDismissDuration = 0.195f;

static NSString *const LDCPPopupViewShowAnimationValue = @"showAnimationValue";
static NSString *const LDCPPopupViewShowAnimationKey = @"showAnimationKey";
static NSString *const LDCPPopupViewDismissAnimationValue = @"dissmissAnimationValue";
static NSString *const LDCPPopupViewDismissAnimationKey = @"dismissAnimationKey";

typedef void (^LDCPPopupViewAnimateFinished) (BOOL finished);
typedef void (^LDCPPopupViewShadowResponse) (void);

@interface UIView (LDCPPopupViewAnimated)

- (void)animateAddSubview:(nonnull UIView *)view
            beginPosition:(LDCPAnimationVerticalPositionType)beginPosition
              endPosition:(LDCPAnimationVerticalPositionType)endPosition
                 duration:(CFTimeInterval)duration
            timingFuction:(nullable CAMediaTimingFunction *)timingFuction
               completion:(void (^ __nullable)(BOOL finished))completion
      shadowResponseBlock:(void (^ __nullable)(void))shadowResponse;

- (void)animateAddSubview:(nonnull UIView *)view
            beginFrame:(CGRect)beginFrame
              endFrame:(CGRect)endFrame
                 duration:(CFTimeInterval)duration
            timingFuction:(nullable CAMediaTimingFunction *)timingFuction
               completion:(void (^ __nullable)(BOOL finished))completion
      shadowResponseBlock:(void (^ __nullable)(void))shadowResponse;


//- (void)animateRemoveSubview:(nonnull UIView *)view
//                 endPosition:(LDCPAnimationVerticalPositionType)endPosition
//                    duration:(CFTimeInterval)duration
//               timingFuction:(nullable CAMediaTimingFunction *)timingFuction
//                  completion:(void (^ __nullable)(BOOL finished))completion;
//
//- (void)animateRemoveSubview:(nonnull UIView *)view
//                    endFrame:(CGRect)endFrame
//                    duration:(CFTimeInterval)duration
//               timingFuction:(nullable CAMediaTimingFunction *)timingFuction
//                  completion:(void (^ __nullable)(BOOL finished))completion;

- (void)animateRemoveWithEndPosition:(LDCPAnimationVerticalPositionType)endPosition
                            duration:(CFTimeInterval)duration
                       timingFuction:(nullable CAMediaTimingFunction *)timingFuction
                          completion:(void (^ __nullable)(BOOL finished))completion;

- (void)animateRemoveWithEndFrame:(CGRect)endFrame
                         duration:(CFTimeInterval)duration
                    timingFuction:(nullable CAMediaTimingFunction *)timingFuction
                       completion:(void (^ __nullable)(BOOL finished))completion;


@end
NS_ASSUME_NONNULL_END
