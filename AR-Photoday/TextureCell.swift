//
//  TextureCell.swift
//  AR-Photoday
//
//  Created by Vincent Au on 13/5/2018.
//  Copyright © 2018年 Group7. All rights reserved.
//

import UIKit

class TextureCell: UICollectionViewCell {
    
    @IBOutlet weak var TextureView: UIImageView!
    @IBOutlet weak var TextureLabel: UILabel!
    
    @IBOutlet weak var TickView: UIImageView!
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.contentView.backgroundColor = UIColor.red
                self.TickView.isHidden = false
            }
            else
            {
                self.transform = CGAffineTransform.identity
                self.contentView.backgroundColor = UIColor.gray
                self.TickView.isHidden = true
            }
        }
    }
}
