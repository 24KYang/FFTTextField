//
//  ViewController.swift
//  FFTTextField-Swift
//
//  Created by 四五20 on 2019/7/23.
//  Copyright © 2019 四五20. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadUI()
    }

    func loadUI() {
        self.view.backgroundColor = UIColor.white
        
        let textField = UITextField.init(frame: CGRect(x:100, y:100, width:100, height:30))
        
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        
        textField.delegate = self
        
        textField.fft_max = 5
        
        textField.fft_inputType = .number
        
        view.addSubview(textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
}

