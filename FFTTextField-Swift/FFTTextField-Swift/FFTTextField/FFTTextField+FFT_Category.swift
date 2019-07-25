//
//  FFTTextField+FFT_Category.swift
//  FFTTextField-Swift
//
//  Created by 四五20 on 2019/7/23.
//  Copyright © 2019 四五20. All rights reserved.
//

import Foundation
import UIKit

private var max_key : String = "FFT_MAX_KEY"
private var input_type_key : String = "FFT_INPUT_TYPE_KEY"
private var enable_inputs_key : String = "FFT_ENABLE_INPUTS_KEY"

extension UITextField {
    
    public enum FFTInputType : UInt {
        case custom
        case number
        case capitalLetters
        case lowercaseLetters
        case letters
    }
    
    // MARK: 限制输入最大位数
    public var fft_max : UInt {
        get {
            return (objc_getAssociatedObject(self, &max_key) as? UInt)!
        }
        
        set(newValue) {
            objc_setAssociatedObject(self, &max_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: 允许输入类型(单一枚举，不能如OC一样自由组合，swfit的位移枚举我还没弄明白)
    public var fft_inputType : FFTInputType {
        get {
            return objc_getAssociatedObject(self, &input_type_key) as! UITextField.FFTInputType
        }

        set(newValue) {
            objc_setAssociatedObject(self, &input_type_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: 允许输入的自定义字符集 必须允许输入类型为FFTInputTypeCustom的时候才会生效
    public var fft_enableInputs : Array<String> {
        get {
            return (objc_getAssociatedObject(self, &enable_inputs_key) as! NSArray) as! Array<String>
        }
        
        set(newValue) {
            objc_setAssociatedObject(self, &enable_inputs_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: 初始化交换方法
    public class func initializeMethod() {
        
        let originalSelector = #selector(setter: UITextField.delegate)
    
        let swizzledSelector = #selector(fft_delegate)
        
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        
        let didAddMethod : Bool = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        
        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
        
    }
    
    // MARK: 设置代理
    @objc func fft_delegate(delegate : UITextFieldDelegate) {
        
        self.addTarget(self, action: #selector(fft_textFieldDidChange(textfield:)), for: .editingChanged)
        
        self.fft_delegate(delegate: delegate)
        
        let delegateClass : AnyClass = (self.delegate?.superclass)!
        
        
        fft_exchangeMethod(originalClass: delegateClass, originalSel: #selector(delegate.textField(_:shouldChangeCharactersIn:replacementString:)), replacedClass: self.superclass!, replacedSel: #selector(fft_textField(_:shouldChangeCharactersIn:replacementString:)))
    }
    
    // MARK: textField文字改变
    @objc func fft_textFieldDidChange(textfield : UITextField) {
        print("\(String(describing: textfield.text))")
    }
    
    // MARK: 交换方法
    private func fft_exchangeMethod(originalClass : AnyClass, originalSel : Selector, replacedClass : AnyClass, replacedSel : Selector) {
        let classList = NSMutableArray()
        
        let className : String = NSStringFromClass(originalClass) + "_" + NSStringFromClass(replacedClass)
        
        for item in classList {
            if className == item as? String {
                return
            }
        }
        
        classList.add(className)
        
        let originalMethod : Method = class_getInstanceMethod(originalClass, originalSel)!
        
        let replacedMethod : Method = class_getInstanceMethod(replacedClass, replacedSel)!
        
        let replacedMethodIMP : IMP = method_getImplementation(replacedMethod)
        
        let didAddMethod : Bool = class_addMethod(originalClass, replacedSel, replacedMethodIMP, method_getTypeEncoding(replacedMethod))
        
        if didAddMethod {
            print("class_addMethod failure --> \(NSStringFromSelector(replacedSel))")
        }else {
            print("class_addMethod succeed --> \(NSStringFromSelector(replacedSel))")
        }
        
        let newMethod : Method = class_getInstanceMethod(originalClass, replacedSel)!
        
        method_exchangeImplementations(originalMethod, newMethod)
    }
    
    
    // MARK: 交换系统方法
    @objc private func fft_textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("我已经交换了这个方法了")
        
        if self.responds(to: #selector(fft_textField(_:shouldChangeCharactersIn:replacementString:))) {
            //未设置最大输入位数则调用系统方法 用户可以自己实现此代
            return self.fft_textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        }else {
            return true
        }
    }
}
