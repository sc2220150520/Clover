//
//  LDMBNormalView.h
//  LDKitDemo
//
//  Created by Yang Ning on 9/9/16.
//  Copyright © 2016 LDKit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LDMBHypelinkBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface LDMBNormalViewConstructor : NSObject

//第一部分 title和image  都可为空
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, strong) UIImage *image;
//第二部分 content 可为空
@property (nullable, nonatomic, copy) NSString *content;
//第三部分 textField 可为空
@property (nonatomic, assign) BOOL showTextField; //默认为NO
@property (nullable, nonatomic, copy) NSString *textFieldPlaceHolder;
//第四部分 checkBox或hypelink或提示文案
@property (nonatomic, assign) BOOL showCheck; //YES表示展示勾选框 NO-只展示hintText 默认NO
@property (nonatomic, assign) BOOL checkEnable;
@property (nullable, nonatomic, copy) NSString *hintText;
@property (nonatomic, assign) BOOL showHypelink;//YES展示超链接 NO-不展示  默认NO
@property (nullable, nonatomic, copy) NSString *linkText;
//@property (nullable, nonatomic, copy) NSString *linkJumpUrl;
@property (nullable, nonatomic, copy) LDMBHypelinkBlock linkBlock;

@end

@interface LDMBNormalView : UIView

@property (nonatomic, strong, readonly) LDMBNormalViewConstructor *constructor;

- (instancetype)initWithConstructor:(void(^)(LDMBNormalViewConstructor *attribute))block NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (BOOL)checkBoxEnable;
- (nullable NSString *)textFieldText;
- (nullable UIView *)weakTextField;

@end

NS_ASSUME_NONNULL_END
