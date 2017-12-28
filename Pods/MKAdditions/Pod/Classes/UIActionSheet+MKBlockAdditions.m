//
//  UIActionSheet+MKBlockAdditions.m
//  UIKitCategoryAdditions
//
//  Created by Mugunth on 21/03/11.
//  Copyright 2011 Steinlogic All rights reserved.
//

#import "UIActionSheet+MKBlockAdditions.h"
#import "UIViewController+MKTopMostViewController.h"
#import "UIImagePickerController+MKBlockAddtions.h"
#import <objc/runtime.h>
#import "MKBlockAlertController.h"

static char DISMISS_IDENTIFIER;
static char CANCEL_IDENTIFIER;
static char PHOTOPICKED_IDENTIFIER;
static char PRESENTVC_IDENTIFIER;

@interface UIAlertView ()
/**
 *  其他自定义键的点击事件回调block。
 *
 *  @attention block的输入参数buttonIndex是不包括取消键的索引号。比如AlertView里有“取消”键和“确定”键，则“确定”键的buttonIndex是0而不是1。
 */
@property (nonatomic, copy) DismissBlock dismissBlock;

/**
 *  取消键的点击事件回调block
 */
@property (nonatomic, copy) CancelBlock cancelBlock;

@property (nonatomic, copy) PhotoPickedBlock photoPickedBlock;
@property (nonatomic, strong, nonnull) UIViewController *presentVC;

@end

@implementation UIActionSheet (MKBlockAdditions)

#pragma mark - Custom Accessors

- (void)setDismissBlock:(DismissBlock)dismissBlock {
    objc_setAssociatedObject(self, &DISMISS_IDENTIFIER, dismissBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (DismissBlock)dismissBlock {
    return objc_getAssociatedObject(self, &DISMISS_IDENTIFIER);
}

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

- (void)setPresentVC:(UIViewController *)presentVC {
    objc_setAssociatedObject(self, &PRESENTVC_IDENTIFIER, presentVC, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)presentVC {
    return objc_getAssociatedObject(self, &PRESENTVC_IDENTIFIER);
}

#pragma mark - Public Methods

+ (void)actionSheetWithTitle:(NSString *)title
                     message:(NSString *)message
                     buttons:(NSArray<NSString *> *)buttonTitles
                  showInView:(UIView *)view
                   onDismiss:(DismissBlock)dismissed
                    onCancel:(CancelBlock)cancelled {
    
    [UIActionSheet actionSheetWithTitle:title 
                                message:message 
                 destructiveButtonTitle:nil 
                                buttons:buttonTitles 
                             showInView:view 
                              onDismiss:dismissed 
                               onCancel:cancelled];
}

+ (void)actionSheetWithTitle:(NSString *)title
                     message:(NSString *)message
      destructiveButtonTitle:(NSString *)destructiveButtonTitle
                     buttons:(NSArray<NSString *> *)buttonTitles
                  showInView:(UIView *)view
                   onDismiss:(DismissBlock)dismissed
                    onCancel:(CancelBlock)cancelled {
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                                 delegate:(id)[self class]
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:destructiveButtonTitle 
                                                        otherButtonTitles:nil];
        [actionSheet setDismissBlock:dismissed];
        [actionSheet setCancelBlock:cancelled];

        for (NSString *thisButtonTitle in buttonTitles)
            [actionSheet addButtonWithTitle:thisButtonTitle];

        [actionSheet addButtonWithTitle:@"取消"];
        actionSheet.cancelButtonIndex = [buttonTitles count];

        if(destructiveButtonTitle) {
            actionSheet.cancelButtonIndex++;
        }

        if([view isKindOfClass:[UIView class]]) {
            [actionSheet showInView:view];
        }

        if([view isKindOfClass:[UITabBar class]]) {
            [actionSheet showFromTabBar:(UITabBar *)view];
        }

        if([view isKindOfClass:[UIBarButtonItem class]]) {
            [actionSheet showFromBarButtonItem:(UIBarButtonItem *)view animated:YES];
        }
        
    } else {
        
        MKBlockAlertController *alertController = [MKBlockAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSString *cancelButtonTitle = @"取消";
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelled) {
                cancelled();
            }
        }];
        [alertController addAction:cancelAction];
        
        if (destructiveButtonTitle) {
            UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                if (dismissed) {
                    dismissed(0);
                }
            }];
            [alertController addAction:destructiveAction];
        }
        
        [buttonTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (dismissed) {
                    if (destructiveButtonTitle) {
                        dismissed(idx + 1);
                    } else {
                        dismissed(idx);
                    }
                }
            }];
            [alertController addAction:otherAction];
        }];
        
        [self showAlertController:alertController];

    }
}

