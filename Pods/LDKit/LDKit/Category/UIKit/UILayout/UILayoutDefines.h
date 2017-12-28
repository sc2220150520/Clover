//
//  UILayoutDefines.h
//  LDKitDemo
//
//  Created by lixingdong on 17/3/10.
//  Copyright © 2017年 LDKit. All rights reserved.
//

#ifndef UILayoutDefines_h
#define UILayoutDefines_h

typedef NS_ENUM(NSInteger, LDDirection) {
    LDDirectionLeft = 0,
    LDDirectionRight = 1,
    LDDirectionDown,
    LDDirectionUp
};

typedef NS_ENUM(NSUInteger, LDLayoutOptionMask)  {
    LDLayoutOptionAlignmentLeft = 1,
    LDLayoutOptionAlignmentRight = 2,
    LDLayoutOptionAlignmentCenter = 1<<2,
    LDLayoutOptionAlignmentTop = 1<<3,
    LDLayoutOptionAlignmentBottom = 1<<4,
    
    LDLayoutOptionAutoResize = 1<<8,
    LDLayoutOptionAutoResizeShrink =1<<9,
    LDLayoutOptionAutoResizeExpand =1<<10,
    
    LDLayoutOptionDontLayout = 1<<12
};

typedef NS_ENUM(NSUInteger, LDLayoutType)  {
    LDLayoutTypeHorizon = 1,
    LDLayoutTypeVertical = 2
};

#endif /* UILayoutDefines_h */
