//
//  UIImagePickerController+MKBlockAddtions.m
//  Pods
//
//  Created by xuejiao fan on 5/25/16.
//
//

#import "UIImagePickerController+MKBlockAddtions.h"
#import <objc/runtime.h>

static char CANCEL_IDENTIFIER;
static char PHOTOPICKED_IDENTIFIER;

@implementation UIImagePickerController (MKBlockAddtions)

- (void)setCancelBlock:(CancelBlock)cancelBlock {
    objc_setAssociatedObject(self, &CANCEL_IDENTIFIER, cancelBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CancelBlock)cancelBlock {
    return objc_getAssociatedObject(self, &CANCEL_IDENTIFIER);
}

- (void)setPhotoPickedBlock:(PhotoPickedBlock)pickedBlock {
    objc_setAssociatedObject(self, &PHOTOPICKED_IDENTIFIER, pickedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (PhotoPickedBlock)photoPickedBlock {
    return objc_getAssociatedObject(self, &PHOTOPICKED_IDENTIFIER);
}

@end
