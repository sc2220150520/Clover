//
//  UITextField+LDSelection.m
//  LDKitDemo
//
//  Created by lixingdong on 16/8/5.
//  Copyright © 2016年 david. All rights reserved.
//

#import "UITextField+LDSelection.h"

@implementation UITextField (LDSelection)

- (NSRange)ld_selectedRange
{
    if ([self conformsToProtocol:@protocol(UITextInput)]) {
        UITextPosition *beginning = self.beginningOfDocument;
        
        UITextRange *selectedRange = self.selectedTextRange;
        UITextPosition *selectionStart = selectedRange.start;
        UITextPosition *selectionEnd = selectedRange.end;
        
        const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
        const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
        
        return NSMakeRange(location, length);
    } else {
        return NSMakeRange(NSNotFound, 0);
    }
}

- (void)ld_setSelectedRange:(NSRange)range
{
    //UITextFiled从iOS5开始支持UITextInput协议
    if ([self conformsToProtocol:@protocol(UITextInput)]) {
        UITextPosition *beginning = self.beginningOfDocument;
        
        UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
        UITextPosition *endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
        UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
        
        [self setSelectedTextRange:selectionRange];
    }
}

@end
