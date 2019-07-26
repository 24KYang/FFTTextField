# FFTTextField

> 持续更新

## 项目简介
一个关于UITextField的类目

## Object-C

### 使用方式
1.引入头文件`UITextField+FFT_Category.h`
2.签代理、实现代理即可
注:`- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string; `暂时只实现了这一个代理

### fft_max

一行代码设置输入框限制最大位数

```
textField.delegate = self;

textField.fft_max = 5;
```

### fft_inputType

一行代码设置输入框显示文本

```
typedef NS_OPTIONS(NSUInteger, FFTInputType) {
FFTInputTypeCustom = 1 << 0,//自定义，需要配合`fft_enableInputs`使用
FFTInputTypeNumber = 1 << 1,//纯数字
FFTInputTypeCapitalLetters = 1 << 2,//大写字母
FFTInputTypeLowercaseLetters = 1 << 3,//小写字母
FFTInputTypeLetters = FFTInputTypeCapitalLetters | FFTInputTypeLowercaseLetters,//大小写字母
};          
```

1.输入纯数字
```
textField.delegate = self;

textField.fft_inputType = FFTInputTypeNumber;
```

2.输入大写字母
```
textField.delegate = self;

textField.fft_inputType = FFTInputTypeCapitalLetters;
```

3.输入小写字母
```
textField.delegate = self;

textField.fft_inputType = FFTInputTypeLowercaseLetters;
```

4.输入大小写字母
```
textField.delegate = self;

textField.fft_inputType = FFTInputTypeLetters;
```
等同于
```
textField.delegate = self;

textField.fft_inputType = FFTInputTypeCapitalLetters | FFTInputTypeLowercaseLetters;
```

### fft_enableInputs
自由组合
介绍枚举的时候没有介绍自定义这种类型，因为当初设计这种类型的时候就是要配合`fft_enableInputs`属性一起使用的
```
textField.delegate = self;

textField.fft_inputType = FFTInputTypeLetters | FFTInputTypeCustom;

textField.fft_enableInputs = @[@"这是一段测试文字"];
```
这里的话我可以自由输入英文字母和`fft_enableInputs`中设置的字符串

## Swift

### 使用方式
1.签代理、实现代理即可
注:`func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool`暂时只实现了这一个代理

#### fft_max

一行代码设置输入框限制最大位数

```
textField.delegate = self

textField.fft_max = 5
```
#### fft_inputType

一行代码设置输入框显示文本

```
public enum FFTInputType : UInt {
case custom//自定义，需要配合`fft_enableInputs`使用
case number//纯数字
case capitalLetters//大写字母
case lowercaseLetters//小写字母
case letters//大小写字母
}       
```

1.输入纯数字
```
textField.delegate = self

textField.fft_inputType = .number
```

2.输入大写字母
```
textField.delegate = self;

textField.fft_inputType = .capitalLetters
```

3.输入小写字母
```
textField.delegate = self

textField.fft_inputType = .lowercaseLetters
```

4.大小写字母
```
textField.delegate = self

textField.fft_inputType = .letters
```

5.自定义

这里与OC版本不太一样，暂时只能只能实现自定义，不能实现自由组合

```
textField.delegate = self

textField.fft_inputType = .custom

textField.fft_enableInputs = @[@"这是一段测试文字"];
```

