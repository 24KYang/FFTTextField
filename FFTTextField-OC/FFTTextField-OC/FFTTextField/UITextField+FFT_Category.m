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

#pragma mark ---- 加载
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

#pragma mark ---- 设置代理方法
- (void)fft_setDelegate:(id<UITextFieldDelegate>)delegate {
    [self addTarget:self action:@selector(fft_textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self fft_setDelegate:delegate];
    
    Class delegateClass = [self.delegate class];
    
    fft_exchangeMethod(delegateClass, @selector(textField:shouldChangeCharactersInRange:replacementString:), [self class], @selector(fft_textField:shouldChangeCharactersInRange:replacementString:));
}

#pragma mark ---- 私有方法
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
        Method newMethod = class_getInstanceMethod(originalClass, replacedSel);
        
        if (originalMethod) {
            method_exchangeImplementations(originalMethod, newMethod);            
        }
    }
}

#pragma mark ---- 交换方法
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
    NSString *text = [self fft_filterStringWithType:textField.fft_inputType string:textField.text];
    
    if (text.length > textField.fft_max && textField.fft_max) {
        //判断是否有高亮
        //有高亮不做截取
        //无高亮根据最大位数做截取
        UITextPosition *position = [textField positionFromPosition:textField.markedTextRange.start offset:0];
        if (!position) {
            text = [text substringToIndex:textField.fft_max];
        }
    }
    textField.text = text;
}

- (NSString *)fft_filterStringWithType:(FFTInputType)type string:(NSString *)string {
    
    NSString *filter_string = @"";
    
    if (type & FFTInputTypeCapitalLetters) {
        NSString *cap_string = @"";
        for (char c = 'A'; c < 'Z' ; c++) {
            cap_string = [cap_string stringByAppendingString:[NSString stringWithFormat:@"%c", c]];
        }
        filter_string = cap_string;
    }
    
    if (type & FFTInputTypeLowercaseLetters) {
        NSString *low_string = @"";
        for (char c = 'a'; c < 'z' ; c++) {
            low_string = [low_string stringByAppendingString:[NSString stringWithFormat:@"%c", c]];
        }
        filter_string = [filter_string stringByAppendingString:low_string];
    }
    
    if (type & FFTInputTypeNumber) filter_string = [filter_string stringByAppendingString:@"0123456789"];
    if (type & FFTInputTypeCustom) filter_string = [filter_string stringByAppendingString:[self.fft_enableInputs componentsJoinedByString:@""]];
    
    if (filter_string) {
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:filter_string];
        NSCharacterSet *specCharacterSet = [characterSet invertedSet];
        NSArray *array = [string componentsSeparatedByCharactersInSet:specCharacterSet];
        return [array componentsJoinedByString:@""];
    }
    
    return string;
}

#pragma mark ---- 限制输入最大位数
- (void)setFft_max:(NSUInteger)fft_max {
    SEL key = @selector(fft_max);
    objc_setAssociatedObject(self, key, @(fft_max), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)fft_max {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

#pragma mark ---- 允许输入类型
- (void)setFft_inputType:(FFTInputType)fft_inputType {
    SEL key = @selector(fft_inputType);
    objc_setAssociatedObject(self, key, @(fft_inputType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (FFTInputType)fft_inputType {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

#pragma mark ---- 允许输入的自定义字符集
- (void)setFft_enableInputs:(NSArray *)fft_enableInputs {
    SEL key = @selector(fft_enableInputs);
    objc_setAssociatedObject(self, key, fft_enableInputs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray <NSString *>*)fft_enableInputs {
    return objc_getAssociatedObject(self, _cmd);
}

@end
