//
//  UITextField+FFT_Category.m
//  FFTTextField
//
//  Created by 四五20 on 2019/7/18.
//  Copyright © 2019 四五20. All rights reserved.
//

#import "UITextField+FFT_Category.h"
#import <objc/runtime.h>

@implementation UITextField (FFT_Category)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod(self, @selector(setDelegate:));
        Method swizzledMethod = class_getInstanceMethod(self, @selector(fft_setDelegate:));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)fft_setDelegate:(id<UITextFieldDelegate>)delegate {
    SEL fft_should_change_old_selector = @selector(textField:shouldChangeCharactersInRange:replacementString:);
    SEL fft_should_change_new_selector = @selector(fft_textField:shouldChangeCharactersInRange:replacementString:);
    Method fft_should_change_old_method_del = class_getInstanceMethod([delegate class], fft_should_change_old_selector);
    Method fft_should_change_old_method_self = class_getInstanceMethod([self class], fft_should_change_old_selector);
    Method fft_should_change_new_method = class_getInstanceMethod([self class], fft_should_change_new_selector);
    
    // 若未实现代理方法，则先添加代理方法
    BOOL isSuccess = class_addMethod([delegate class], fft_should_change_old_selector, class_getMethodImplementation([self class], fft_should_change_new_selector), method_getTypeEncoding(fft_should_change_new_method));
    if (isSuccess) {
        class_replaceMethod([delegate class], fft_should_change_new_selector, class_getMethodImplementation([self class], fft_should_change_old_selector), method_getTypeEncoding(fft_should_change_old_method_self));
    } else {
        // 若已实现代理方法，则添加 hook 方法并进行交换
        BOOL isVictory = class_addMethod([delegate class], fft_should_change_new_selector, class_getMethodImplementation([delegate class], fft_should_change_old_selector), method_getTypeEncoding(fft_should_change_old_method_del));
        if (isVictory) {
            class_replaceMethod([delegate class], fft_should_change_old_selector, class_getMethodImplementation([self class], fft_should_change_new_selector), method_getTypeEncoding(fft_should_change_new_method));
        }
    }
    [self fft_setDelegate:delegate];
}

- (BOOL)fft_textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.fft_max) {
        NSMutableString *text = [textField.text mutableCopy];
        [text replaceCharactersInRange:range withString:string];
        return text.length <= textField.fft_max;
    }
    return [self fft_textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

#pragma mark ---- 限制输入最大位数
- (void)setFft_max:(NSUInteger)fft_max {
    SEL key = @selector(fft_max);
    objc_setAssociatedObject(self, key, @(fft_max), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)fft_max {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

@end
