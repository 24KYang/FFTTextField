# FFTTextField
一个关于UITextField的类目

> 持续更新

引入头文件`UITextField+FFT_Category.h`

### 1、一行代码设置输入框限制最大位数

```
textField.fft_max = 5;
```

### 2、一行代码设置输入框显示文本

```
//FFTInputTypeCustom            自定义，需要配合`fft_enableInputs`使用
//FFTInputTypeNumber            纯数字
//FFTInputTypeCapitalLetters    大写字母
//FFTInputTypeLowercaseLetters  小写字母
//FFTInputTypeLetters           大小写字母
fd.fft_inputType = FFTInputTypeLetters;
```
