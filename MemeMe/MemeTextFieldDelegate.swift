//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Umair Khan on 29/03/2020.
//  Copyright © 2020 NoorifyTech. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldTextFieldDelegate: NSObject, UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM"   {
            textField.text = ""
        }
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
