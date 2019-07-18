//
//  ViewController.m
//  FFTTextField
//
//  Created by 四五20 on 2019/7/18.
//  Copyright © 2019 四五20. All rights reserved.
//

#import "ViewController.h"
#import "UITextField+FFT_Category.h"
#import <objc/runtime.h>

@interface ViewController ()
<
    UITextFieldDelegate
>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITextField *fd = [UITextField new];
    
    fd.placeholder = @"please";
    
    fd.delegate = self;
    
    fd.fft_max = 4;
    
    [self.view addSubview:fd];
    
    fd.frame = CGRectMake(100, 100, 200, 30);
    
    fd.borderStyle = UITextBorderStyleRoundedRect;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

@end
