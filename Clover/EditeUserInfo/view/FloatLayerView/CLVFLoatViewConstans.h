//
//  CLVFLoatViewConstans.h
//  Clover
//
//  Created by shen chen on 2018/1/4.
//  Copyright © 2018年 shenchen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CLVActionType) {
    CLVTakePhoto,
    CLVChoosePhoto,
    CLVSavePhoto,
    CLVDelete,
    CLVCancel
};

extern NSString *const choosePhotoCell;
extern const CGFloat cellHeight;
extern const CGFloat cellGapHeigh;
extern const CGFloat tableViewHeadHeigh;
extern const CGFloat tableViewFooterHeigh;
