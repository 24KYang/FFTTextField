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
        
        BOOL didAddMethod = class_addMethod([super class], @selector(setDelegate:), method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod([super class], @selector(fft_setDelegate:), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)fft_setDelegate:(id<UITextFieldDelegate>)delegate {
    [self addTarget:self action:@selector(fft_textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self fft_setDelegate:delegate];
    
    Class delegateClass = [self.delegate class];
    
    fft_exchangeMethod(delegateClass, @selector(textField:shouldChangeCharactersInRange:replacementString:), [self class], @selector(fft_textField:shouldChangeCharactersInRange:replacementString:));
}


static void fft_exchangeMethod(Class originalClass, SEL originalSel, Class replacedClass, SEL replacedSel) {
    static NSMutableArray *classList = nil;
    if (classList == nil) {
        classList = [NSMutableArray array];
    }
    
    NSString *className = [NSString stringWithFormat:@"%@_%@", NSStringFromClass(originalClass), NSStringFromClass(replacedClass)];
    
    for (NSString *item in classList) {
        if ([className isEqualToString:item]) {
            return;
        }
    }
    
    [classList addObject:className];
    
    Method originalMethod = class_getInstanceMethod(originalClass, originalSel);
    
    Method replacedMetohd = class_getInstanceMethod(replacedClass, replacedSel);
    
    assert(replacedMetohd);
    
    IMP replacedMethodIMP = method_getImplementation(replacedMetohd);
    
    BOOL didAddMethod = class_addMethod(originalClass, replacedSel, replacedMethodIMP, method_getTypeEncoding(replacedMetohd));
    
    if (didAddMethod) {
        NSLog(@"class_addMethod failure --> (%@)", NSStringFromSelector(replacedSel));
    }else {
        NSLog(@"class_addMethod succeed --> (%@)", NSStringFromSelector(replacedSel));
    }
    
    Method newMethod = class_getInstanceMethod(originalClass, replacedSel);
    
    method_exchangeImplementations(originalMethod, newMethod);
}

- (BOOL)fft_textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.fft_max) {
        //当输入框内的文字长度与可输入最大值相同
        //且当前输入文字长度大于0(非删除操作)
        //且输入框当前无高亮(系统键盘的联想功能)
        if (textField.text.length == textField.fft_max && string.length > 0 && !textField.markedTextRange) return NO;
        return YES;
    }
    if ([self respondsToSelector:@selector(fft_textField:shouldChangeCharactersInRange:replacementString:)]) {
        //未设置最大输入位数则调用系统方法 用户可以自己实现此代理
        return [self fft_textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }else {
        return YES;
    }
}

- (void)fft_textFieldDidChange:(UITextField *)textField {
    if (textField.text.length > textField.fft_max && textField.fft_max) {
        //判断是否有高亮
        //有高亮不做截取
        //无高亮根据最大位数做截取
        UITextPosition *position = [textField positionFromPosition:textField.markedTextRange.start offset:0];
        if (!position) {
            NSString *text = textField.text;
            text = [text substringToIndex:textField.fft_max];
            textField.text = text;
        }
    }
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
