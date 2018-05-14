//
//  ColourPicker.swift
//  AR-Photoday
//
//  Created by Joker Lung on 8/5/2018.
//  Copyright © 2018年 Group7. All rights reserved.
//

import UIKit

protocol ColourPickerDelegate: class{
    func changeColour(_ colour: String?,_ index: Int?)
}

class ColourPicker: UIViewController {
    
    @IBOutlet weak var colorDisplayView: UIView!
    var colourPicker: ChromaColorPicker!
    var initColor: UIColor!
    var arrayIndex: Int!
    var colorCode: String!
    weak var delegate: ColourPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Calculate relative size and origin in bounds */
        let pickerSize = CGSize(width: view.bounds.width*0.8, height: view.bounds.width*0.8)
        let pickerOrigin = CGPoint(x: view.bounds.midX - pickerSize.width/2, y: view.bounds.midY - pickerSize.height/2)
        
        /* Create Color Picker */
        colourPicker = ChromaColorPicker(frame: CGRect(origin: pickerOrigin, size: pickerSize))
        colourPicker.delegate = self as ChromaColorPickerDelegate
        
        /* Customize the view (optional) */
        colourPicker.padding = 10
        colourPicker.stroke = 3 //stroke of the rainbow circle
        colourPicker.currentAngle = Float.pi
        
        /* Customize for grayscale (optional) */
        colourPicker.supportsShadesOfGray = true // false by default
        // colorPicker.colorToggleButton.grayColorGradientLayer.colors = [UIColor.lightGray.cgColor, UIColor.gray.cgColor]
        // You can also override gradient colors
        
        
        colourPicker.hexLabel.textColor = UIColor.white
        
        colourPicker.adjustToColor(initColor)

        colorCode = colourPicker.hexLabel.text
        
        /* Don't want an element like the shade slider? Just hide it: */
        //colorPicker.shadeSlider.hidden = true
        
        self.view.addSubview(colourPicker)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        delegate?.changeColour(colorCode, arrayIndex)
    }
    
    
}



extension ColourPicker: ChromaColorPickerDelegate{
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        //Set color for the display view
        colorCode = colorPicker.hexLabel.text
        // Back to
        navigationController?.popViewController(animated: true)
    }
    
}




