# FFTTextField
一个关于UITextField的类目

> 持续更新

引入头文件`UITextField+FFT_Category.h`

<font color="#dd0000">签代理!!!  签代理!!!  签代理!!!</font><br />

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
```

2.1 输入纯数字
```
fd.fft_inputType = FFTInputTypeNumber;
```

2.2 输入大写字母
```
fd.fft_inputType = FFTInputTypeCapitalLetters;
```

2.3 输入小写字母
```
fd.fft_inputType = FFTInputTypeLowercaseLetters;
```

2.3 自由组合
```
fd.fft_inputType = FFTInputTypeLetters | FFTInputTypeCustom;

fd.fft_enableInputs = @[@"这是一段测试文字"];
```

### 3、设置单位
