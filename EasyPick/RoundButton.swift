/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2017C
 Assignment: 3
 Author: Easy Pick
 ID: s3557054 - s3574984 - s3598776
 Created date: 12/01/2018
 Acknowledgement:
 */

import UIKit

@IBDesignable
class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
}