+ (void)photoPickerWithTitle:(NSString *)title
                  showInView:(UIView *)view
                   presentVC:(UIViewController *)presentVC
               onPhotoPicked:(PhotoPickedBlock)photoPicked
                    onCancel:(CancelBlock)cancelled
{
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                                 delegate:(id)[self class]
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        [actionSheet setCancelBlock:cancelled];
        [actionSheet setPhotoPickedBlock:photoPicked];
        [actionSheet setPresentVC:presentVC];
        
        int cancelButtonIndex = -1;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [actionSheet addButtonWithTitle:@"照相机"];
            cancelButtonIndex++;
        }
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [actionSheet addButtonWithTitle:@"相册"];
            cancelButtonIndex++;
        }
        
        [actionSheet addButtonWithTitle:@"取消"];
        cancelButtonIndex++;
        
        actionSheet.tag = kPhotoActionSheetTag;
        actionSheet.cancelButtonIndex = cancelButtonIndex;		 

        if([view isKindOfClass:[UIView class]]) {
            [actionSheet showInView:view];
        }
        
        if([view isKindOfClass:[UITabBar class]]) {
            [actionSheet showFromTabBar:(UITabBar *)view];
        }
        
        if([view isKindOfClass:[UIBarButtonItem class]]) {
            [actionSheet showFromBarButtonItem:(UIBarButtonItem *)view animated:YES];
        }
        
    } else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.photoPickedBlock = photoPicked;
        picker.cancelBlock = cancelled;
        picker.delegate = (id)[self class];
        picker.allowsEditing = YES;
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            NSString *cameraTitle = @"照相机";
            UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:cameraTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [presentVC presentViewController:picker animated:YES completion:nil];
            }];
            [alertController addAction:cameraAction];
        }
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            NSString *photoLibraryTitle = @"相册";
            UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:photoLibraryTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [presentVC presentViewController:picker animated:YES completion:nil];
            }];
            [alertController addAction:photoLibraryAction];
        }
        
        NSString *cancelButtonTitle = @"取消";
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelled) {
                cancelled();
            }
        }];
        [alertController addAction:cancelAction];
        
        [self showAlertController:alertController];
    }
}

#pragma mark - Private Methods

+ (void)showAlertController:(UIAlertController *)alertController {
    
    UIViewController *topViewController = [UIViewController mk_topViewController];
    if (![topViewController isKindOfClass:[UIAlertController class]]) {
        [topViewController presentViewController:alertController animated:YES completion:nil];
        
        //设置tintColor，否则UIAlertActionStyleDefault和UIAlertActionStyleCancel样式按钮文字颜色会白色
        alertController.view.tintColor = [UIColor colorWithRed:0 green:0.478431 blue:1. alpha:1];
    } else {
        NSLog(@"WARNING: you could NOT synchronously present multiple alert on the same view controller.");
    }
}

#pragma mark - Protocol Conformance

#pragma mark - UIImagePickerController Delegate

+ (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *editedImage = (UIImage *)[info valueForKey:UIImagePickerControllerEditedImage];
    if(!editedImage) {
        editedImage = (UIImage*) [info valueForKey:UIImagePickerControllerOriginalImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (picker.photoPickedBlock) {
            picker.photoPickedBlock(editedImage);
            picker.photoPickedBlock = nil;
        }
    }];
}


+ (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // Dismiss the image selection and close the program
    [picker dismissViewControllerAnimated:YES completion:^{
        if (picker.cancelBlock) {
            picker.cancelBlock();
            picker.cancelBlock = nil;
        }
    }];
}

#pragma mark - UIActionSheet Delegate

+ (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
	if (buttonIndex == [actionSheet cancelButtonIndex]) {
        if (actionSheet.cancelBlock) {
            actionSheet.cancelBlock();
            actionSheet.cancelBlock = nil;
        }
	}
    else {
        if(actionSheet.tag == kPhotoActionSheetTag) {
            NSInteger cameraButtonIndex = -1;
            NSInteger photoLibraryButtonIndex = -1;
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                cameraButtonIndex++;
            }
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                photoLibraryButtonIndex = cameraButtonIndex + 1;
            }
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.photoPickedBlock = actionSheet.photoPickedBlock;
            picker.cancelBlock = actionSheet.cancelBlock;
            picker.delegate = (id)[self class];
            picker.allowsEditing = YES;
            
            if (buttonIndex == cameraButtonIndex) {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            else if (buttonIndex == photoLibraryButtonIndex) {
                picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
            [actionSheet.presentVC presentViewController:picker animated:YES completion:nil];
            
        } else {
            if (actionSheet.dismissBlock) {
                actionSheet.dismissBlock(buttonIndex);
                actionSheet.dismissBlock = nil;
            }
        }
    }
}

@end
