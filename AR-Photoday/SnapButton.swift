//
//  SnapButton.swift
//  AR-Photoday
//
//  Created by Joker Lung on 7/5/2018.
//  Copyright © 2018年 Group7. All rights reserved.
//

import UIKit

@IBDesignable
class SnapButton: UIButton {

    @IBInspectable var cornerRadius:CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor:UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }

}
