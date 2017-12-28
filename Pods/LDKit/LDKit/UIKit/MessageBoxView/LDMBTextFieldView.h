//
//  LDMBTextFieldView.h
//  LDKitDemo
//
//  Created by Yang Ning on 9/9/16.
//  Copyright © 2016 LDKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDMBTextFieldView : UIView 

@property (nullable, nonatomic, strong, readonly) NSString *text;
@property (nullable, nonatomic ,copy) NSString *placeHolderText;

@end
