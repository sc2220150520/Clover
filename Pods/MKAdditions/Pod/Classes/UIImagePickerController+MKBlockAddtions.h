//
//  UIImagePickerController+MKBlockAddtions.h
//  Pods
//
//  Created by xuejiao fan on 5/25/16.
//
//

#import <UIKit/UIKit.h>
#import "MKBlockAdditions.h"

@interface UIImagePickerController (MKBlockAddtions)

@property (nullable, nonatomic, copy) CancelBlock cancelBlock;

@property (nullable, nonatomic, copy) PhotoPickedBlock photoPickedBlock;

@end
