//
//  UITextField+FFT_Category.h
//  FFTTextField
//
//  Created by 四五20 on 2019/7/18.
//  Copyright © 2019 四五20. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FFTInputType) {
    FFTInputTypeCustom = 0,
    FFTInputTypeNumber = 1 << 0,
    FFTInputTypeCapitalLetters = 1 << 1,
    FFTInputTypeLowercaseLetters = 1 << 2,
    FFTInputTypeLetters = FFTInputTypeCapitalLetters | FFTInputTypeLowercaseLetters,
};

@interface UITextField (FFT_Category)
/**
 限制输入最大位数
 */
@property (nonatomic, assign) NSUInteger fft_max;
/**
 允许输入类型
 */
@property (nonatomic, assign) FFTInputType fft_inputType;
/**
 允许输入的自定义字符集 必须允许输入类型为FFTInputTypeCustom的时候才会生效
 */
@property (nonatomic, strong) NSArray <NSString *>*fft_enableInputs;

@end

NS_ASSUME_NONNULL_END
