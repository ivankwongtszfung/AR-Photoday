//
//  stickerCollectionViewCell.swift
//  AR-Photoday
//
//  Created by Joker Lung on 10/5/2018.
//  Copyright © 2018年 Group7. All rights reserved.
//

import UIKit

class stickerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var sticker: UIImageView!
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected{
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.contentView.backgroundColor = UIColor.black
            }else{
                self.transform = CGAffineTransform.identity
                self.contentView.backgroundColor = UIColor.white
            }
        }
    }

}
