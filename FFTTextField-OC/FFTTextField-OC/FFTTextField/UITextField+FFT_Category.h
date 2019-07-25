//
//  UITextField+FFT_Category.h
//  FFTTextField
//
//  Created by 四五20 on 2019/7/18.
//  Copyright © 2019 四五20. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, FFTInputType) {
    FFTInputTypeCustom = 1 << 0,
    FFTInputTypeNumber = 1 << 1,
    FFTInputTypeCapitalLetters = 1 << 2,
    FFTInputTypeLowercaseLetters = 1 << 3,
    FFTInputTypeLetters = FFTInputTypeCapitalLetters | FFTInputTypeLowercaseLetters,
};

@interface UITextField (FFT_Category)
/**
 限制输入最大位数
 */
@property (nonatomic, assign) NSUInteger fft_max;
/**
 允许输入类型 可自由组合，例如：FFTInputTypeNumber | FFTInputTypeCapitalLetters
 筛选的字符可能会有重复的  暂时未做考虑
 */
@property (nonatomic, assign) FFTInputType fft_inputType;
/**
 允许输入的自定义字符集 必须允许输入类型为FFTInputTypeCustom的时候才会生效
 */
@property (nonatomic, strong) NSArray <NSString *>*fft_enableInputs;

@end

NS_ASSUME_NONNULL_END
