//
//  LDMBHypelinkView.h
//  LDKitDemo
//
//  Created by xuejiao fan on 11/7/16.
//  Copyright © 2016 LDKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LDMBHypelinkView;
@protocol LDMBHypelinkViewDelegate <NSObject>

- (void)mbHypelinkClicked:(nonnull LDMBHypelinkView *)hypelinkView;

@end

@interface LDMBHypelinkView : UIView

@property (nullable, nonatomic, weak) id<LDMBHypelinkViewDelegate> delegate;
@property (nonnull, nonatomic ,copy) NSString *hypelinkText;

@end
