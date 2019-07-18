//
//  UITextField+FFT_Category.h
//  FFTTextField
//
//  Created by 四五20 on 2019/7/18.
//  Copyright © 2019 四五20. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (FFT_Category)
/**
 限制输入最大位数
 */
@property (nonatomic, assign) NSUInteger fft_max;

@end

NS_ASSUME_NONNULL_END
